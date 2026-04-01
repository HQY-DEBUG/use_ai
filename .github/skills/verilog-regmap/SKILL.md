---
name: verilog-regmap
description: 根据寄存器规格表生成 AXI-Lite 寄存器映射 Verilog 模块。用法：/verilog-regmap <模块名> <寄存器规格...>
argument-hint: <模块名> <寄存器规格（名称:偏移:位宽:RW|RO:说明 ...）>
allowed-tools: [Write]
---

# 生成 AXI-Lite 寄存器映射模块

参数：$ARGUMENTS

## 寄存器规格格式

每条寄存器规格使用空格分隔，单条格式：

```
<寄存器名>:<偏移十六进制>:<位宽>:<访问类型>:<说明>
```

示例：
```
/verilog-regmap ctrl_reg CTRL:0x00:32:RW:控制寄存器 STATUS:0x04:32:RO:状态寄存器 DATA:0x08:16:RW:数据寄存器
```

访问类型：
- `RW` — 可读写
- `RO` — 只读（写入无效）
- `WO` — 只写（读回 0）
- `W1C` — 写 1 清零（中断标志常用）

## 操作步骤

1. 解析参数：提取模块名和寄存器列表
2. 按下方模板生成 AXI-Lite Slave 模块：
   - 地址解码逻辑（基于偏移）
   - 每个 RW 寄存器生成独立 `reg` 信号
   - RO 寄存器从外部端口读入
   - W1C 寄存器生成写 1 清零逻辑
   - 读多路复用器（case 语句含 default）
3. 输出文件路径：`PL/source/verilog/<模块名>.v`
4. 写入文件

## 输出模板

```verilog
/**************************************************************************/
// Function   : AXI-Lite 寄存器映射 — <模块名>
// Version    : v1.0
// Date       : YYYY/MM/DD
// Description: 自动生成，共 N 个寄存器
/**************************************************************************/
module <模块名> #(
  parameter ADDR_WIDTH = 8 ,
  parameter DATA_WIDTH = 32
) (
  // AXI-Lite 从机接口
  input  wire                  s_axi_aclk    ,
  input  wire                  s_axi_aresetn ,
  input  wire [ADDR_WIDTH-1:0] s_axi_awaddr  ,
  input  wire                  s_axi_awvalid ,
  output wire                  s_axi_awready ,
  input  wire [DATA_WIDTH-1:0] s_axi_wdata   ,
  input  wire                  s_axi_wvalid  ,
  output wire                  s_axi_wready  ,
  output wire [1:0]            s_axi_bresp   ,
  output wire                  s_axi_bvalid  ,
  input  wire                  s_axi_bready  ,
  input  wire [ADDR_WIDTH-1:0] s_axi_araddr  ,
  input  wire                  s_axi_arvalid ,
  output wire                  s_axi_arready ,
  output wire [DATA_WIDTH-1:0] s_axi_rdata   ,
  output wire [1:0]            s_axi_rresp   ,
  output wire                  s_axi_rvalid  ,
  input  wire                  s_axi_rready  ,
  // 用户信号
  output wire [DATA_WIDTH-1:0] reg_ctrl      ,  // CTRL 寄存器输出
  input  wire [DATA_WIDTH-1:0] reg_status       // STATUS 寄存器输入（RO）
);
  // 寄存器定义、写逻辑、读多路复用器...
endmodule
```

## 注意事项

- 地址对齐到 4 字节边界（偏移须为 4 的倍数）
- AXI 响应固定返回 `OKAY (2'b00)`，不实现错误响应
- RO 寄存器端口命名：`reg_<小写寄存器名>_i`（输入）
- RW 寄存器端口命名：`reg_<小写寄存器名>_o`（输出）
