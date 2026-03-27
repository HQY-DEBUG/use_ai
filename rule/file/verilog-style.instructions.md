---

description: "Verilog/SystemVerilog 代码风格规范：2空格缩进、begin 另起一行、非阻塞赋值、单bit常量显式位宽、端口对齐、case 必须有 default。当编写或修改 .v/.sv/.vh/.svh 文件时使用。"
applyTo: "**/*.v,**/*.sv,**/*.vh,**/*.svh"
---

# Verilog / SystemVerilog 代码风格规范

## 缩进

- 使用 **2个空格** 缩进，禁止使用 Tab

## begin/end 换行规范

`begin` 必须**另起一行**，不得与 `always`、`if`、`else`、`for` 写在同一行：

```verilog
// ✅ 正确
always @(posedge clk or negedge rstn)
  begin
    if (rstn == 1'b0)
      begin
        q <= 1'b0;
      end
    else
      begin
        q <= d;
      end
  end

// ❌ 错误（begin 未另起一行）
always @(posedge clk or negedge rstn) begin
    if (rstn == 1'b0) begin
        q <= 1'b0;
    end
end
```

## 单bit信号常量规范

所有单bit信号的比较与赋值必须显式写出位宽，使用 `1'b0` / `1'b1`，**禁止**直接使用 `0` / `1`：

```verilog
// ✅ 正确
if (rstn == 1'b0)
if (valid == 1'b1)
q <= 1'b0;

// ❌ 错误
if (rstn == 0)
if (valid == 1)
q <= 0;
```

## 赋值规范

- 时序逻辑使用非阻塞赋值 `<=`，组合逻辑使用阻塞赋值 `=`
- 端口声明每行一个信号，对齐排列

## case 语句必须有 default

组合逻辑的 `case` 必须包含 `default` 分支，避免综合出锁存器：

```verilog
// ✅ 正确
always @(*)
  begin
    case (state_r)
      2'd0:    next = 2'd1;
      2'd1:    next = 2'd2;
      default: next = 2'd0;
    endcase
  end

// ❌ 错误（缺 default，可能综合出锁存器）
always @(*)
  begin
    case (state_r)
      2'd0: next = 2'd1;
      2'd1: next = 2'd2;
    endcase
  end
```

## 命名规范

- 模块名、信号名：小写下划线，如 `axis_rx`、`data_valid`
- 参数/宏：全大写下划线，如 `DATA_WIDTH`
- 寄存器信号加 `_r` 后缀，如 `cnt_r`、`state_r`
- 复位信号：低有效用 `rstn`，高有效用 `rst`

## 端口对齐风格

方向 / 类型 / 位宽 / 名称 / 逗号各列对齐，末尾用 `//` 中文注释：

```verilog
module foo #(
  parameter DATA_WIDTH = 16
) (
  input  wire                  clk          ,  // 系统时钟
  input  wire                  rstn         ,  // 低有效复位
  input  wire [DATA_WIDTH-1:0] s_axis_tdata ,  // AXI-Stream 数据输入
  input  wire                  s_axis_tvalid,  // 数据有效
  output wire                  s_axis_tready,  // 接收就绪
  output wire [DATA_WIDTH-1:0] m_axis_tdata ,  // AXI-Stream 数据输出
  output wire                  m_axis_tvalid   // 输出有效
);
```

## 文件头模板

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

- 修改记录仅保留最近 **3** 个版本，最新在最前
- 行内注释使用 `//`，内容使用**中文**
