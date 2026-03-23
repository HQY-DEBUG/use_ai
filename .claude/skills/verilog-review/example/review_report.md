# Verilog 规范审查示例报告

> 此文件展示 `/verilog-review` 技能的输出格式，
> 以一段存在多处违规的代码为例。

---

## 被审查代码（违规示例）

```verilog
module bad_example(clk, rst, data_in, data_out);
input clk;
input rst;
input [15:0] data_in;
output [15:0] data_out;

reg [15:0] data_out;
reg [3:0] cnt;

always @(posedge clk or posedge rst) begin   // ❌ begin 未另起一行
    if (rst == 0) begin                       // ❌ 单bit用裸露的 0
        cnt <= 0;                             // ❌ 单bit用裸露的 0
        data_out <= 0;
    end else begin
        cnt <= cnt + 1;
        data_out <= data_in;
    end
end

always @(*) begin                             // ❌ begin 未另起一行
    if (cnt == 4'hF)
        data_out = data_in + 1;               // ❌ 时序/组合混用
end

endmodule
```

---

## 审查报告

```
== Verilog 规范审查报告：bad_example.v ==

✅ 通过项：3 项
❌ 违规项：6 项

违规详情：
  [行  1] 文件头：缺少标准文件头（Function/Version/Date/Modify）
  [行  1] 端口声明：端口未对齐，缺少中文注释
  [行 10] begin 换行：begin 与 always 写在同一行，应另起一行
  [行 11] 常量规范：单bit比较使用裸露的 == 0，应使用 == 1'b0
  [行 12] 常量规范：单bit赋值使用裸露的 <= 0，应使用 <= 1'b0
  [行 19] begin 换行：begin 与 always @(*) 写在同一行，应另起一行

建议：补充文件头模板；将所有 begin 移至下一行；
      单bit信号赋值/比较统一使用 1'b0 / 1'b1；
      端口声明每行一个信号并添加中文注释。
```

---

## 修正后代码

```verilog
/**************************************************************************/
// Function   : 示例模块（修正版）
// Version    : v1.0
// Date       : 2026/03/23
// Description: 演示规范修正结果
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/03/23  创建文件
/**************************************************************************/

module bad_example #(
  parameter DATA_WIDTH = 16
) (
  input  wire                  clk      ,  // 系统时钟
  input  wire                  rst_n    ,  // 低有效复位
  input  wire [DATA_WIDTH-1:0] data_in  ,  // 输入数据
  output reg  [DATA_WIDTH-1:0] data_out    // 输出数据
);

// ---- 信号声明 ----//
reg [3:0] cnt_r ;  // 计数器

// ---- 时序逻辑 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        cnt_r    <= 4'd0             ;
        data_out <= {DATA_WIDTH{1'b0}} ;
      end
    else
      begin
        cnt_r    <= cnt_r + 4'd1 ;
        data_out <= data_in      ;
      end
  end

endmodule
```
