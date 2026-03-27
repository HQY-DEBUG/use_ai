---
name: verilog-tb
description: 为指定 Verilog 模块生成 Testbench 框架。用法：/verilog-tb <模块名> [端口列表]
argument-hint: <模块名> [端口列表，逗号分隔]
allowed-tools: [Read, Glob, Grep, Write]
disable-model-invocation: true
---

# Verilog Testbench 生成

目标模块：$ARGUMENTS

## 操作步骤

1. 若当前目录存在与模块名匹配的 `.v` 文件，读取其端口声明
2. 根据端口方向（input/output/inout）自动划分：时钟/复位、激励输入、观测输出
3. 生成 Testbench 文件 `<模块名>_tb.v`，包含以下结构：
   - 标准文件头
   - `` `timescale `` 声明
   - 信号声明（reg / wire）
   - DUT 实例化
   - 时钟生成块
   - 复位序列
   - 激励任务（task）框架
   - 基本自检（`$display` + `$finish`）
4. **不修改 DUT 源文件，不执行 git 提交**

## 生成模板

```verilog
/**************************************************************************/
// Function   : <模块名> 的 Testbench
// Version    : v1.0
// Date       : YYYY/MM/DD
// Description: 自动生成的仿真激励框架，需按实际场景补充激励内容
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        YYYY/MM/DD  创建文件
/**************************************************************************/

`timescale 1ns / 1ps

module <模块名>_tb;

// ---- 参数 ----//
parameter CLK_PERIOD = 10;          // 时钟周期，单位 ns

// ---- 激励信号（reg） ----//
reg         clk;
reg         rst_n;
// <其他 input 端口>

// ---- 观测信号（wire） ----//
// <output 端口>

// ---- DUT 实例化 ----//
<模块名> u_dut (
    .clk   (clk  ),
    .rst_n (rst_n),
    // <其他端口连接>
);

// ---- 时钟生成 ----//
initial clk = 1'b0;
always #(CLK_PERIOD / 2) clk = ~clk;

// ---- 复位序列 ----//
initial
begin
    rst_n = 1'b0;
    repeat(10) @(posedge clk);
    rst_n = 1'b1;
end

// ---- 激励主体 ----//
initial
begin
    // 等待复位释放
    @(posedge rst_n);
    @(posedge clk);

    // TODO：在此添加激励

    repeat(100) @(posedge clk);
    $display("仿真完成");
    $finish;
end

// ---- 波形转储（可选） ----//
initial
begin
    $dumpfile("<模块名>_tb.vcd");
    $dumpvars(0, <模块名>_tb);
end

endmodule
```

## 命名规范

- Testbench 模块名：`<模块名>_tb`
- 文件名：`<模块名>_tb.v`
- 时钟信号命名：`clk`（主时钟）、`clk_<域名>`（多时钟域）
- 复位信号命名：低有效 `rst_n`，高有效 `rst`

## 参考示例

完整示例见 [example/uart_rx_tb.v](example/uart_rx_tb.v)
