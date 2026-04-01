---
name: verilog-pipeline
description: 生成带 valid/ready 握手的多级流水线模块模板。用法：/verilog-pipeline <模块名> <级数> [数据位宽]
argument-hint: <模块名> <级数2-8> [数据位宽，默认16]
allowed-tools: [Write, Bash]
disable-model-invocation: true
---

# 多级流水线模板生成

参数：$ARGUMENTS

## 操作步骤

1. 解析参数：模块名、流水线级数（2-8）、数据位宽（默认 16）
2. TODAY → 通过 PowerShell 获取：`Get-Date -Format "yyyy/MM/dd"`
3. 生成流水线模板，展开 N 级寄存器链
4. 写入 `<模块名>.v`，告知用户文件路径
5. 提醒执行 git commit

## 生成模板（以 3 级为例，DATA_W=16）

```verilog
/**************************************************************************/
// Function   : N 级流水线 — MODULE_NAME
// Version    : v1.0
// Date       : TODAY
// Description: 带 valid/ready 握手的 N 级寄存器流水线
//              每级可插入组合逻辑，此处为直通（需按需填写各级运算）
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        TODAY  创建文件
/**************************************************************************/

module MODULE_NAME #(
  parameter DATA_W  = 16 ,  // 数据位宽
  parameter STAGES  = 3     // 流水线级数
) (
  input  wire              clk      ,  // 系统时钟
  input  wire              rst_n    ,  // 低有效复位
  // ---- 输入握手 ----//
  input  wire              s_valid  ,  // 上游数据有效
  output wire              s_ready  ,  // 上游就绪（背压）
  input  wire [DATA_W-1:0] s_data   ,  // 输入数据
  // ---- 输出握手 ----//
  output wire              m_valid  ,  // 下游数据有效
  input  wire              m_ready  ,  // 下游就绪
  output wire [DATA_W-1:0] m_data      // 输出数据
);

// ---- 流水线寄存器 ----//
reg [DATA_W-1:0] pipe_data_r  [0:STAGES-1] ;  // 数据寄存器链
reg              pipe_valid_r [0:STAGES-1] ;  // 有效位寄存器链

// ---- 背压信号：只有最后一级满且下游不就绪时反压 ----//
wire pipe_en ;
assign pipe_en  = m_ready || !pipe_valid_r[STAGES-1] ;
assign s_ready  = pipe_en ;
assign m_valid  = pipe_valid_r[STAGES-1] ;
assign m_data   = pipe_data_r [STAGES-1] ;

// ---- 第 0 级（直接接收输入）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        pipe_valid_r[0] <= 1'b0 ;
        pipe_data_r [0] <= {DATA_W{1'b0}} ;
      end
    else if (pipe_en)
      begin
        pipe_valid_r[0] <= s_valid ;
        pipe_data_r [0] <= s_data  ;  // TODO：在此插入第 1 级运算
      end
  end

// ---- 第 1 级 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        pipe_valid_r[1] <= 1'b0 ;
        pipe_data_r [1] <= {DATA_W{1'b0}} ;
      end
    else if (pipe_en)
      begin
        pipe_valid_r[1] <= pipe_valid_r[0] ;
        pipe_data_r [1] <= pipe_data_r [0] ;  // TODO：在此插入第 2 级运算
      end
  end

// ---- 第 2 级（最后一级）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        pipe_valid_r[2] <= 1'b0 ;
        pipe_data_r [2] <= {DATA_W{1'b0}} ;
      end
    else if (pipe_en)
      begin
        pipe_valid_r[2] <= pipe_valid_r[1] ;
        pipe_data_r [2] <= pipe_data_r [1] ;  // TODO：在此插入第 3 级运算
      end
  end

endmodule
```

## 级数展开规则

- 第 0 级接收 `s_valid`/`s_data`
- 第 1 到 N-2 级接收上一级的 `pipe_valid_r[i-1]`/`pipe_data_r[i-1]`
- 最后一级（N-1）输出 `m_valid`/`m_data`
- 每级的 `pipe_data_r` 赋值处添加 `// TODO` 提示用户填入组合逻辑

## 使用说明

生成后用户需要：
1. 在每级的 `TODO` 处填入该级的组合运算（乘法、加法、查表等）
2. 根据实际运算调整 `DATA_W`（中间级可能需要更宽的数据位宽）
3. 对于有条件跳过的流水线，需额外增加 flush/stall 逻辑
