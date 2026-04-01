/**************************************************************************/
// Function   : 单比特时钟域交叉（CDC）同步器
// Version    : v1.0
// Date       : 2026/05/26
// Description: 将 src_clk 域的 valid 脉冲同步到 dst_clk 域。
//              采用两级触发器消除亚稳态，适用于慢到快或快到慢的单比特信号。
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/05/26  创建文件
/**************************************************************************/

module valid_sync (
  input  wire  src_clk    ,  // 源时钟域时钟
  input  wire  src_rstn   ,  // 源时钟域低有效复位
  input  wire  src_valid  ,  // 源域输入信号（单比特）

  input  wire  dst_clk    ,  // 目标时钟域时钟
  input  wire  dst_rstn   ,  // 目标时钟域低有效复位
  output wire  dst_valid     // 目标域同步输出
);

// ---- 源域：将脉冲展宽为电平（Toggle FF）----
reg  src_toggle_r  ;  // 源域翻转寄存器

always @(posedge src_clk or negedge src_rstn)
  begin
    if (src_rstn == 1'b0)
      begin
        src_toggle_r <= 1'b0;
      end
    else
      begin
        if (src_valid == 1'b1)
          begin
            src_toggle_r <= ~src_toggle_r;  // 每次有效脉冲翻转一次
          end
      end
  end

// ---- 目标域：两级同步触发器（消除亚稳态）----
(* ASYNC_REG = "TRUE" *) reg  sync_r1 ;  // 第一级同步寄存器（可能亚稳态）
(* ASYNC_REG = "TRUE" *) reg  sync_r2 ;  // 第二级同步寄存器（稳定）
reg  sync_r3 ;  // 第三级：用于边沿检测

always @(posedge dst_clk or negedge dst_rstn)
  begin
    if (dst_rstn == 1'b0)
      begin
        sync_r1 <= 1'b0;
        sync_r2 <= 1'b0;
        sync_r3 <= 1'b0;
      end
    else
      begin
        sync_r1 <= src_toggle_r;
        sync_r2 <= sync_r1;
        sync_r3 <= sync_r2;
      end
  end

// ---- 边沿检测：Toggle 变化 → 生成一个目标域脉冲 ----
assign dst_valid = sync_r2 ^ sync_r3;

endmodule
