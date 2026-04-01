/**************************************************************************/
// Function   : SPI 主机控制器有限状态机（FSM）
// Version    : v1.0
// Date       : 2026/05/26
// Description: 实现 SPI Mode0（CPOL=0, CPHA=0）帧传输控制状态机。
//              状态：IDLE → START → DATA → STOP → IDLE
//              每帧 16 位，CS 片选低有效。
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/05/26  创建文件
/**************************************************************************/

module spi_master_fsm #(
  parameter CLK_DIV  = 4,   // SPI 时钟分频比（SCK = CLK / CLK_DIV）
  parameter DATA_LEN = 16   // 每帧位数
) (
  input  wire        clk       ,  // 系统时钟
  input  wire        rstn      ,  // 低有效复位
  input  wire        start     ,  // 发送触发（脉冲）
  input  wire [15:0] tx_data   ,  // 待发送数据
  output reg  [15:0] rx_data   ,  // 接收数据
  output wire        busy      ,  // 忙标志（传输中为 1）
  output reg         spi_csn   ,  // SPI 片选（低有效）
  output reg         spi_sck   ,  // SPI 时钟
  output reg         spi_mosi  ,  // SPI 主发从收
  input  wire        spi_miso     // SPI 主收从发
);

// ---- 状态定义 ----
localparam ST_IDLE  = 2'd0 ;  // 空闲，等待 start
localparam ST_START = 2'd1 ;  // 拉低 CS，准备第一个 bit
localparam ST_DATA  = 2'd2 ;  // 逐位发送/接收 DATA_LEN 位
localparam ST_STOP  = 2'd3 ;  // 最后一位后拉高 CS

// ---- 内部寄存器 ----
reg  [1:0]              state_r     ;  // 当前状态
reg  [$clog2(DATA_LEN):0] bit_cnt_r ;  // 已传输位计数
reg  [$clog2(CLK_DIV):0]  div_cnt_r ;  // 分频计数器
reg  [15:0]             shift_tx_r  ;  // 发送移位寄存器
reg  [15:0]             shift_rx_r  ;  // 接收移位寄存器
reg                     sck_en_r    ;  // SCK 使能

assign busy = (state_r != ST_IDLE) ? 1'b1 : 1'b0;

// ---- 状态机主体 ----
always @(posedge clk or negedge rstn)
  begin
    if (rstn == 1'b0)
      begin
        state_r    <= ST_IDLE;
        bit_cnt_r  <= {($clog2(DATA_LEN)+1){1'b0}};
        div_cnt_r  <= {($clog2(CLK_DIV)+1){1'b0}};
        shift_tx_r <= 16'd0;
        shift_rx_r <= 16'd0;
        rx_data    <= 16'd0;
        spi_csn    <= 1'b1;
        spi_sck    <= 1'b0;
        spi_mosi   <= 1'b0;
        sck_en_r   <= 1'b0;
      end
    else
      begin
        case (state_r)
          // ---- IDLE：等待 start 触发 ----
          ST_IDLE :
            begin
              spi_csn   <= 1'b1;
              spi_sck   <= 1'b0;
              spi_mosi  <= 1'b0;
              sck_en_r  <= 1'b0;
              if (start == 1'b1)
                begin
                  shift_tx_r <= tx_data;
                  bit_cnt_r  <= {($clog2(DATA_LEN)+1){1'b0}};
                  div_cnt_r  <= {($clog2(CLK_DIV)+1){1'b0}};
                  state_r    <= ST_START;
                end
            end

          // ---- START：拉低 CS，等待半个 SCK 周期 ----
          ST_START :
            begin
              spi_csn <= 1'b0;
              if (div_cnt_r == CLK_DIV - 1)
                begin
                  div_cnt_r  <= {($clog2(CLK_DIV)+1){1'b0}};
                  spi_mosi   <= shift_tx_r[DATA_LEN-1];  // 最高位先出
                  state_r    <= ST_DATA;
                end
              else
                begin
                  div_cnt_r <= div_cnt_r + 1'b1;
                end
            end

          // ---- DATA：以 SCK 节拍逐位移出/移入 ----
          ST_DATA :
            begin
              if (div_cnt_r == CLK_DIV/2 - 1)
                begin
                  spi_sck   <= 1'b1;  // SCK 上升沿：从机采样 MOSI
                  shift_rx_r <= {shift_rx_r[14:0], spi_miso};  // 采样 MISO
                  div_cnt_r  <= div_cnt_r + 1'b1;
                end
              else if (div_cnt_r == CLK_DIV - 1)
                begin
                  spi_sck   <= 1'b0;  // SCK 下降沿：更新 MOSI
                  div_cnt_r <= {($clog2(CLK_DIV)+1){1'b0}};
                  if (bit_cnt_r == DATA_LEN - 1)
                    begin
                      rx_data <= shift_rx_r;
                      state_r <= ST_STOP;
                    end
                  else
                    begin
                      bit_cnt_r  <= bit_cnt_r + 1'b1;
                      shift_tx_r <= {shift_tx_r[14:0], 1'b0};  // 左移
                      spi_mosi   <= shift_tx_r[DATA_LEN-2];
                    end
                end
              else
                begin
                  div_cnt_r <= div_cnt_r + 1'b1;
                end
            end

          // ---- STOP：拉高 CS，回到 IDLE ----
          ST_STOP :
            begin
              spi_csn  <= 1'b1;
              spi_sck  <= 1'b0;
              spi_mosi <= 1'b0;
              state_r  <= ST_IDLE;
            end

          default :
            begin
              state_r <= ST_IDLE;
            end
        endcase
      end
  end

endmodule
