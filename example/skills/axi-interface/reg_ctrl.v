/**************************************************************************/
// Function   : AXI-Lite 从机寄存器控制接口
// Version    : v1.0
// Date       : 2026/05/26
// Description: 提供 4 个 32 位可读写寄存器，通过 AXI-Lite 总线访问。
//              CTRL 寄存器控制模块使能；STATUS 只读反映运行状态；
//              FREQ/PHASE 用于配置输出参数。
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/05/26  创建文件
/**************************************************************************/

module reg_ctrl #(
  parameter DATA_WIDTH = 32 ,  // 数据位宽（固定32位，AXI-Lite规范）
  parameter ADDR_WIDTH = 4     // 地址位宽（支持16字节地址空间）
) (
  // ---- AXI-Lite 时钟与复位 ----
  input  wire                  s_axi_aclk    ,  // AXI 时钟
  input  wire                  s_axi_aresetn ,  // AXI 低有效复位

  // ---- 写地址通道 ----
  input  wire [ADDR_WIDTH-1:0] s_axi_awaddr  ,  // 写地址
  input  wire                  s_axi_awvalid ,  // 写地址有效
  output wire                  s_axi_awready ,  // 写地址就绪

  // ---- 写数据通道 ----
  input  wire [DATA_WIDTH-1:0] s_axi_wdata   ,  // 写数据
  input  wire [DATA_WIDTH/8-1:0] s_axi_wstrb ,  // 字节使能
  input  wire                  s_axi_wvalid  ,  // 写数据有效
  output wire                  s_axi_wready  ,  // 写数据就绪

  // ---- 写响应通道 ----
  output wire [1:0]            s_axi_bresp   ,  // 写响应（00=OKAY）
  output wire                  s_axi_bvalid  ,  // 写响应有效
  input  wire                  s_axi_bready  ,  // 写响应就绪

  // ---- 读地址通道 ----
  input  wire [ADDR_WIDTH-1:0] s_axi_araddr  ,  // 读地址
  input  wire                  s_axi_arvalid ,  // 读地址有效
  output wire                  s_axi_arready ,  // 读地址就绪

  // ---- 读数据通道 ----
  output wire [DATA_WIDTH-1:0] s_axi_rdata   ,  // 读数据
  output wire [1:0]            s_axi_rresp   ,  // 读响应
  output wire                  s_axi_rvalid  ,  // 读数据有效
  input  wire                  s_axi_rready  ,  // 读数据就绪

  // ---- 用户逻辑接口 ----
  output wire                  ctrl_enable   ,  // 使能输出
  output wire [31:0]           freq_val      ,  // 频率配置值
  output wire [31:0]           phase_val     ,  // 相位配置值
  input  wire [31:0]           status_in        // 状态输入（只读）
);

// ---- 内部寄存器地址定义 ----
localparam ADDR_CTRL   = 4'h0 ;  // 控制寄存器地址
localparam ADDR_STATUS = 4'h4 ;  // 状态寄存器地址（只读）
localparam ADDR_FREQ   = 4'h8 ;  // 频率配置寄存器地址
localparam ADDR_PHASE  = 4'hC ;  // 相位配置寄存器地址

// ---- 内部寄存器 ----
reg  [31:0]  reg_ctrl   ;  // 控制寄存器
reg  [31:0]  reg_freq   ;  // 频率寄存器
reg  [31:0]  reg_phase  ;  // 相位寄存器

// ---- 写通道控制信号 ----
reg          aw_ready   ;  // 写地址就绪
reg          w_ready    ;  // 写数据就绪
reg          b_valid    ;  // 写响应有效
reg  [1:0]   b_resp     ;  // 写响应码

// ---- 读通道控制信号 ----
reg          ar_ready   ;  // 读地址就绪
reg  [31:0]  r_data     ;  // 读数据寄存器
reg          r_valid    ;  // 读数据有效
reg  [1:0]   r_resp     ;  // 读响应码

// ---- 写地址/写数据锁存 ----
reg  [ADDR_WIDTH-1:0] aw_addr ;  // 写地址锁存

// ---- 输出连接 ----
assign s_axi_awready = aw_ready  ;
assign s_axi_wready  = w_ready   ;
assign s_axi_bresp   = b_resp    ;
assign s_axi_bvalid  = b_valid   ;
assign s_axi_arready = ar_ready  ;
assign s_axi_rdata   = r_data    ;
assign s_axi_rresp   = r_resp    ;
assign s_axi_rvalid  = r_valid   ;

assign ctrl_enable   = reg_ctrl[0]  ;  // bit0 为使能位
assign freq_val      = reg_freq     ;
assign phase_val     = reg_phase    ;

// ---- 写地址通道 ----
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        aw_ready <= 1'b0;
        aw_addr  <= {ADDR_WIDTH{1'b0}};
      end
    else
      begin
        if (s_axi_awvalid == 1'b1 && aw_ready == 1'b0)
          begin
            aw_ready <= 1'b1;
            aw_addr  <= s_axi_awaddr;
          end
        else
          begin
            aw_ready <= 1'b0;
          end
      end
  end

// ---- 写数据通道 ----
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        w_ready <= 1'b0;
      end
    else
      begin
        if (s_axi_wvalid == 1'b1 && w_ready == 1'b0)
          begin
            w_ready <= 1'b1;
          end
        else
          begin
            w_ready <= 1'b0;
          end
      end
  end

// ---- 寄存器写操作 ----
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        reg_ctrl  <= 32'd0;
        reg_freq  <= 32'd0;
        reg_phase <= 32'd0;
      end
    else
      begin
        if (aw_ready == 1'b1 && s_axi_awvalid == 1'b1 &&
            w_ready  == 1'b1 && s_axi_wvalid  == 1'b1)
          begin
            case (aw_addr[3:0])
              ADDR_CTRL  : reg_ctrl  <= s_axi_wdata;
              ADDR_FREQ  : reg_freq  <= s_axi_wdata;
              ADDR_PHASE : reg_phase <= s_axi_wdata;
              default    : ;  // 只读寄存器不响应写操作
            endcase
          end
      end
  end

// ---- 写响应通道 ----
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        b_valid <= 1'b0;
        b_resp  <= 2'b00;
      end
    else
      begin
        if (aw_ready == 1'b1 && s_axi_awvalid == 1'b1 &&
            w_ready  == 1'b1 && s_axi_wvalid  == 1'b1 &&
            b_valid  == 1'b0)
          begin
            b_valid <= 1'b1;
            b_resp  <= 2'b00;  // OKAY
          end
        else if (s_axi_bready == 1'b1 && b_valid == 1'b1)
          begin
            b_valid <= 1'b0;
          end
      end
  end

// ---- 读地址通道 ----
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        ar_ready <= 1'b0;
      end
    else
      begin
        if (s_axi_arvalid == 1'b1 && ar_ready == 1'b0)
          begin
            ar_ready <= 1'b1;
          end
        else
          begin
            ar_ready <= 1'b0;
          end
      end
  end

// ---- 读数据通道 ----
always @(posedge s_axi_aclk or negedge s_axi_aresetn)
  begin
    if (s_axi_aresetn == 1'b0)
      begin
        r_valid <= 1'b0;
        r_resp  <= 2'b00;
        r_data  <= 32'd0;
      end
    else
      begin
        if (ar_ready == 1'b1 && s_axi_arvalid == 1'b1 && r_valid == 1'b0)
          begin
            r_valid <= 1'b1;
            r_resp  <= 2'b00;
            case (s_axi_araddr[3:0])
              ADDR_CTRL   : r_data <= reg_ctrl ;
              ADDR_STATUS : r_data <= status_in  ;
              ADDR_FREQ   : r_data <= reg_freq ;
              ADDR_PHASE  : r_data <= reg_phase;
              default     : r_data <= 32'hDEADBEEF;
            endcase
          end
        else if (r_valid == 1'b1 && s_axi_rready == 1'b1)
          begin
            r_valid <= 1'b0;
          end
      end
  end

endmodule
