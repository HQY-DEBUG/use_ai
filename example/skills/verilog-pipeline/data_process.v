/**************************************************************************/
// Function   : 3 级流水线数据处理模块（带 valid/ready 握手）
// Version    : v1.0
// Date       : 2026/05/26
// Description: 对 32 位输入数据执行三级流水线运算：
//              级1 — 缩放（乘以系数）
//              级2 — 偏移（加常数）
//              级3 — 饱和截断（限幅至 16 位）
//              每级均传递 valid/ready 握手信号，支持背压。
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/05/26  创建文件
/**************************************************************************/

module data_process #(
  parameter DATA_WIDTH  = 32,  // 输入/输出数据位宽
  parameter SCALE_COEFF = 3,   // 级1 缩放系数（整数近似，右移实现）
  parameter OFFSET_VAL  = 100  // 级2 偏移常数
) (
  input  wire                  clk          ,  // 系统时钟
  input  wire                  rstn         ,  // 低有效复位

  // ---- 输入握手 ----
  input  wire [DATA_WIDTH-1:0] s_data       ,  // 输入数据
  input  wire                  s_valid      ,  // 输入有效
  output wire                  s_ready      ,  // 输入就绪

  // ---- 输出握手 ----
  output reg  [DATA_WIDTH-1:0] m_data       ,  // 输出数据（已处理）
  output reg                   m_valid      ,  // 输出有效
  input  wire                  m_ready         // 输出就绪
);

// ---- 流水线级间寄存器 ----
reg  [DATA_WIDTH-1:0] pipe1_data_r  ;  // 级1 数据
reg                   pipe1_valid_r ;  // 级1 有效

reg  [DATA_WIDTH-1:0] pipe2_data_r  ;  // 级2 数据
reg                   pipe2_valid_r ;  // 级2 有效

// 当输出可以接受或自身无有效数据时，允许移入新数据
wire pipe3_ready = m_ready | ~m_valid;
wire pipe2_ready = pipe3_ready | ~pipe2_valid_r;
wire pipe1_ready = pipe2_ready | ~pipe1_valid_r;

assign s_ready = pipe1_ready;

// ============================================================
// 级1：缩放（data * SCALE_COEFF → 右移 2 近似除以 4，净系数 ≈ 3/4）
// ============================================================
always @(posedge clk or negedge rstn)
  begin
    if (rstn == 1'b0)
      begin
        pipe1_data_r  <= {DATA_WIDTH{1'b0}};
        pipe1_valid_r <= 1'b0;
      end
    else if (pipe1_ready == 1'b1)
      begin
        pipe1_valid_r <= s_valid;
        if (s_valid == 1'b1)
          begin
            // v1.0 2026/05/26 新增：乘以 3 后右移 2（近似 *0.75）
            pipe1_data_r <= (s_data + (s_data << 1)) >> 2;
          end
      end
  end

// ============================================================
// 级2：偏移（加 OFFSET_VAL）
// ============================================================
always @(posedge clk or negedge rstn)
  begin
    if (rstn == 1'b0)
      begin
        pipe2_data_r  <= {DATA_WIDTH{1'b0}};
        pipe2_valid_r <= 1'b0;
      end
    else if (pipe2_ready == 1'b1)
      begin
        pipe2_valid_r <= pipe1_valid_r;
        if (pipe1_valid_r == 1'b1)
          begin
            pipe2_data_r <= pipe1_data_r + OFFSET_VAL;
          end
      end
  end

// ============================================================
// 级3：饱和截断（限幅至 [0, 2^16-1]）
// ============================================================
always @(posedge clk or negedge rstn)
  begin
    if (rstn == 1'b0)
      begin
        m_data  <= {DATA_WIDTH{1'b0}};
        m_valid <= 1'b0;
      end
    else if (pipe3_ready == 1'b1)
      begin
        m_valid <= pipe2_valid_r;
        if (pipe2_valid_r == 1'b1)
          begin
            // 饱和限幅：超过 16'hFFFF 时截断
            if (pipe2_data_r[DATA_WIDTH-1:16] != {(DATA_WIDTH-16){1'b0}})
              begin
                m_data <= {{(DATA_WIDTH-16){1'b0}}, 16'hFFFF};  // 正向饱和
              end
            else
              begin
                m_data <= pipe2_data_r;
              end
          end
      end
  end

endmodule
