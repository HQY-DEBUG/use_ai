/*
 * 文件 : motor_ctrl_fsm.h
 * 描述 : 电机控制状态机 — 头文件
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#ifndef MOTOR_CTRL_FSM_H
#define MOTOR_CTRL_FSM_H

#include <stdint.h>

// ---- 状态枚举 ----//
typedef enum {
    MOTOR_STATE_IDLE    = 0,  // 空闲：等待启动指令
    MOTOR_STATE_RUNNING = 1,  // 运行：电机正常转动
    MOTOR_STATE_FAULT   = 2,  // 故障：过流/过温等保护触发
    MOTOR_STATE_MAX           // 状态总数（边界检查用）
} motor_state_t;

// ---- 事件枚举 ----//
typedef enum {
    MOTOR_EVT_START       = 0,  // 启动指令
    MOTOR_EVT_STOP        = 1,  // 停止指令
    MOTOR_EVT_FAULT_OCCUR = 2,  // 故障发生
    MOTOR_EVT_FAULT_CLEAR = 3,  // 故障复位
    MOTOR_EVT_MAX               // 事件总数
} motor_event_t;

// ---- 状态机上下文 ----//
typedef struct {
    motor_state_t  cur_state;   // 当前状态
    motor_state_t  pre_state;   // 上一状态（调试用）
    uint32_t       run_cnt;     // 运行计数（进入RUNNING后累计）
    uint32_t       fault_code;  // 故障码（进入FAULT时记录）
} motor_fsm_t;

// ---- 公共接口 ----//
void motor_fsm_init(motor_fsm_t *fsm);
void motor_fsm_dispatch(motor_fsm_t *fsm, motor_event_t evt);
const char *motor_fsm_state_name(motor_state_t state);

#endif // MOTOR_CTRL_FSM_H
