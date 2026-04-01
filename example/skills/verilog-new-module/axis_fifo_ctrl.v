/**************************************************************************/
// Function   : AXI-Stream FIFO 控制器
// Version    : v1.0
// Date       : 2026/05/26
// Description: 提供 AXI-Stream 写/读接口，内含同步 FIFO 缓冲区。
//              支持背压握手，输出可编程满标志供上游限流使用。
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/05/26  创建文件
/**************************************************************************/

module axis_fifo_ctrl #(
  parameter DATA_WIDTH = 32 ,  // 数据位宽
  parameter DEPTH      = 512,  // FIFO 深度（须为 2 的幂）
  parameter PROG_FULL  = 480   // 可编程满阈值
) (
  input  wire                        clk           ,  // 系统时钟
  input  wire                        rstn          ,  // 低有效同步复位

  // ---- AXI-Stream 写端口（Slave）----
  input  wire [DATA_WIDTH-1:0]       s_axis_tdata  ,  // 输入数据
  input  wire                        s_axis_tvalid ,  // 输入有效
  output wire                        s_axis_tready ,  // 接收就绪
  input  wire                        s_axis_tlast  ,  // 帧结束标志

  // ---- AXI-Stream 读端口（Master）----
  output wire [DATA_WIDTH-1:0]       m_axis_tdata  ,  // 输出数据
  output wire                        m_axis_tvalid ,  // 输出有效
  input  wire                        m_axis_tready ,  // 下游就绪
  output wire                        m_axis_tlast  ,  // 帧结束透传

  // ---- 状态输出 ----
  output wire [$clog2(DEPTH):0]      fifo_count    ,  // 当前存储数据量
  output wire                        full          ,  // FIFO 满标志
  output wire                        empty         ,  // FIFO 空标志
  output wire                        prog_full        // 可编程满标志
);

// ---- 参数 ----
localparam ADDR_WIDTH = $clog2(DEPTH) ;

// ---- 内部存储（含 tlast 随路存储）----
reg  [DATA_WIDTH:0] mem [0:DEPTH-1] ;  // [DATA_WIDTH] 存 tlast，[DATA_WIDTH-1:0] 存 tdata
reg  [ADDR_WIDTH:0] wr_ptr        ;  // 写指针
reg  [ADDR_WIDTH:0] rd_ptr        ;  // 读指针

// ---- 满/空逻辑 ----
assign full       = ((wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&
                     (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]));
assign empty      = (wr_ptr == rd_ptr);
assign fifo_count = wr_ptr - rd_ptr;
assign prog_full  = (fifo_count >= PROG_FULL) ? 1'b1 : 1'b0;

// ---- AXI-Stream 流控 ----
assign s_axis_tready = ~full;
assign m_axis_tvalid = ~empty;

// ---- 写操作 ----
wire wr_fire = s_axis_tvalid & s_axis_tready;
wire rd_fire = m_axis_tvalid & m_axis_tready;

always @(posedge clk)
  begin
    if (rstn == 1'b0)
      begin
        wr_ptr <= {(ADDR_WIDTH+1){1'b0}};
      end
    else if (wr_fire == 1'b1)
      begin
        mem[wr_ptr[ADDR_WIDTH-1:0]] <= {s_axis_tlast, s_axis_tdata};
        wr_ptr                       <= wr_ptr + 1'b1;
      end
  end

// ---- 读指针 ----
always @(posedge clk)
  begin
    if (rstn == 1'b0)
      begin
        rd_ptr <= {(ADDR_WIDTH+1){1'b0}};
      end
    else if (rd_fire == 1'b1)
      begin
        rd_ptr <= rd_ptr + 1'b1;
      end
  end

// ---- 读数据输出 ----
assign m_axis_tdata = mem[rd_ptr[ADDR_WIDTH-1:0]][DATA_WIDTH-1:0];
assign m_axis_tlast = mem[rd_ptr[ADDR_WIDTH-1:0]][DATA_WIDTH];

endmodule
