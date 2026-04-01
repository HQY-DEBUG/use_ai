---
name: verilog-fsm
description: 生成符合项目规范的 Verilog 有限状态机（FSM）模板。用法：/verilog-fsm <模块名> <状态列表（逗号分隔）>
argument-hint: <模块名> <状态1,状态2,状态3,...>
allowed-tools: [Write, Bash]
disable-model-invocation: true
---

# 生成 Verilog FSM 模块

参数：$ARGUMENTS

## 操作步骤

1. 从参数解析**模块名**（第一个词）和**状态列表**（逗号分隔的状态名，均转为大写）
2. 若未提供状态列表，默认使用：`IDLE, RUN, DONE, ERROR`
3. 生成 `.v` 文件，替换以下占位符：
   - `MODULE_NAME` → 模块名（小写下划线）
   - `TODAY` → 今天日期（格式 YYYY/MM/DD），通过 PowerShell 获取：`Get-Date -Format "yyyy/MM/dd"`
   - 状态参数与 case 分支 → 根据实际状态列表展开

## 生成模板（以 IDLE/RUN/DONE/ERROR 为例）

```verilog
/**************************************************************************/
// Function   : MODULE_NAME 状态机
// Version    : v1.0
// Date       : TODAY
// Description: 有限状态机（FSM）实现
//
// Modify:
// version       date       modify
// --------    -----------  ------------------------------------------------
//  v1.0        TODAY  创建文件
/**************************************************************************/

module MODULE_NAME #(
  parameter DATA_WIDTH = 16
) (
  input  wire        clk   ,  // 系统时钟
  input  wire        rst_n ,  // 低有效复位
  input  wire        i_xxx ,  // 触发信号（按需修改）
  output wire        o_xxx    // 输出信号（按需修改）
);

// ---- 状态参数定义 ----//
localparam [1:0] IDLE  = 2'd0 ;
localparam [1:0] RUN   = 2'd1 ;
localparam [1:0] DONE  = 2'd2 ;
localparam [1:0] ERROR = 2'd3 ;

// ---- 状态寄存器声明 ----//
reg [1:0] state      ;  // 当前状态
reg [1:0] state_next   ;  // 下一状态

// ---- 状态寄存器（时序逻辑）----//
always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
      begin
        state <= IDLE ;
      end
    else
      begin
        state <= state_next ;
      end
  end

// ---- 次态逻辑（组合逻辑）----//
always @(*)
  begin
    state_next = state ;  // 默认保持当前状态
    case (state)
      IDLE :
        begin
          if (i_xxx == 1'b1)
            state_next = RUN ;
        end
      RUN :
        begin
          state_next = DONE ;
        end
      DONE :
        begin
          state_next = IDLE ;
        end
      ERROR :
        begin
          state_next = IDLE ;
        end
      default :
        begin
          state_next = IDLE ;
        end
    endcase
  end

// ---- 输出逻辑（组合逻辑）----//
assign o_xxx = (state == DONE) ? 1'b1 : 1'b0 ;

endmodule
```

4. 写入文件后告知用户文件路径
5. 提示用户：状态位宽需根据实际状态数量调整（N个状态需 $\lceil\log_2 N\rceil$ 位）
6. 提醒用户执行 `git commit`
