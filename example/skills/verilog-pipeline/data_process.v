/**************************************************************************/
// Function   : 3 级流水线数据处理模块
// Version    : v1.0
// Date       : 2026/04/01
// Description: 带 valid/ready 握手的 3 级寄存器流水线
//              级1 — 数据缩放（乘以系数）
//              级2 — 偏移（加常数）
//              级3 — 饱和截断（限幅至 16 位）
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/04/01  创建文件
/**************************************************************************/

module data_process #(
  parameter DATA_W = 32 ,  // 数据位宽
  parameter STAGES = 3     // 流水线级数
) (
  input  wire              clk     ,  // 系统时钟
  input  wire              rst_n   ,  // 低有效复位
  // ---- 输入握手 ----//
  input  wire              s_valid ,  // 上游数据有效
  output wire              s_ready ,  // 上游就绪（背压）
  input  wire [DATA_W-1:0] s_data  ,  // 输入数据
  // ---- 输出握手 ----//
  output wire              m_valid ,  // 下游数据有效
  input  wire              m_ready ,  // 下游就绪
  output wire [DATA_W-1:0] m_data     // 输出数据
);

// ---- 流水线寄存器 ----//
reg [DATA_W-1:0] pipe_data_r  [0:STAGES-1] ;  // 数据寄存器链
reg              pipe_valid_r [0:STAGES-1] ;  // 有效位寄存器链

// ---- 背压信号：只有最后一级满且下游不就绪时反压 ----//
wire pipe_en ;
assign pipe_en = m_ready || !pipe_valid_r[STAGES-1] ;
assign s_ready = pipe_en ;
assign m_valid = pipe_valid_r[STAGES-1] ;
assign m_data  = pipe_data_r [STAGES-1] ;

// ---- 第 0 级（直接接收输入）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        pipe_valid_r[0] <= 1'b0 ;
        pipe_data_r [0] <= {DATA_W{1'b0}} ;
      end
    else if (pipe_en == 1'b1)
      begin
        pipe_valid_r[0] <= s_valid ;
        pipe_data_r [0] <= s_data + (s_data << 1) ;  // 级1：乘以3（近似缩放）
      end
  end

// ---- 第 1 级 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        pipe_valid_r[1] <= 1'b0 ;
        pipe_data_r [1] <= {DATA_W{1'b0}} ;
      end
    else if (pipe_en == 1'b1)
      begin
        pipe_valid_r[1] <= pipe_valid_r[0] ;
        pipe_data_r [1] <= pipe_data_r[0] + 32'd100 ;  // 级2：加偏移常数
      end
  end

// ---- 第 2 级（最后一级）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        pipe_valid_r[2] <= 1'b0 ;
        pipe_data_r [2] <= {DATA_W{1'b0}} ;
      end
    else if (pipe_en == 1'b1)
      begin
        pipe_valid_r[2] <= pipe_valid_r[1] ;
        // 级3：饱和截断，限幅至 16 位最大值
        if (pipe_data_r[1][DATA_W-1:16] != {(DATA_W-16){1'b0}})
          begin
            pipe_data_r[2] <= {{(DATA_W-16){1'b0}}, 16'hFFFF} ;
          end
        else
          begin
            pipe_data_r[2] <= pipe_data_r[1] ;
          end
      end
  end

endmodule
