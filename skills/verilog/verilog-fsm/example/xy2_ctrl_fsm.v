/**************************************************************************/
// Function   : XY2-100 发送控制状态机
// Version    : v1.0
// Date       : 2026/03/23
// Description: 控制 XY2-100 协议帧发送流程，包含
//              空闲、加载数据、发送、等待应答四个状态
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        2026/03/23  创建文件
/**************************************************************************/

module xy2_ctrl_fsm #(
  parameter DATA_WIDTH = 16
) (
  input  wire                  clk        ,  // 系统时钟
  input  wire                  rst_n      ,  // 低有效复位
  input  wire                  i_start    ,  // 发送触发脉冲
  input  wire [DATA_WIDTH-1:0] i_data     ,  // 待发送坐标数据
  input  wire                  i_tx_done  ,  // 发送完成信号
  input  wire                  i_ack      ,  // 应答信号
  output reg  [DATA_WIDTH-1:0] o_tx_data  ,  // 送入发送器的数据
  output reg                   o_tx_en    ,  // 发送使能
  output reg                   o_busy     ,  // 忙标志
  output reg                   o_error       // 应答超时错误
);

// ---- 状态参数定义 ----//
localparam [1:0] IDLE  = 2'd0 ;  // 空闲，等待触发
localparam [1:0] LOAD  = 2'd1 ;  // 加载数据到发送器
localparam [1:0] SEND  = 2'd2 ;  // 发送中，等待完成
localparam [1:0] WAIT  = 2'd3 ;  // 等待应答

// ---- 信号声明 ----//
reg [1:0]  state_r      ;  // 当前状态
reg [1:0]  state_next_r ;  // 下一状态
reg [15:0] timeout_cnt_r;  // 应答超时计数器

// ---- 状态寄存器（时序逻辑）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        state_r <= IDLE ;
      end
    else
      begin
        state_r <= state_next_r ;
      end
  end

// ---- 次态逻辑（组合逻辑）----//
always @(*)
  begin
    state_next_r = state_r ;
    case (state_r)
      IDLE :
        begin
          if (i_start == 1'b1)
            state_next_r = LOAD ;
        end
      LOAD :
        begin
          state_next_r = SEND ;
        end
      SEND :
        begin
          if (i_tx_done == 1'b1)
            state_next_r = WAIT ;
        end
      WAIT :
        begin
          if (i_ack == 1'b1)
            state_next_r = IDLE ;
          else if (timeout_cnt_r == 16'hFFFF)  // 超时返回空闲
            state_next_r = IDLE ;
        end
      default :
        begin
          state_next_r = IDLE ;
        end
    endcase
  end

// ---- 超时计数器（时序逻辑）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        timeout_cnt_r <= 16'd0 ;
      end
    else if (state_r == WAIT)
      begin
        timeout_cnt_r <= timeout_cnt_r + 16'd1 ;
      end
    else
      begin
        timeout_cnt_r <= 16'd0 ;
      end
  end

// ---- 输出逻辑（时序逻辑）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        o_tx_data <= {DATA_WIDTH{1'b0}} ;
        o_tx_en   <= 1'b0              ;
        o_busy    <= 1'b0              ;
        o_error   <= 1'b0              ;
      end
    else
      begin
        o_tx_en  <= 1'b0 ;  // 默认低
        o_error  <= 1'b0 ;
        o_busy   <= (state_r != IDLE) ? 1'b1 : 1'b0 ;
        case (state_r)
          LOAD :
            begin
              o_tx_data <= i_data  ;
              o_tx_en   <= 1'b1   ;
            end
          WAIT :
            begin
              if (timeout_cnt_r == 16'hFFFF)
                o_error <= 1'b1 ;  // 超时置错误标志
            end
          default : ;
        endcase
      end
  end

endmodule
