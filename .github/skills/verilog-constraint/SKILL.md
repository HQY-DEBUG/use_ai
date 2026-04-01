---
name: verilog-constraint
description: 读取 Verilog 文件，生成 Vivado XDC 约束文件（pin.xdc 引脚约束 + time.xdc 时序约束）。用法：/verilog-constraint <文件路径> [主时钟频率MHz]
argument-hint: <文件路径> [主时钟频率，默认200]
allowed-tools: [Read, Glob, Grep, Write]
disable-model-invocation: true
---

# Verilog XDC 约束文件生成

目标：$ARGUMENTS

## 操作步骤

1. 读取指定 `.v` 文件，解析目标频率（默认 200 MHz，周期 = 1000/频率 ns）
2. 识别以下内容：
   - 所有时钟端口（含 `clk`、`aclk`、`wr_clk`、`rd_clk` 等命名的 `input wire`）
   - 所有跨时钟域信号（不同前缀的时钟驱动的寄存器间传递）
   - 所有外部 IO 端口（非时钟/复位的 input/output）
3. 生成两个约束文件，放在与源文件相同目录：
   - **`pin.xdc`**：引脚绑定约束（IO 物理引脚、电平标准）
   - **`time.xdc`**：时序约束（时钟定义、IO 延迟、CDC 伪路径、多周期路径）
4. **不修改源文件，不执行 git 提交**

## pin.xdc 模板

```xdc
## ===========================================================
## 引脚约束：pin.xdc
## 目标器件：Zynq（按需修改 PACKAGE_PIN 和 IOSTANDARD）
## 生成日期：TODAY
## ===========================================================

## ---- 时钟引脚 ----
## set_property PACKAGE_PIN <引脚号> [get_ports clk]
## set_property IOSTANDARD  LVCMOS33  [get_ports clk]

## ---- 输入引脚 ----
## set_property PACKAGE_PIN <引脚号> [get_ports {<端口名>}]
## set_property IOSTANDARD  LVCMOS33  [get_ports {<端口名>}]

## ---- 输出引脚 ----
## set_property PACKAGE_PIN <引脚号> [get_ports {<端口名>}]
## set_property IOSTANDARD  LVCMOS33  [get_ports {<端口名>}]
```

## time.xdc 模板

```xdc
## ===========================================================
## 时序约束：time.xdc
## 生成日期：TODAY
## ===========================================================

## ---- 时钟定义 ----
create_clock -period <周期ns> -name clk [get_ports clk]
## 若有多时钟域，继续添加：
## create_clock -period <周期ns> -name wr_clk [get_ports wr_clk]
## create_clock -period <周期ns> -name rd_clk [get_ports rd_clk]

## ---- 输入延迟 ----
set_input_delay -clock clk -max 2.0 [get_ports {<输入端口列表>}]
set_input_delay -clock clk -min 0.5 [get_ports {<输入端口列表>}]

## ---- 输出延迟 ----
set_output_delay -clock clk -max 2.0 [get_ports {<输出端口列表>}]
set_output_delay -clock clk -min 0.5 [get_ports {<输出端口列表>}]

## ---- CDC 伪路径（跨时钟域）----
## set_false_path -from [get_clocks clk_a] -to [get_clocks clk_b]

## ---- 复位伪路径 ----
## set_false_path -from [get_ports rst_n]

## ---- 多周期路径 ----
## set_multicycle_path 2 -setup -from [get_cells <慢路径寄存器>]
```

## 输出说明

生成文件后告知用户：
- 生成的文件路径（`pin.xdc` 和 `time.xdc`）
- 检测到的时钟数量及名称
- 需要手动填写的项目：`pin.xdc` 中的物理引脚号和电平标准
- 需要手动确认的项目：CDC 路径、多周期路径

