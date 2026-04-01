---
name: axi-interface
description: 生成 AXI-Lite 或 AXI-Stream 从机接口模板。用法：/axi-interface <模块名> <类型:lite|stream> [数据位宽]
argument-hint: <模块名> <lite|stream> [数据位宽，默认32]
allowed-tools: [Read, Write]
disable-model-invocation: true
---

# AXI 接口模板生成

目标：$ARGUMENTS

## 操作步骤

1. 解析参数：模块名、接口类型（`lite` / `stream`）、数据位宽（默认 32）
2. 根据类型生成对应模板文件 `<模块名>.v`
3. **不修改其他文件，不执行 git 提交**

---

## AXI-Lite 从机模板

适用场景：寄存器配置、控制/状态读写。

```verilog
/**************************************************************************/
// Function   : AXI-Lite 从机接口 — <模块名>
// Version    : v1.0
// Date       : YYYY/MM/DD
// Description: 提供 N 个 32bit 可读写寄存器，基地址由顶层指定
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        YYYY/MM/DD  创建文件
/**************************************************************************/

module <模块名> #(
  parameter DATA_W = 32,            // 数据位宽（AXI-Lite 固定 32）
  parameter ADDR_W = 4              // 地址位宽，决定寄存器数量
)(
  // ---- AXI-Lite 时钟/复位 ----//
  input  wire                 s_axi_aclk,
  input  wire                 s_axi_aresetn,

  // ---- 写地址通道 ----//
  input  wire [ADDR_W-1:0]    s_axi_awaddr,
  input  wire                 s_axi_awvalid,
  output wire                 s_axi_awready,

  // ---- 写数据通道 ----//
  input  wire [DATA_W-1:0]    s_axi_wdata,
  input  wire [DATA_W/8-1:0]  s_axi_wstrb,
  input  wire                 s_axi_wvalid,
  output wire                 s_axi_wready,

  // ---- 写响应通道 ----//
  output wire [1:0]           s_axi_bresp,
  output wire                 s_axi_bvalid,
  input  wire                 s_axi_bready,

  // ---- 读地址通道 ----//
  input  wire [ADDR_W-1:0]    s_axi_araddr,
  input  wire                 s_axi_arvalid,
  output wire                 s_axi_arready,

  // ---- 读数据通道 ----//
  output wire [DATA_W-1:0]    s_axi_rdata,
  output wire [1:0]           s_axi_rresp,
  output wire                 s_axi_rvalid,
  input  wire                 s_axi_rready,

  // ---- 用户逻辑接口 ----//
  output wire [DATA_W-1:0]    reg0_o,   // 寄存器 0 输出
  output wire [DATA_W-1:0]    reg1_o    // 寄存器 1 输出
);

// ---- 内部寄存器 ----//
reg [DATA_W-1:0] reg0;
reg [DATA_W-1:0] reg1;

// ---- 写握手状态 ----//
reg              aw_en;
reg [ADDR_W-1:0] aw_addr;

assign s_axi_awready = aw_en;
assign s_axi_wready  = aw_en;
assign s_axi_bresp   = 2'b00;      // OKAY
assign s_axi_bvalid  = aw_en;    // 简化：与 wready 同拍响应

// 写地址 + 写数据握手（单拍完成）
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
    if (!s_axi_aresetn)
    begin
        aw_en   <= 1'b1;
        aw_addr <= {ADDR_W{1'b0}};
    end
    else if (s_axi_awvalid && s_axi_wvalid && aw_en)
    begin
        aw_addr <= s_axi_awaddr;
        aw_en   <= 1'b0;          // 锁住，等待 bready
    end
    else if (s_axi_bready)
        aw_en   <= 1'b1;
end

// 写寄存器
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
    if (!s_axi_aresetn)
    begin
        reg0 <= {DATA_W{1'b0}};
        reg1 <= {DATA_W{1'b0}};
    end
    else if (s_axi_wvalid && aw_en)
    begin
        case (aw_addr[ADDR_W-1:2])   // 字节地址转字地址
            0: reg0 <= s_axi_wdata;
            1: reg1 <= s_axi_wdata;
            default: ;
        endcase
    end
end

// 读握手（单拍）
reg              ar_valid;
reg [ADDR_W-1:0] ar_addr;
reg [DATA_W-1:0] r_data;

assign s_axi_arready = ~ar_valid;
assign s_axi_rvalid  = ar_valid;
assign s_axi_rresp   = 2'b00;
assign s_axi_rdata   = r_data;

always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
    if (!s_axi_aresetn)
    begin
        ar_valid <= 1'b0;
        ar_addr  <= {ADDR_W{1'b0}};
        r_data   <= {DATA_W{1'b0}};
    end
    else if (s_axi_arvalid && !ar_valid)
    begin
        ar_valid <= 1'b1;
        ar_addr  <= s_axi_araddr;
        case (s_axi_araddr[ADDR_W-1:2])
            0: r_data <= reg0;
            1: r_data <= reg1;
            default: r_data <= {DATA_W{1'b0}};
        endcase
    end
    else if (s_axi_rready)
        ar_valid <= 1'b0;
end

assign reg0_o = reg0;
assign reg1_o = reg1;

endmodule
```

---

## AXI-Stream 从机模板

适用场景：流式数据接收（图像、音频、数据包）。

```verilog
/**************************************************************************/
// Function   : AXI-Stream 从机接口 — <模块名>
// Version    : v1.0
// Date       : YYYY/MM/DD
// Description: 接收上游 AXI-Stream 数据，输出至用户逻辑
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        YYYY/MM/DD  创建文件
/**************************************************************************/

module <模块名> #(
  parameter DATA_W = 32             // 数据位宽，需为 8 的整数倍
)(
  input  wire                 aclk,
  input  wire                 aresetn,

  // ---- AXI-Stream 从机端口 ----//
  input  wire [DATA_W-1:0]    s_axis_tdata,
  input  wire [DATA_W/8-1:0]  s_axis_tkeep,   // 字节有效掩码
  input  wire                 s_axis_tlast,   // 帧结束标志
  input  wire                 s_axis_tvalid,
  output wire                 s_axis_tready,

  // ---- 用户逻辑输出 ----//
  output reg  [DATA_W-1:0]    user_data,
  output reg                  user_valid,
  output reg                  user_last
);

// 默认始终 ready（下游需要背压时改为条件逻辑）
assign s_axis_tready = 1'b1;

always @(posedge aclk or negedge aresetn)
begin
    if (!aresetn)
    begin
        user_data  <= {DATA_W{1'b0}};
        user_valid <= 1'b0;
        user_last  <= 1'b0;
    end
    else
    begin
        user_valid <= s_axis_tvalid & s_axis_tready;
        user_last  <= s_axis_tvalid & s_axis_tready & s_axis_tlast;
        if (s_axis_tvalid & s_axis_tready)
            user_data <= s_axis_tdata;
    end
end

endmodule
```
