/**************************************************************************/
// Function   : 通用控制器 AXI-Lite 寄存器映射
// Version    : v1.0
// Date       : 2026/05/26
// Description: 提供 3 个寄存器：
//              0x00 CTRL   [RW] bit0=使能, bit1=软复位
//              0x04 STATUS [RO] bit0=运行中, bit1=故障
//              0x08 FREQ   [RW] 输出频率配置（单位 Hz）
//              0x0C PHASE  [RW] 输出相位配置（单位 0.1°，范围 0~3599）
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/05/26  创建文件
/**************************************************************************/

module ctrl_regs #(
  parameter DATA_WIDTH = 32,  // AXI-Lite 数据位宽（固定 32）
  parameter ADDR_WIDTH = 4    // 地址位宽（支持 16 字节地址空间）
) (
  input  wire                  s_axi_aclk    ,  // AXI 时钟
  input  wire                  s_axi_aresetn ,  // AXI 低有效复位

  // ---- 写地址通道 ----
  input  wire [ADDR_WIDTH-1:0] s_axi_awaddr  ,
  input  wire                  s_axi_awvalid ,
  output reg                   s_axi_awready ,

  // ---- 写数据通道 ----
  input  wire [DATA_WIDTH-1:0] s_axi_wdata   ,
  input  wire [DATA_WIDTH/8-1:0] s_axi_wstrb ,
  input  wire                  s_axi_wvalid  ,
  output reg                   s_axi_wready  ,

  // ---- 写响应通道 ----
  output reg  [1:0]            s_axi_bresp   ,
  output reg                   s_axi_bvalid  ,
  input  wire                  s_axi_bready  ,

  // ---- 读地址通道 ----
  input  wire [ADDR_WIDTH-1:0] s_axi_araddr  ,
  input  wire                  s_axi_arvalid ,
  output reg                   s_axi_arready ,

  // ---- 读数据通道 ----
  output reg  [DATA_WIDTH-1:0] s_axi_rdata   ,
  output reg  [1:0]            s_axi_rresp   ,
  output reg                   s_axi_rvalid  ,
  input  wire                  s_axi_rready  ,

  // ---- 用户逻辑接口 ----
  output wire        ctrl_enable   ,  // 使能位（CTRL[0]）
  output wire        ctrl_srst     ,  // 软复位位（CTRL[1]）
  output wire [31:0] freq_cfg      ,  // 频率配置
  output wire [31:0] phase_cfg     ,  // 相位配置
  input  wire [31:0] status_in        // 状态反馈（只读）
);

// ---- 寄存器地址 ----
localparam ADDR_CTRL   = 4'h0 ;
localparam ADDR_STATUS = 4'h4 ;
localparam ADDR_FREQ   = 4'h8 ;
localparam ADDR_PHASE  = 4'hC ;

// ---- 寄存器存储 ----
reg [31:0] reg_ctrl  ;
reg [31:0] reg_freq  ;
reg [31:0] reg_phase ;

// ---- 写地址锁存 ----
reg [ADDR_WIDTH-1:0] aw_addr_latch ;

// ---- 写通道 ----
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        s_axi_awready  <= 1'b0;
        aw_addr_latch <= {ADDR_WIDTH{1'b0}};
      end
    else
      begin
        if (s_axi_awvalid == 1'b1 && s_axi_awready == 1'b0)
          begin
            s_axi_awready   <= 1'b1;
            aw_addr_latch <= s_axi_awaddr;
          end
        else
          begin
            s_axi_awready <= 1'b0;
          end
      end
  end

always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        s_axi_wready <= 1'b0;
      end
    else
      begin
        if (s_axi_wvalid == 1'b1 && s_axi_wready == 1'b0)
          begin
            s_axi_wready <= 1'b1;
          end
        else
          begin
            s_axi_wready <= 1'b0;
          end
      end
  end

// ---- 寄存器写操作 ----
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        reg_ctrl  <= 32'd0;
        reg_freq  <= 32'd1000;  // 默认 1000 Hz
        reg_phase <= 32'd0;
      end
    else if (s_axi_awready == 1'b1 && s_axi_awvalid == 1'b1 &&
             s_axi_wready  == 1'b1 && s_axi_wvalid  == 1'b1)
      begin
        case (aw_addr_latch[3:0])
          ADDR_CTRL  : reg_ctrl  <= s_axi_wdata;
          ADDR_FREQ  : reg_freq  <= s_axi_wdata;
          ADDR_PHASE : reg_phase <= s_axi_wdata;
          default    : ;  // STATUS 寄存器只读，忽略写操作
        endcase
      end
  end

// ---- 写响应 ----
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        s_axi_bvalid <= 1'b0;
        s_axi_bresp  <= 2'b00;
      end
    else
      begin
        if (s_axi_awready == 1'b1 && s_axi_awvalid == 1'b1 &&
            s_axi_wready  == 1'b1 && s_axi_wvalid  == 1'b1 &&
            s_axi_bvalid  == 1'b0)
          begin
            s_axi_bvalid <= 1'b1;
            s_axi_bresp  <= 2'b00;
          end
        else if (s_axi_bready == 1'b1 && s_axi_bvalid == 1'b1)
          begin
            s_axi_bvalid <= 1'b0;
          end
      end
  end

// ---- 读地址通道 ----
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        s_axi_arready <= 1'b0;
      end
    else
      begin
        if (s_axi_arvalid == 1'b1 && s_axi_arready == 1'b0)
          begin
            s_axi_arready <= 1'b1;
          end
        else
          begin
            s_axi_arready <= 1'b0;
          end
      end
  end

// ---- 读数据 ----
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        s_axi_rvalid <= 1'b0;
        s_axi_rresp  <= 2'b00;
        s_axi_rdata  <= 32'd0;
      end
    else
      begin
        if (s_axi_arready == 1'b1 && s_axi_arvalid == 1'b1 && s_axi_rvalid == 1'b0)
          begin
            s_axi_rvalid <= 1'b1;
            s_axi_rresp  <= 2'b00;
            case (s_axi_araddr[3:0])
              ADDR_CTRL   : s_axi_rdata <= reg_ctrl ;
              ADDR_STATUS : s_axi_rdata <= status_in  ;
              ADDR_FREQ   : s_axi_rdata <= reg_freq ;
              ADDR_PHASE  : s_axi_rdata <= reg_phase;
              default     : s_axi_rdata <= 32'h0;
            endcase
          end
        else if (s_axi_rvalid == 1'b1 && s_axi_rready == 1'b1)
          begin
            s_axi_rvalid <= 1'b0;
          end
      end
  end

// ---- 输出赋值 ----
assign ctrl_enable = reg_ctrl[0] ;
assign ctrl_srst   = reg_ctrl[1] ;
assign freq_cfg    = reg_freq    ;
assign phase_cfg   = reg_phase   ;

endmodule
