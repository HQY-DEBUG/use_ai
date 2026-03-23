/**************************************************************************/
// Function   : AXI-Stream 数据位宽转换模块
// Version    : v1.0
// Date       : 2026/03/23
// Description: 将 32bit AXI-Stream 数据流拆分为两路 16bit 输出，
//              展示本项目 Verilog 编码规范的完整用法
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/03/23  创建文件
/**************************************************************************/

module axis_data_width_conv #(
  parameter IN_WIDTH  = 32 ,  // 输入数据位宽
  parameter OUT_WIDTH = 16    // 输出数据位宽
) (
  input  wire                  clk           ,  // 系统时钟
  input  wire                  rst_n         ,  // 低有效复位
  // ---- 从机接口（输入）----//
  input  wire [IN_WIDTH-1:0]   s_axis_tdata  ,  // 输入数据
  input  wire                  s_axis_tvalid ,  // 输入有效
  output reg                   s_axis_tready ,  // 输入就绪
  // ---- 主机接口（高16bit 输出）----//
  output reg  [OUT_WIDTH-1:0]  m0_axis_tdata ,  // 高16bit 数据
  output reg                   m0_axis_tvalid,  // 高16bit 有效
  // ---- 主机接口（低16bit 输出）----//
  output reg  [OUT_WIDTH-1:0]  m1_axis_tdata ,  // 低16bit 数据
  output reg                   m1_axis_tvalid   // 低16bit 有效
);

// ---- 信号声明 ----//
reg               is_valid_r ;  // 数据有效锁存标志
reg [IN_WIDTH-1:0] data_r    ;  // 数据锁存寄存器

// ---- 握手控制（组合逻辑）----//
always @(*)
  begin
    s_axis_tready = ~is_valid_r ;
  end

// ---- 数据锁存（时序逻辑）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        is_valid_r <= 1'b0             ;
        data_r     <= {IN_WIDTH{1'b0}} ;
      end
    else if (s_axis_tvalid == 1'b1 && s_axis_tready == 1'b1)
      begin
        // 2026/03/23 新增：握手成功时锁存数据
        is_valid_r <= 1'b1         ;
        data_r     <= s_axis_tdata ;
      end
    else
      begin
        is_valid_r <= 1'b0 ;
      end
  end

// ---- 拆分输出（时序逻辑）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        m0_axis_tdata  <= {OUT_WIDTH{1'b0}} ;
        m0_axis_tvalid <= 1'b0              ;
        m1_axis_tdata  <= {OUT_WIDTH{1'b0}} ;
        m1_axis_tvalid <= 1'b0              ;
      end
    else if (is_valid_r == 1'b1)
      begin
        m0_axis_tdata  <= data_r[IN_WIDTH-1:OUT_WIDTH] ;  // 高16bit
        m0_axis_tvalid <= 1'b1                         ;
        m1_axis_tdata  <= data_r[OUT_WIDTH-1:0]        ;  // 低16bit
        m1_axis_tvalid <= 1'b1                         ;
      end
    else
      begin
        m0_axis_tvalid <= 1'b0 ;
        m1_axis_tvalid <= 1'b0 ;
      end
  end

endmodule
