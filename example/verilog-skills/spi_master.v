/**************************************************************************/
// Function   : SPI 主机控制器（三线/四线，速率可配置）
// Version    : v1.0
// Date       : 2026/03/26
// Description: 支持三线/四线 SPI，CPOL/CPHA 四种模式，速率分频可配，
//              MSB/LSB 位序可选，数据位宽参数化。
//
//              三线模式（cfg_3wire=1）：SCLK + CS_N + 共享双向数据线
//                顶层需例化 IOBUF，spi_io_oe 控制方向；
//                主机发送时 io_oe=1，接收时 io_oe=0（由上层逻辑切换）。
//              四线模式（cfg_3wire=0）：SCLK + CS_N + MOSI + MISO（全双工）。
//
//              用户接口：
//                s_valid=1 && s_ready=1 → 接受 s_data，开始一次完整传输；
//                传输结束 → m_valid 拉高一拍，m_data 为接收数据；
//                传输期间 s_ready=0，不接受新请求。
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/03/26  创建文件
/**************************************************************************/

`timescale 1ns / 1ps

module spi_master #(
  parameter DATA_W    = 8 ,  // 数据位宽（位），支持 2-16
  parameter CLK_DIV_W = 8    // 分频计数器位宽，SCLK = CLK / (2*(cfg_clk_div+1))
) (
  input  wire                  clk         ,  // 系统时钟
  input  wire                  rst_n       ,  // 低有效异步复位

  // ---- 配置接口（传输开始前配置，传输中保持稳定）----//
  input  wire [CLK_DIV_W-1:0]  cfg_clk_div ,  // 分频系数 N：SCLK = CLK/(2*(N+1))
  input  wire                  cfg_cpol    ,  // 时钟极性：0=空闲低，1=空闲高
  input  wire                  cfg_cpha    ,  // 时钟相位：0=第一沿采样，1=第二沿采样
  input  wire                  cfg_3wire   ,  // 接口模式：1=三线半双工，0=四线全双工
  input  wire                  cfg_lsb     ,  // 位序：0=MSB 先发，1=LSB 先发

  // ---- 用户数据接口 ----//
  input  wire                  s_valid     ,  // 上游数据有效（高电平发起传输）
  output wire                  s_ready     ,  // 上游就绪：IDLE 时为 1
  input  wire [DATA_W-1:0]     s_data      ,  // 待发送数据
  output reg                   m_valid     ,  // 接收完成脉冲（单周期高）
  output reg  [DATA_W-1:0]     m_data      ,  // 接收到的数据

  // ---- SPI 物理接口（四线）----//
  output wire                  spi_sclk    ,  // SPI 时钟输出
  output reg                   spi_cs_n    ,  // 片选输出（低有效）
  output wire                  spi_mosi    ,  // 主发从收（四线时使用）
  input  wire                  spi_miso    ,  // 主收从发（四线时使用）

  // ---- 三线模式双向数据总线控制（接外部 IOBUF）----//
  output wire                  spi_io_oe   ,  // 双向 IO 方向：1=主机输出，0=主机输入
  output wire                  spi_io_out  ,  // 双向 IO 输出数据（接 IOBUF.I）
  input  wire                  spi_io_in      // 双向 IO 输入数据（接 IOBUF.O）
);

// ---- 状态编码 ----//
localparam [1:0] IDLE     = 2'd0 ;  // 空闲，等待传输请求
localparam [1:0] CS_SETUP = 2'd1 ;  // 片选建立：CS_N 拉低，预装首 bit，启动分频
localparam [1:0] TRANSFER = 2'd2 ;  // 移位传输中
localparam [1:0] CS_HOLD  = 2'd3 ;  // 传输结束：等 SCLK 回空闲极性后拉高 CS_N

// ---- 内部寄存器 ----//
reg [1:0]            state_r      ;  // 当前状态
reg [CLK_DIV_W-1:0]  div_cnt_r    ;  // 半周期分频计数器
reg                  sclk_en_r    ;  // SCLK 分频器使能
reg                  sclk_r       ;  // SCLK 当前电平
reg [DATA_W-1:0]     tx_shift_r   ;  // 发送移位寄存器
reg [DATA_W-1:0]     rx_shift_r   ;  // 接收移位寄存器
reg                  mosi_r       ;  // MOSI/IO 输出数据寄存器
reg [3:0]            bit_cnt_r    ;  // 已完成采样 bit 数（最大支持 DATA_W=16）
reg                  first_edge_r ;  // CPHA=1 时首沿标志：首沿仅移位，不采样

// ---- 组合逻辑 ----//

// 半周期完成标志
wire div_tick = (div_cnt_r == cfg_clk_div) ;

// SCLK 即将上升 / 即将下降（均在 div_tick 当拍有效）
wire sclk_rising  = div_tick && (sclk_r == 1'b0) ;
wire sclk_falling = div_tick && (sclk_r == 1'b1) ;

// 采样沿与移位沿（由 CPOL/CPHA 决定，四种模式均适用）
//   CPOL=0 CPHA=0 → 上升采样，下降移位（Mode 0）
//   CPOL=0 CPHA=1 → 下降采样，上升移位（Mode 1）
//   CPOL=1 CPHA=0 → 下降采样，上升移位（Mode 2）
//   CPOL=1 CPHA=1 → 上升采样，下降移位（Mode 3）
wire sample_on_rise_w = ~(cfg_cpol ^ cfg_cpha)                        ;
wire sample_en        = sample_on_rise_w ? sclk_rising  : sclk_falling ;
wire shift_en         = sample_on_rise_w ? sclk_falling : sclk_rising  ;

// MISO 来源选择：三线取共享 IO，四线取独立 MISO 管脚
wire miso_in = cfg_3wire ? spi_io_in : spi_miso ;

// 当前待发送 bit（MSB 或 LSB 优先）
wire tx_bit = cfg_lsb ? tx_shift_r[0] : tx_shift_r[DATA_W-1] ;

// 下一拍接收移位寄存器的值（在采样沿时有效）
wire [DATA_W-1:0] rx_next_w = cfg_lsb
                               ? {miso_in, rx_shift_r[DATA_W-1:1]}
                               : {rx_shift_r[DATA_W-2:0], miso_in} ;

// ---- 对外输出连接 ----//
assign s_ready    = (state_r == IDLE)                                          ;
assign spi_sclk   = sclk_r                                                     ;
assign spi_mosi   = mosi_r                                                     ;
assign spi_io_out = mosi_r                                                     ;
// 三线：传输期间主机输出使能；四线：MOSI 始终输出，io_oe 固定为 1
assign spi_io_oe  = (~cfg_3wire) | (state_r == CS_SETUP) | (state_r == TRANSFER) ;

// ---- 分频计数器 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      div_cnt_r <= {CLK_DIV_W{1'b0}} ;
    else if (!sclk_en_r || div_tick)
      div_cnt_r <= {CLK_DIV_W{1'b0}} ;
    else
      div_cnt_r <= div_cnt_r + 1'b1 ;
  end

// ---- SCLK 生成 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      sclk_r <= 1'b0 ;
    else if (!sclk_en_r)
      sclk_r <= cfg_cpol ;  // 非传输时保持空闲极性
    else if (div_tick)
      sclk_r <= ~sclk_r ;
  end

// ---- 主状态机 + 数据通路 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        state_r      <= IDLE            ;
        sclk_en_r    <= 1'b0           ;
        spi_cs_n     <= 1'b1           ;
        m_valid      <= 1'b0           ;
        m_data       <= {DATA_W{1'b0}} ;
        mosi_r       <= 1'b0           ;
        tx_shift_r   <= {DATA_W{1'b0}} ;
        rx_shift_r   <= {DATA_W{1'b0}} ;
        bit_cnt_r    <= 4'd0           ;
        first_edge_r <= 1'b0           ;
      end
    else
      begin
        m_valid <= 1'b0 ;  // 默认不输出，采样完成时置 1

        case (state_r)

          // ---- 空闲：等待用户发起传输 ----//
          IDLE :
            begin
              spi_cs_n  <= 1'b1 ;
              sclk_en_r <= 1'b0 ;
              if (s_valid == 1'b1)
                begin
                  tx_shift_r <= s_data         ;
                  rx_shift_r <= {DATA_W{1'b0}} ;
                  bit_cnt_r  <= 4'd0           ;
                  state_r    <= CS_SETUP       ;
                end
            end

          // ---- 片选建立：CS_N 拉低，预装首 bit，启动 SCLK 分频 ----//
          CS_SETUP :
            begin
              spi_cs_n     <= 1'b0    ;  // 片选拉低
              mosi_r       <= tx_bit  ;  // 预装首 bit（CPHA=0 必须在首沿前有效）
              sclk_en_r    <= 1'b1    ;  // 启动分频器
              first_edge_r <= cfg_cpha;  // CPHA=1 时首移位沿不更新 MOSI（已预装）
              state_r      <= TRANSFER ;
            end

          // ---- 数据传输 ----//
          TRANSFER :
            begin
              // 采样沿：将 MISO 移入接收寄存器，bit 计数递增
              if (sample_en == 1'b1)
                begin
                  rx_shift_r <= rx_next_w    ;
                  bit_cnt_r  <= bit_cnt_r + 1'b1 ;

                  // 最后一 bit 采样完毕：输出接收数据，进入结束阶段
                  if (bit_cnt_r == (DATA_W - 1))
                    begin
                      m_data  <= rx_next_w  ;
                      m_valid <= 1'b1       ;
                      state_r <= CS_HOLD    ;
                    end
                end

              // 移位沿：更新 MOSI 输出
              if (shift_en == 1'b1)
                begin
                  if (first_edge_r == 1'b1)
                    begin
                      // CPHA=1 首移位沿：MOSI 已由 CS_SETUP 预装，仅清除首沿标志
                      first_edge_r <= 1'b0 ;
                    end
                  else if (bit_cnt_r < DATA_W[3:0])
                    begin
                      // 普通移位：推进移位寄存器，更新 MOSI
                      if (cfg_lsb == 1'b1)
                        begin
                          tx_shift_r <= {1'b0, tx_shift_r[DATA_W-1:1]} ;
                          mosi_r     <= tx_shift_r[1]                   ;
                        end
                      else
                        begin
                          tx_shift_r <= {tx_shift_r[DATA_W-2:0], 1'b0} ;
                          mosi_r     <= tx_shift_r[DATA_W-2]            ;
                        end
                    end
                end
            end

          // ---- 片选释放：等 SCLK 回空闲极性后拉高 CS_N ----//
          CS_HOLD :
            begin
              if (sclk_r == cfg_cpol)
                begin
                  sclk_en_r <= 1'b0 ;
                  spi_cs_n  <= 1'b1 ;
                  state_r   <= IDLE ;
                end
            end

          default :
            begin
              state_r <= IDLE ;
            end

        endcase
      end
  end

endmodule
