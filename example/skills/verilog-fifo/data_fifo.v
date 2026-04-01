/**************************************************************************/
// Function   : 同步 FIFO（单时钟，二进制指针）
// Version    : v1.0
// Date       : 2026/05/26
// Description: 深度 512，位宽 32 位的同步 FIFO。
//              使用二进制读写指针，满/空标志由指针差值计算。
//              综合目标：Xilinx BRAM 资源。
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/05/26  创建文件
/**************************************************************************/

module data_fifo #(
  parameter DATA_WIDTH = 32 ,  // 数据位宽
  parameter DEPTH      = 512   // FIFO 深度（须为 2 的幂）
) (
  input  wire                  clk      ,  // 系统时钟
  input  wire                  rstn     ,  // 低有效同步复位

  // ---- 写端口 ----
  input  wire [DATA_WIDTH-1:0] wr_data  ,  // 写入数据
  input  wire                  wr_en    ,  // 写使能（满时写入无效）
  output wire                  full     ,  // FIFO 满标志

  // ---- 读端口 ----
  output wire [DATA_WIDTH-1:0] rd_data  ,  // 读出数据（同步读，下一拍有效）
  input  wire                  rd_en    ,  // 读使能（空时读取无效）
  output wire                  empty    ,  // FIFO 空标志

  // ---- 状态 ----
  output wire [$clog2(DEPTH):0] data_count  // 当前存储数据量
);

// ---- 参数校验：深度须为 2 的幂 ----
localparam ADDR_WIDTH = $clog2(DEPTH) ;  // 地址位宽

// ---- 内部信号 ----
reg  [DATA_WIDTH-1:0] mem    [0:DEPTH-1] ;  // 存储阵列
reg  [ADDR_WIDTH:0]   wr_ptr             ;  // 写指针（多一位用于满/空判断）
reg  [ADDR_WIDTH:0]   rd_ptr             ;  // 读指针

// ---- 满/空判断 ----
// 写指针超过读指针 DEPTH 个位置时满；相等时空
assign full       = ((wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&
                     (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]));
assign empty      = (wr_ptr == rd_ptr);
assign data_count = wr_ptr - rd_ptr;

// ---- 写操作 ----
always @(posedge clk)
  begin
    if (rstn == 1'b0)
      begin
        wr_ptr <= {(ADDR_WIDTH+1){1'b0}};
      end
    else
      begin
        if (wr_en == 1'b1 && full == 1'b0)
          begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
            wr_ptr                       <= wr_ptr + 1'b1;
          end
      end
  end

// ---- 读指针更新 ----
always @(posedge clk)
  begin
    if (rstn == 1'b0)
      begin
        rd_ptr <= {(ADDR_WIDTH+1){1'b0}};
      end
    else
      begin
        if (rd_en == 1'b1 && empty == 1'b0)
          begin
            rd_ptr <= rd_ptr + 1'b1;
          end
      end
  end

// ---- 同步读出（读使能后下一拍数据有效）----
assign rd_data = mem[rd_ptr[ADDR_WIDTH-1:0]];

endmodule
