/**************************************************************************/
// Function   : 参数寄存器控制模块（AXI-Lite 从机示例）
// Version    : v1.0
// Date       : 2026/03/23
// Description: 提供 4 个 32bit 配置寄存器，通过 AXI-Lite 读写
//              reg0: 使能控制  reg1: 阈值  reg2: 增益  reg3: 状态（只读）
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/03/23  创建文件
/**************************************************************************/

module reg_ctrl #(
  parameter DATA_W = 32,
  parameter ADDR_W = 4
)(
  // ---- AXI-Lite ----//
  input  wire                 s_axi_aclk,
  input  wire                 s_axi_aresetn,
  input  wire [ADDR_W-1:0]    s_axi_awaddr,
  input  wire                 s_axi_awvalid,
  output wire                 s_axi_awready,
  input  wire [DATA_W-1:0]    s_axi_wdata,
  input  wire [DATA_W/8-1:0]  s_axi_wstrb,
  input  wire                 s_axi_wvalid,
  output wire                 s_axi_wready,
  output wire [1:0]           s_axi_bresp,
  output wire                 s_axi_bvalid,
  input  wire                 s_axi_bready,
  input  wire [ADDR_W-1:0]    s_axi_araddr,
  input  wire                 s_axi_arvalid,
  output wire                 s_axi_arready,
  output wire [DATA_W-1:0]    s_axi_rdata,
  output wire [1:0]           s_axi_rresp,
  output wire                 s_axi_rvalid,
  input  wire                 s_axi_rready,

  // ---- 用户逻辑 ----//
  output wire                 ctrl_en,        // 来自 reg0[0]
  output wire [DATA_W-1:0]    ctrl_threshold, // 来自 reg1
  output wire [DATA_W-1:0]    ctrl_gain,      // 来自 reg2
  input  wire [DATA_W-1:0]    status          // 写入 reg3（只读）
);

// ---- 内部寄存器 ----//
reg [DATA_W-1:0] reg0_r;            // 使能控制
reg [DATA_W-1:0] reg1_r;            // 阈值
reg [DATA_W-1:0] reg2_r;            // 增益

// ---- 写通道 ----//
reg              aw_en_r;
reg [ADDR_W-1:0] aw_addr_r;

assign s_axi_awready = aw_en_r;
assign s_axi_wready  = aw_en_r;
assign s_axi_bresp   = 2'b00;
assign s_axi_bvalid  = aw_en_r & s_axi_awvalid & s_axi_wvalid;

always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
    if (!s_axi_aresetn)
    begin
        aw_en_r   <= 1'b1;
        aw_addr_r <= {ADDR_W{1'b0}};
    end
    else if (s_axi_awvalid && s_axi_wvalid && aw_en_r)
    begin
        aw_addr_r <= s_axi_awaddr;
        aw_en_r   <= 1'b0;
    end
    else if (s_axi_bready && s_axi_bvalid)
        aw_en_r   <= 1'b1;
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
    if (!s_axi_aresetn)
    begin
        reg0_r <= {DATA_W{1'b0}};
        reg1_r <= 32'd100;          // 默认阈值 100
        reg2_r <= 32'd1;            // 默认增益 1
    end
    else if (s_axi_wvalid && aw_en_r)
    begin
        case (aw_addr_r[ADDR_W-1:2])
            2'd0: reg0_r <= s_axi_wdata;
            2'd1: reg1_r <= s_axi_wdata;
            2'd2: reg2_r <= s_axi_wdata;
            // reg3 只读，忽略写操作
            default: ;
        endcase
    end
end

// ---- 读通道 ----//
reg              ar_valid_r;
reg [DATA_W-1:0] r_data_r;

assign s_axi_arready = ~ar_valid_r;
assign s_axi_rvalid  = ar_valid_r;
assign s_axi_rresp   = 2'b00;
assign s_axi_rdata   = r_data_r;

always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
    if (!s_axi_aresetn)
    begin
        ar_valid_r <= 1'b0;
        r_data_r   <= {DATA_W{1'b0}};
    end
    else if (s_axi_arvalid && !ar_valid_r)
    begin
        ar_valid_r <= 1'b1;
        case (s_axi_araddr[ADDR_W-1:2])
            2'd0: r_data_r <= reg0_r;
            2'd1: r_data_r <= reg1_r;
            2'd2: r_data_r <= reg2_r;
            2'd3: r_data_r <= status;   // 只读状态寄存器
            default: r_data_r <= {DATA_W{1'b0}};
        endcase
    end
    else if (s_axi_rready && ar_valid_r)
        ar_valid_r <= 1'b0;
end

// ---- 输出映射 ----//
assign ctrl_en        = reg0_r[0];
assign ctrl_threshold = reg1_r;
assign ctrl_gain      = reg2_r;

endmodule
