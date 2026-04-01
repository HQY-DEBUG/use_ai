---
name: verilog-new-module
description: 新建 Verilog 模块文件，自动生成符合项目规范的文件头、端口声明和模块框架。用法：/verilog-new-module <模块名> [描述]
argument-hint: <模块名> [模块功能描述]
allowed-tools: [Read, Write, Bash]
disable-model-invocation: true
---

# 新建 Verilog 模块

参数：$ARGUMENTS

## 操作步骤

1. 从参数中解析**模块名**（第一个词）和**功能描述**（其余部分，若无则留空）
2. 确定输出文件路径（当前工作目录或用户指定路径下的 `<模块名>.v`）
3. 使用以下模板生成文件，替换所有占位符：
   - `MODULE_NAME` → 模块名（小写下划线）
   - `FUNC_DESC` → 功能描述
   - `TODAY` → 今天日期（格式 YYYY/MM/DD），通过 PowerShell 获取：`Get-Date -Format "yyyy/MM/dd"`

## 文件模板

```verilog
/**************************************************************************/
// Function   : FUNC_DESC
// Version    : v1.0
// Date       : TODAY
// Description: FUNC_DESC
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        TODAY  创建文件
/**************************************************************************/

module MODULE_NAME #(
  parameter DATA_WIDTH = 16
) (
  input  wire        clk   ,  // 系统时钟
  input  wire        rst_n ,  // 低有效复位
  input  wire        i_xxx ,  // 输入信号（按需修改）
  output wire        o_xxx    // 输出信号（按需修改）
);

// ---- 参数定义 ----//

// ---- 信号声明 ----//

// ---- 时序逻辑 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        // 复位逻辑
      end
    else
      begin
        // 正常逻辑
      end
  end

// ---- 组合逻辑 ----//

endmodule
```

4. 写入文件后，告知用户文件路径，并提示按需修改端口声明
5. 每次创建新文件后提醒用户执行 `git commit`
