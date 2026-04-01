---
name: verilog-bram
description: 生成 BRAM 模块模板（单端口/双端口/ROM），支持 $readmemh 初始化。用法：/verilog-bram <模块名> <类型:sp|dp|rom> [深度] [数据位宽] [初始化文件]
argument-hint: <模块名> <类型:sp|dp|rom> [深度] [数据位宽] [初始化文件]
allowed-tools: [Write]
---

# 生成 BRAM 模块模板

参数：$ARGUMENTS

## 参数说明

| 参数 | 必填 | 默认值 | 说明 |
|------|------|--------|------|
| 模块名 | 是 | — | 生成的模块名称 |
| 类型 | 是 | — | `sp`=单端口RAM，`dp`=双端口RAM，`rom`=只读ROM |
| 深度 | 否 | 1024 | 存储深度（条目数，建议为 2 的幂次） |
| 数据位宽 | 否 | 32 | 每条目位宽 |
| 初始化文件 | 否 | 无 | `.hex` 文件路径，用于 `$readmemh` |

## 操作步骤

1. 解析参数，计算地址位宽：`ADDR_WIDTH = $clog2(深度)`
2. 按类型生成对应模板（见下方）
3. 若指定初始化文件，添加 `$readmemh` 初始化块
4. 输出文件路径：`PL/source/verilog/<模块名>.v`
5. 写入文件

## 各类型模板

### sp（单端口 RAM）

```verilog
module <模块名> #(
  parameter DATA_WIDTH = 32  ,
  parameter DEPTH      = 1024,
  parameter ADDR_WIDTH = 10
) (
  input  wire                  clk   ,  // 时钟
  input  wire                  en    ,  // 使能
  input  wire                  we    ,  // 写使能
  input  wire [ADDR_WIDTH-1:0] addr  ,  // 地址
  input  wire [DATA_WIDTH-1:0] din   ,  // 写数据
  output reg  [DATA_WIDTH-1:0] dout     // 读数据（1拍延迟）
);
  reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  // $readmemh 初始化（如有）
  initial $readmemh("<初始化文件>", mem);

  always @(posedge clk)
  begin
    if (en == 1'b1)
    begin
      if (we == 1'b1)
        mem[addr] <= din;
      dout <= mem[addr];
    end
  end
endmodule
```

### dp（真双端口 RAM）

两个独立时钟域端口 A（读写）/ B（读写），结构类似 sp，端口前缀分别为 `a_` / `b_`。

### rom（只读 ROM）

无写端口，仅保留 `clk`、`en`、`addr`、`dout`，必须提供初始化文件（`$readmemh`）。

## 注意事项

- 综合时 Vivado 自动推断为 BRAM，需满足：寄存器输出（读数据有 1 拍延迟）、地址与数据同步于时钟上升沿
- 深度建议为 2 的幂次，否则部分空间浪费
- 初始化文件使用十六进制格式（`.hex`），每行一个数据条目
- 对于大容量 BRAM，建议改用 Vivado IP Catalog（Block Memory Generator）而非手写 RTL
