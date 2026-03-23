# Verilog RTL 质量审查示例

## 被审查代码（含问题）

```verilog
// fifo_ctrl.v  —— 存在多处 RTL 质量问题
module fifo_ctrl (
    input  clk,
    input  rst_n,
    input  wr_en,
    input  rd_en,
    input  [7:0] din,
    output [7:0] dout,
    output full,
    output empty
);

reg [7:0] mem [0:15];
reg [3:0] wr_ptr;
reg [3:0] rd_ptr;
reg [4:0] cnt;
reg [7:0] dout;

// 问题1：时序块使用了阻塞赋值
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt = 0;                    // ❌ 应用 <=
    else if (wr_en && !full)
        cnt = cnt + 1;              // ❌ 应用 <=
    else if (rd_en && !empty)
        cnt = cnt - 1;              // ❌ 应用 <=
end

// 问题2：组合逻辑缺少 default，会产生锁存器
always @(*) begin
    if (wr_en)
        dout = mem[rd_ptr];         // ❌ 缺少 else 分支，dout 会被锁存
end

// 问题3：单 bit 赋值未写位宽
assign full  = (cnt == 16) ? 1 : 0; // ❌ 应用 1'b1 / 1'b0
assign empty = (cnt == 0)  ? 1 : 0; // ❌ 应用 1'b1 / 1'b0

endmodule
```

---

## 审查报告

```
== Verilog RTL 质量审查报告：fifo_ctrl.v ==

✅ 通过项：9 项
❌ 问题项：4 项

问题详情：
  [行 23] 阻塞/非阻塞赋值：时序逻辑 always 块使用了阻塞赋值 =，应改为 <=（cnt 赋值 3 处）
  [行 30] 锁存器推断：组合逻辑 if 缺少 else 分支，dout 在 wr_en=0 时保持旧值，产生锁存器
  [行 35] 位宽：assign full 赋值使用裸 1/0，应使用 1'b1 / 1'b0
  [行 36] 位宽：assign empty 赋值使用裸 1/0，应使用 1'b1 / 1'b0

建议：将时序块全部改为非阻塞赋值；为组合逻辑补全所有条件分支或添加
      default；单 bit 常量统一写位宽前缀。
```

---

## 修正后代码

```verilog
// 修正：时序逻辑改用 <=
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
        cnt <= 5'd0;
    else if (wr_en && !full)
        cnt <= cnt + 5'd1;
    else if (rd_en && !empty)
        cnt <= cnt - 5'd1;
end

// 修正：补全 else 分支，消除锁存器
always @(*)
begin
    if (rd_en && !empty)
        dout = mem[rd_ptr];
    else
        dout = 8'd0;                // 明确默认值
end

// 修正：单 bit 赋值加位宽
assign full  = (cnt == 5'd16) ? 1'b1 : 1'b0;
assign empty = (cnt == 5'd0)  ? 1'b1 : 1'b0;
```
