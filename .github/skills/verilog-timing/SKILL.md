---
name: verilog-timing
description: 分析 Verilog RTL 时序风险，识别关键路径、CDC 问题，生成 XDC 约束建议。用法：/verilog-timing <文件路径> [目标频率MHz]
argument-hint: <文件路径> [目标频率，默认200]
allowed-tools: [Read, Glob, Grep]
disable-model-invocation: true
---

# Verilog 时序分析

分析目标：$ARGUMENTS

## 操作步骤

1. 读取指定文件，解析目标时钟频率（默认 200 MHz）
2. **关键路径识别**：
   - 多级组合逻辑链（连续多个 assign 或 if 嵌套）
   - 宽位算术运算（加/减/乘）
   - 大 case 选择器
   - 跨模块长路径（依赖外部 wire 输入直接进入算术）
3. **时钟域交叉（CDC）检测**：
   - 检测多个时钟域信号（不同前缀 clk/aclk/sys_clk 等）
   - 标记未经同步器的跨域信号
4. **复位分析**：
   - 异步复位是否有同步释放（两级触发器）
   - 复位极性与命名是否一致
5. **约束建议**（XDC 格式）：
   - create_clock
   - set_input_delay / set_output_delay
   - set_false_path / set_max_delay（CDC 路径）
6. **仅输出报告，不修改任何文件，不执行 git 提交**

## 输出格式

```
== Verilog 时序分析报告：<文件名> ==
目标频率：N MHz（周期：X ns）

【关键路径风险】
  [行 NN-MM] <描述>：估算逻辑层数 N 级，风险等级 高/中/低

【CDC 风险】
  [行 NN] 信号 <名称> 从域 <A> 传入域 <B>，未检测到同步器

【复位风险】
  [行 NN] <描述>

【XDC 约束建议】
  # 时钟定义
  create_clock -period X.X [get_ports clk]
  ...
  # 伪路径（CDC）
  set_false_path -from [get_clocks clk_a] -to [get_clocks clk_b]
  ...

【综合建议】
  1. ...
```
