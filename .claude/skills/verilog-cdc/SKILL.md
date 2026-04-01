---
name: verilog-cdc
description: 生成时钟域交叉（CDC）同步器模板。用法：/verilog-cdc <模块名> <类型:1bit|handshake|pulse>
argument-hint: <模块名> <1bit|handshake|pulse>
allowed-tools: [Write, Bash]
disable-model-invocation: true
---

# CDC 同步器模板生成

参数：$ARGUMENTS

## 操作步骤

1. 解析参数：模块名、同步器类型
2. 根据类型生成对应模板文件 `<模块名>.v`
3. TODAY → 通过 PowerShell 获取：`Get-Date -Format "yyyy/MM/dd"`
4. 写入文件后告知用户，并提示在顶层连接注意事项
5. 提醒执行 git commit

## 类型说明

| 类型 | 场景 |
|---|---|
| `1bit` | 单bit慢变化信号跨域（使能、标志位） |
| `handshake` | 多bit数据跨域（req/ack 握手） |
| `pulse` | 单bit脉冲信号跨域（单周期脉冲展宽后同步） |

---

## 1bit 同步器模板（两级触发器）

```verilog
/**************************************************************************/
// Function   : 单bit CDC 同步器 — MODULE_NAME
// Version    : v1.0
// Date       : TODAY
// Description: 双寄存器同步，消除亚稳态，适用于慢变化单bit信号
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        TODAY  创建文件
/**************************************************************************/

module MODULE_NAME (
  input  wire  dst_clk    ,  // 目标时钟域时钟
  input  wire  dst_rst_n  ,  // 目标时钟域复位（低有效）
  input  wire  src_data   ,  // 源时钟域输入信号
  output wire  dst_data      // 目标时钟域同步输出
);

(* ASYNC_REG = "TRUE" *) reg sync1_r ;  // 第一级同步寄存器（亚稳态捕获）
(* ASYNC_REG = "TRUE" *) reg sync2_r ;  // 第二级同步寄存器（稳定输出）

always @(posedge dst_clk or negedge dst_rst_n)
  begin
    if (dst_rst_n == 1'b0)
      begin
        sync1_r <= 1'b0 ;
        sync2_r <= 1'b0 ;
      end
    else
      begin
        sync1_r <= src_data ;
        sync2_r <= sync1_r  ;
      end
  end

assign dst_data = sync2_r ;

endmodule
```

---

## 握手同步器模板（req/ack，多bit数据）

```verilog
/**************************************************************************/
// Function   : 多bit CDC 握手同步器 — MODULE_NAME
// Version    : v1.0
// Date       : TODAY
// Description: req/ack 握手协议，适用于低频多bit数据跨时钟域传输
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        TODAY  创建文件
/**************************************************************************/

module MODULE_NAME #(
  parameter DATA_W = 8
) (
  // ---- 源时钟域 ----//
  input  wire              src_clk    ,  // 源时钟
  input  wire              src_rst_n  ,  // 源侧复位
  input  wire              src_valid  ,  // 数据有效（单周期脉冲）
  input  wire [DATA_W-1:0] src_data   ,  // 待传输数据
  output wire              src_ready  ,  // 源侧就绪（可接受下一次传输）
  // ---- 目标时钟域 ----//
  input  wire              dst_clk    ,  // 目标时钟
  input  wire              dst_rst_n  ,  // 目标侧复位
  output wire              dst_valid  ,  // 目标侧数据有效（单周期脉冲）
  output wire [DATA_W-1:0] dst_data      // 目标侧数据
);

// ---- 数据寄存器（src域锁存）----//
reg [DATA_W-1:0] data_r ;

// ---- req 信号（src域产生）----//
reg req ;

// ---- 同步 req 到 dst 域 ----//
(* ASYNC_REG = "TRUE" *) reg req_dst1_r ;
(* ASYNC_REG = "TRUE" *) reg req_dst2_r ;
reg req_dst3_r ;  // 边沿检测

// ---- 同步 ack 到 src 域 ----//
(* ASYNC_REG = "TRUE" *) reg ack_src1_r ;
(* ASYNC_REG = "TRUE" *) reg ack_src2_r ;

// ---- 源时钟域逻辑 ----//
always @(posedge src_clk or negedge src_rst_n)
  begin
    if (src_rst_n == 1'b0)
      begin
        req    <= 1'b0 ;
        data_r   <= {DATA_W{1'b0}} ;
        ack_src1_r <= 1'b0 ;
        ack_src2_r <= 1'b0 ;
      end
    else
      begin
        ack_src1_r <= req_dst2_r ;  // 将同步后的 req 作为 ack 反馈
        ack_src2_r <= ack_src1_r ;
        if (src_valid && src_ready)
          begin
            data_r <= src_data ;
            req  <= ~req   ;  // 翻转 req
          end
      end
  end

assign src_ready = (req == ack_src2_r) ;  // req 与 ack 相等时可接受新数据

// ---- 目标时钟域逻辑 ----//
always @(posedge dst_clk or negedge dst_rst_n)
  begin
    if (dst_rst_n == 1'b0)
      begin
        req_dst1_r <= 1'b0 ;
        req_dst2_r <= 1'b0 ;
        req_dst3_r <= 1'b0 ;
      end
    else
      begin
        req_dst1_r <= req    ;
        req_dst2_r <= req_dst1_r ;
        req_dst3_r <= req_dst2_r ;
      end
  end

assign dst_valid = req_dst2_r ^ req_dst3_r ;  // 边沿检测产生单周期脉冲
assign dst_data  = data_r ;                    // 握手完成后数据已稳定

endmodule
```

---

## 脉冲同步器模板（单周期脉冲展宽再同步）

```verilog
/**************************************************************************/
// Function   : 脉冲 CDC 同步器 — MODULE_NAME
// Version    : v1.0
// Date       : TODAY
// Description: 将源域单周期脉冲展宽为电平，同步到目标域后再提取边沿
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        TODAY  创建文件
/**************************************************************************/

module MODULE_NAME (
  input  wire  src_clk    ,  // 源时钟
  input  wire  src_rst_n  ,  // 源侧复位
  input  wire  src_pulse  ,  // 源域单周期脉冲输入
  input  wire  dst_clk    ,  // 目标时钟
  input  wire  dst_rst_n  ,  // 目标侧复位
  output wire  dst_pulse     // 目标域单周期脉冲输出
);

// ---- 源域：脉冲展宽为电平翻转 ----//
reg src_toggle ;

always @(posedge src_clk or negedge src_rst_n)
  begin
    if (src_rst_n == 1'b0)
      src_toggle <= 1'b0 ;
    else if (src_pulse == 1'b1)
      src_toggle <= ~src_toggle ;
  end

// ---- 目标域：两级同步 + 边沿检测 ----//
(* ASYNC_REG = "TRUE" *) reg sync1_r ;
(* ASYNC_REG = "TRUE" *) reg sync2_r ;
reg sync3_r ;

always @(posedge dst_clk or negedge dst_rst_n)
  begin
    if (dst_rst_n == 1'b0)
      begin
        sync1_r <= 1'b0 ;
        sync2_r <= 1'b0 ;
        sync3_r <= 1'b0 ;
      end
    else
      begin
        sync1_r <= src_toggle ;
        sync2_r <= sync1_r      ;
        sync3_r <= sync2_r      ;
      end
  end

assign dst_pulse = sync2_r ^ sync3_r ;  // 边沿检测还原为单周期脉冲

endmodule
```

## 使用注意事项

- `(* ASYNC_REG = "TRUE" *)` 属性告知 Vivado 这是异步寄存器，优化布局使其物理相邻
- 1bit 同步器要求源信号保持稳定时间 > 2个目标时钟周期
- 握手同步器吞吐率受限：每次传输需约 4 个源时钟 + 4 个目标时钟周期
- 在 XDC 中需配合 `set_false_path -to [get_cells *sync1_r*]` 约束
