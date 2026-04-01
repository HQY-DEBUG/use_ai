/**************************************************************************/
// Function   : UART 接收模块
// Version    : v1.0
// Date       : 2026/03/23
// Description: 实现 UART 串口接收功能，支持可配置波特率，
//              接收完成后输出 8bit 数据及有效脉冲
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/03/23  创建文件
/**************************************************************************/

module uart_rx #(
  parameter CLK_FREQ  = 50_000_000 ,  // 系统时钟频率（Hz）
  parameter BAUD_RATE = 115200         // 波特率
) (
  input  wire       clk        ,  // 系统时钟
  input  wire       rst_n      ,  // 低有效复位
  input  wire       i_rx       ,  // UART 串行输入
  output reg  [7:0] o_data     ,  // 接收到的 8bit 数据
  output reg        o_data_vld    // 数据有效脉冲（高电平持续1周期）
);

// ---- 参数定义 ----//
localparam BAUD_DIV = CLK_FREQ / BAUD_RATE ;  // 每bit对应的时钟周期数
localparam BAUD_MID = BAUD_DIV / 2         ;  // 采样中点

// ---- 信号声明 ----//
reg        rx_r       ;  // 输入同步寄存器
reg        rx_r2      ;  // 两级同步防亚稳态
reg [15:0] baud_cnt_r ;  // 波特率计数器
reg [ 3:0] bit_cnt_r  ;  // bit 位计数器（0~9：起始+8数据+停止）
reg        busy_r     ;  // 接收忙标志
reg [ 7:0] shift_r    ;  // 移位寄存器

// ---- 输入同步（防亚稳态）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        rx_r  <= 1'b1 ;
        rx_r2 <= 1'b1 ;
      end
    else
      begin
        rx_r  <= i_rx  ;
        rx_r2 <= rx_r  ;
      end
  end

// ---- 波特率计数器 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        baud_cnt_r <= 16'd0 ;
      end
    else if (busy_r == 1'b1)
      begin
        baud_cnt_r <= (baud_cnt_r == BAUD_DIV - 1) ? 16'd0 : baud_cnt_r + 16'd1 ;
      end
    else
      begin
        baud_cnt_r <= 16'd0 ;
      end
  end

// ---- bit 位计数器 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        bit_cnt_r <= 4'd0 ;
      end
    else if (busy_r == 1'b0 && rx_r2 == 1'b0)  // 检测起始位下降沿
      begin
        bit_cnt_r <= 4'd0 ;
      end
    else if (baud_cnt_r == BAUD_DIV - 1)
      begin
        bit_cnt_r <= bit_cnt_r + 4'd1 ;
      end
  end

// ---- 忙标志 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        busy_r <= 1'b0 ;
      end
    else if (busy_r == 1'b0 && rx_r2 == 1'b0)  // 起始位触发
      begin
        busy_r <= 1'b1 ;
      end
    else if (bit_cnt_r == 4'd9 && baud_cnt_r == BAUD_DIV - 1)  // 停止位结束
      begin
        busy_r <= 1'b0 ;
      end
  end

// ---- 数据采样（在每bit中点采样）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        shift_r   <= 8'd0  ;
        o_data    <= 8'd0  ;
        o_data_vld <= 1'b0 ;
      end
    else
      begin
        o_data_vld <= 1'b0 ;  // 默认低电平
        if (busy_r == 1'b1 && baud_cnt_r == BAUD_MID)
          begin
            if (bit_cnt_r >= 4'd1 && bit_cnt_r <= 4'd8)
              begin
                // 2026/03/23 新增：LSB 先接收，右移移位
                shift_r <= {rx_r2, shift_r[7:1]} ;
              end
            else if (bit_cnt_r == 4'd9)  // 停止位中点输出数据
              begin
                o_data     <= shift_r    ;
                o_data_vld <= 1'b1       ;
              end
          end
      end
  end

endmodule
