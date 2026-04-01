---
name: verilog-inst
description: 读取 Verilog 模块文件，生成符合项目规范的例化代码（端口对齐、参数覆盖）。用法：/verilog-inst <文件路径> [实例名]
argument-hint: <文件路径> [实例名]
allowed-tools: [Read]
---

# 生成 Verilog 模块例化代码

参数：$ARGUMENTS

## 操作步骤

1. 解析参数：`<文件路径>` 为必填，`[实例名]` 默认为 `u_<模块名>`
2. 读取目标 `.v` 文件，提取：
   - 模块名（`module <name>`）
   - 参数列表（`parameter` 声明，含默认值）
   - 端口列表（方向、位宽、信号名）
3. 按以下格式生成例化代码：
   - 有参数时先生成 `#(...)` 参数覆盖块
   - 端口映射使用 `.port_name (port_name)` 格式
   - 端口名与连接信号名纵向对齐
   - 最后一个端口末尾**不加逗号**
4. 输出完整例化代码块（用代码块包裹）

## 输出格式

```verilog
<模块名> #(
  .PARAM_A  (PARAM_A  ),  // 参数说明（来自源文件注释）
  .PARAM_B  (PARAM_B  )
) <实例名> (
  .clk      (clk      ),  // 端口注释
  .rstn     (rstn     ),
  .data_in  (data_in  ),
  .data_out (data_out )
);
```

## 注意事项

- 端口名列与连接信号名列分别对齐，右括号也对齐
- 保留源文件端口的行尾注释（`//`）
- 若源文件无参数，省略 `#(...)` 块
- 不修改源文件
