---
name: verilog-fifo
description: 生成同步或异步 FIFO 模块模板。用法：/verilog-fifo <模块名> <类型:sync|async> [深度] [数据位宽]
argument-hint: <模块名> <sync|async> [深度，默认16] [数据位宽，默认8]
allowed-tools: [Write, Bash]
disable-model-invocation: true
---

# Verilog FIFO 模板生成

生成参数：$ARGUMENTS

## 操作步骤

1. 解析参数：模块名、类型（sync/async）、深度（默认 16）、数据位宽（默认 8）
2. 计算地址位宽 = $clog2(深度)
3. 根据类型生成对应模板，替换所有占位符：
   - MODULE_NAME → 模块名
   - DATA_W → 数据位宽
   - DEPTH → 深度
   - ADDR_W → 地址位宽
   - TODAY → 当前日期（YYYY/MM/DD），通过 PowerShell 获取：`Get-Date -Format "yyyy/MM/dd"`
4. 写入 `<模块名>.v` 文件到当前工作目录
5. 告知用户文件路径，提示按需调整参数
6. 提醒用户执行 git commit

## 同步 FIFO 模板（sync）

```verilog
/**************************************************************************/
// Function   : 同步 FIFO — MODULE_NAME
// Version    : v1.0
// Date       : TODAY
// Description: 深度 DEPTH，数据位宽 DATA_W，单时钟域同步 FIFO
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        TODAY  创建文件
/**************************************************************************/

module MODULE_NAME #(
  parameter DATA_W = 8,
  parameter DEPTH  = 16,
  parameter ADDR_W = 4   // $clog2(DEPTH)
) (
  input  wire              clk     ,  // 系统时钟
  input  wire              rst_n   ,  // 低有效复位
  // ---- 写端口 ----//
  input  wire              wr_en   ,  // 写使能
  input  wire [DATA_W-1:0] wr_data ,  // 写数据
  output wire              full    ,  // 满标志
  // ---- 读端口 ----//
  input  wire              rd_en   ,  // 读使能
  output wire [DATA_W-1:0] rd_data ,  // 读数据
  output wire              empty   ,  // 空标志
  output wire [ADDR_W:0]   data_cnt   // 当前数据数量
);

// ---- 内部存储 ----//
reg [DATA_W-1:0] mem_r [0:DEPTH-1] ;

// ---- 读写指针 ----//
reg [ADDR_W:0] wr_ptr_r ;  // 多一位用于区分满/空
reg [ADDR_W:0] rd_ptr_r ;

// ---- 状态标志 ----//
assign full     = (wr_ptr_r[ADDR_W] != rd_ptr_r[ADDR_W]) &&
                  (wr_ptr_r[ADDR_W-1:0] == rd_ptr_r[ADDR_W-1:0]) ;
assign empty    = (wr_ptr_r == rd_ptr_r) ;
assign data_cnt = wr_ptr_r - rd_ptr_r ;
assign rd_data  = mem_r[rd_ptr_r[ADDR_W-1:0]] ;

// ---- 写操作 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        wr_ptr_r <= {(ADDR_W+1){1'b0}} ;
      end
    else if (wr_en && !full)
      begin
        mem_r[wr_ptr_r[ADDR_W-1:0]] <= wr_data ;
        wr_ptr_r                     <= wr_ptr_r + 1'b1 ;
      end
  end

// ---- 读操作 ----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        rd_ptr_r <= {(ADDR_W+1){1'b0}} ;
      end
    else if (rd_en && !empty)
      begin
        rd_ptr_r <= rd_ptr_r + 1'b1 ;
      end
  end

endmodule
```

## 异步 FIFO 模板（async，格雷码同步）

```verilog
/**************************************************************************/
// Function   : 异步 FIFO — MODULE_NAME
// Version    : v1.0
// Date       : TODAY
// Description: 深度 DEPTH，数据位宽 DATA_W，双时钟域异步 FIFO（格雷码同步）
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        TODAY  创建文件
/**************************************************************************/

module MODULE_NAME #(
  parameter DATA_W = 8,
  parameter DEPTH  = 16,
  parameter ADDR_W = 4   // $clog2(DEPTH)
) (
  // ---- 写时钟域 ----//
  input  wire              wr_clk  ,  // 写时钟
  input  wire              wr_rst_n,  // 写侧复位（低有效）
  input  wire              wr_en   ,  // 写使能
  input  wire [DATA_W-1:0] wr_data ,  // 写数据
  output wire              full    ,  // 满标志（写时钟域）
  // ---- 读时钟域 ----//
  input  wire              rd_clk  ,  // 读时钟
  input  wire              rd_rst_n,  // 读侧复位（低有效）
  input  wire              rd_en   ,  // 读使能
  output wire [DATA_W-1:0] rd_data ,  // 读数据
  output wire              empty      // 空标志（读时钟域）
);

// ---- 内部存储（双口 RAM 推断）----//
reg [DATA_W-1:0] mem_r [0:DEPTH-1] ;

// ---- 写时钟域：二进制指针 + 格雷码 ----//
reg [ADDR_W:0] wr_bin_r  ;
reg [ADDR_W:0] wr_gray_r ;
wire[ADDR_W:0] wr_bin_next  = wr_bin_r + (wr_en & ~full) ;
wire[ADDR_W:0] wr_gray_next = (wr_bin_next >> 1) ^ wr_bin_next ;

// ---- 读时钟域：二进制指针 + 格雷码 ----//
reg [ADDR_W:0] rd_bin_r  ;
reg [ADDR_W:0] rd_gray_r ;
wire[ADDR_W:0] rd_bin_next  = rd_bin_r + (rd_en & ~empty) ;
wire[ADDR_W:0] rd_gray_next = (rd_bin_next >> 1) ^ rd_bin_next ;

// ---- CDC：将读格雷码同步到写时钟域 ----//
reg [ADDR_W:0] rd_gray_sync1_r ;
reg [ADDR_W:0] rd_gray_sync2_r ;

// ---- CDC：将写格雷码同步到读时钟域 ----//
reg [ADDR_W:0] wr_gray_sync1_r ;
reg [ADDR_W:0] wr_gray_sync2_r ;

// ---- 写时钟域逻辑 ----//
always @(posedge wr_clk or negedge wr_rst_n)
  begin
    if (wr_rst_n == 1'b0)
      begin
        wr_bin_r        <= {(ADDR_W+1){1'b0}} ;
        wr_gray_r       <= {(ADDR_W+1){1'b0}} ;
        rd_gray_sync1_r <= {(ADDR_W+1){1'b0}} ;
        rd_gray_sync2_r <= {(ADDR_W+1){1'b0}} ;
      end
    else
      begin
        wr_bin_r        <= wr_bin_next ;
        wr_gray_r       <= wr_gray_next ;
        rd_gray_sync1_r <= rd_gray_r ;
        rd_gray_sync2_r <= rd_gray_sync1_r ;
      end
  end

// ---- 读时钟域逻辑 ----//
always @(posedge rd_clk or negedge rd_rst_n)
  begin
    if (rd_rst_n == 1'b0)
      begin
        rd_bin_r        <= {(ADDR_W+1){1'b0}} ;
        rd_gray_r       <= {(ADDR_W+1){1'b0}} ;
        wr_gray_sync1_r <= {(ADDR_W+1){1'b0}} ;
        wr_gray_sync2_r <= {(ADDR_W+1){1'b0}} ;
      end
    else
      begin
        rd_bin_r        <= rd_bin_next ;
        rd_gray_r       <= rd_gray_next ;
        wr_gray_sync1_r <= wr_gray_r ;
        wr_gray_sync2_r <= wr_gray_sync1_r ;
      end
  end

// ---- 写操作 ----//
always @(posedge wr_clk)
  begin
    if (wr_en && !full)
      mem_r[wr_bin_r[ADDR_W-1:0]] <= wr_data ;
  end

assign rd_data = mem_r[rd_bin_r[ADDR_W-1:0]] ;

// ---- 满/空判断（格雷码比较）----//
assign full  = (wr_gray_r == {~rd_gray_sync2_r[ADDR_W:ADDR_W-1], rd_gray_sync2_r[ADDR_W-2:0]}) ;
assign empty = (rd_gray_r == wr_gray_sync2_r) ;

endmodule
```
