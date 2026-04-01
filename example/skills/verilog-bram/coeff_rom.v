/**************************************************************************/
// Function   : 系数 ROM（单端口，$readmemh 初始化）
// Version    : v1.0
// Date       : 2026/05/26
// Description: 存储 256 个 16 位滤波器系数，上电后从 coeff.hex 加载。
//              输出寄存器确保综合为真正的 BRAM 资源。
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/05/26  创建文件
/**************************************************************************/

module coeff_rom #(
  parameter DATA_WIDTH = 16 ,  // 数据位宽（滤波系数位宽）
  parameter DEPTH      = 256,  // ROM 深度（系数个数）
  parameter INIT_FILE  = "coeff.hex"  // 初始化文件路径
) (
  input  wire                       clk   ,  // 读时钟
  input  wire [$clog2(DEPTH)-1 : 0] addr  ,  // 读地址
  output reg  [DATA_WIDTH-1     : 0] dout    // 读数据（寄存器输出）
);

// ---- ROM 存储阵列 ----
reg [DATA_WIDTH-1:0] mem [0:DEPTH-1] ;  // ROM 存储体

// ---- 初始化：从十六进制文件加载系数 ----
initial
  begin
    $readmemh(INIT_FILE, mem);
  end

// ---- 单端口同步读 ----
always @(posedge clk)
  begin
    dout <= mem[addr];
  end

endmodule
