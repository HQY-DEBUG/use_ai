---
name: verilog-resource
description: 对 Verilog RTL 文件进行资源分析，估算 LUT/FF/BRAM/DSP 使用量，给出优化建议。用法：/verilog-resource <文件路径>
argument-hint: <文件路径>
allowed-tools: [Read, Glob, Grep]
disable-model-invocation: true
---

# Verilog 资源分析

分析目标：$ARGUMENTS

## 操作步骤

1. 读取指定文件
2. 分析以下资源类型：
   - **LUT（查找表）**：组合逻辑 assign、case、运算符 + - * /、比较器
   - **FF（寄存器）**：always @(posedge clk) 中的 reg 声明数量及位宽
   - **BRAM**：大型数组（通常 > 512bit）推断出 Block RAM
   - **DSP**：乘法 *、MAC（multiply-accumulate）操作
3. 对每类资源给出估算结论（高/中/低消耗）
4. 检查以下优化点：
   - 宽位加法器/乘法器是否可流水线化
   - 大 case 语句是否可改为 ROM 查表
   - 同类逻辑是否可共享资源（resource sharing）
   - 大数组是否应使用 BRAM 而非 LUTRAM
   - 冗余逻辑（常量信号、永远不触发的条件）
5. **仅输出报告，不修改任何文件，不执行 git 提交**

## 输出格式

```
== Verilog 资源分析报告：<文件名> ==

【寄存器（FF）】
  总量估算：约 N bit
  明细：<信号名> [位宽]  ...

【组合逻辑（LUT）】
  密集区域：<always/assign 块行号范围>
  高消耗操作：<运算符/语句>

【BRAM 推断】
  检测到大型数组：<信号名> [深度×宽度]  → 建议推断为 BRAM

【DSP 推断】
  检测到乘法操作：<行号> <表达式>

【优化建议】
  1. ...
  2. ...
```
