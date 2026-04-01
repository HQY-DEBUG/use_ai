---
name: verilog-conventions
description: 本项目 Verilog/SystemVerilog 编码规范背景知识。凡涉及编写、修改或审查 .v / .sv / .vh / .svh 文件时自动应用。
user-invocable: false
---

# Verilog 编码规范（背景知识）

编写或修改任何 Verilog / SystemVerilog 文件时，严格遵守以下规则。

## 缩进与格式

- 使用 **2个空格** 缩进，**禁止** Tab
- `begin` 必须**另起一行**，不得与 `always`、`if`、`else`、`for` 写在同一行

```verilog
always @(posedge clk or posedge rst)
  begin
    if (rst)
      begin
        q <= 1'b0;
      end
  end
```

## 常量规范

- 单bit信号比较与赋值必须显式写出位宽：`1'b0` / `1'b1`
- 禁止直接使用裸露的 `0` / `1` 赋值给单bit信号

```verilog
// ✅ 正确
if (rstn == 1'b0)
  q <= 1'b1;

// ❌ 错误
if (rstn == 0)
  q <= 1;
```

## 赋值规范

- 时序逻辑（`always @(posedge clk ...)`）：使用**非阻塞赋值** `<=`
- 组合逻辑（`always @(*)`）：使用**阻塞赋值** `=`

## 端口声明

- 每行声明一个信号，对齐排列，末尾加中文注释

```verilog
module foo #(
  parameter DATA_WIDTH = 16
) (
  input  wire                  clk             ,  // 系统时钟
  input  wire                  rstn            ,  // 低有效复位
  input  wire [DATA_WIDTH-1:0] s_axis_tdata    ,  // AXI-Stream 数据输入
  output wire [DATA_WIDTH-1:0] m_axis_tdata       // AXI-Stream 数据输出
);
```

## 命名规范

| 类型      | 风格          | 示例                     |
|---------|-------------|------------------------|
| 模块名、信号名 | 小写下划线       | `axis_rx`、`data_valid` |
| 参数、宏    | 全大写下划线      | `DATA_WIDTH`           |
| 延时信号    | `_r` 后缀；多级延时用 `_r1`、`_r2` 递增 | `cnt_r`、`data_r1`、`data_r2` |
| 复位信号    | 低有效 `rstn`，高有效 `rst`  | —              |
| 输入/输出冲突消歧 | 优先不加后缀；冲突时输入加 `_i`、输出加 `_o` | `data_i`、`data_o` |

> 注意：总线接口信号（AXI/AXIS 等）不使用 `_i`/`_o` 后缀；非必要不加后缀。

- 避免单字母命名（循环变量 `i`、`j`、`k` 除外）

## 注释规范

- 所有注释内容使用**中文**
- 行内注释使用 `//`
- 新增代码在上方或行尾标注日期：`// YYYY-MM-DD 新增：说明`
- 废弃代码添加注释说明原因，保留 **3个版本** 后清理

## 文件头模板

每个新建 `.v` 文件顶部必须包含：

```verilog
/**************************************************************************/
// Function   : 模块功能简述
// Version    : v1.0
// Date       : YYYY/MM/DD
// Description: 详细说明（多行）
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        YYYY/MM/DD  创建文件
/**************************************************************************/
```

修改记录仅保留最近 **3** 个版本，最新在最前。

## 参考示例

符合所有规范的完整模块示例见 [example/axis_data_width_conv.v](example/axis_data_width_conv.v)（AXI-Stream 位宽转换）
