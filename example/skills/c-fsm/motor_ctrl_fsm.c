/*
 * 文件 : motor_ctrl_fsm.c
 * 描述 : 电机控制状态机 — 实现文件（三段式：enter/run/exit）
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#include "motor_ctrl_fsm.h"
#include <string.h>
#include <stdio.h>

// ---- 前向声明（各状态处理函数）----//
static void state_idle_enter(motor_fsm_t *fsm);
static void state_idle_run(motor_fsm_t *fsm, motor_event_t evt);
static void state_idle_exit(motor_fsm_t *fsm);

static void state_running_enter(motor_fsm_t *fsm);
static void state_running_run(motor_fsm_t *fsm, motor_event_t evt);
static void state_running_exit(motor_fsm_t *fsm);

static void state_fault_enter(motor_fsm_t *fsm);
static void state_fault_run(motor_fsm_t *fsm, motor_event_t evt);
static void state_fault_exit(motor_fsm_t *fsm);

// ---- 状态转移辅助 ----//
static void fsm_transition(motor_fsm_t *fsm, motor_state_t next);

// ============================================================
// 公共接口实现
// ============================================================

/**
 * @brief  初始化状态机，进入 IDLE 状态
 * @param  fsm  状态机上下文指针
 */
void motor_fsm_init(motor_fsm_t *fsm) {
    memset(fsm, 0, sizeof(motor_fsm_t));
    fsm->cur_state = MOTOR_STATE_IDLE;
    fsm->pre_state = MOTOR_STATE_IDLE;
    state_idle_enter(fsm);
}

/**
 * @brief  分发事件，驱动状态机运转
 * @param  fsm  状态机上下文指针
 * @param  evt  待处理事件
 */
void motor_fsm_dispatch(motor_fsm_t *fsm, motor_event_t evt) {
    if (fsm == NULL || evt >= MOTOR_EVT_MAX) {
        return;
    }
    switch (fsm->cur_state) {
        case MOTOR_STATE_IDLE:    state_idle_run(fsm, evt);    break;
        case MOTOR_STATE_RUNNING: state_running_run(fsm, evt); break;
        case MOTOR_STATE_FAULT:   state_fault_run(fsm, evt);   break;
        default:                                                break;
    }
}

/**
 * @brief  获取状态名称字符串（调试用）
 * @param  state  目标状态
 * @return 状态名称字符串
 */
const char *motor_fsm_state_name(motor_state_t state) {
    static const char *names[] = {"IDLE", "RUNNING", "FAULT", "MAX"};
    if (state >= MOTOR_STATE_MAX) {
        return "UNKNOWN";
    }
    return names[state];
}

// ============================================================
// 状态转移
// ============================================================
static void fsm_transition(motor_fsm_t *fsm, motor_state_t next) {
    // 退出当前状态
    switch (fsm->cur_state) {
        case MOTOR_STATE_IDLE:    state_idle_exit(fsm);    break;
        case MOTOR_STATE_RUNNING: state_running_exit(fsm); break;
        case MOTOR_STATE_FAULT:   state_fault_exit(fsm);   break;
        default:                                           break;
    }
    fsm->pre_state = fsm->cur_state;
    fsm->cur_state = next;
    // 进入新状态
    switch (next) {
        case MOTOR_STATE_IDLE:    state_idle_enter(fsm);    break;
        case MOTOR_STATE_RUNNING: state_running_enter(fsm); break;
        case MOTOR_STATE_FAULT:   state_fault_enter(fsm);   break;
        default:                                            break;
    }
}

// ============================================================
// IDLE 状态
// ============================================================
static void state_idle_enter(motor_fsm_t *fsm) {
    (void)fsm;
    // TODO: 关闭 PWM 输出，停止电机驱动
    printf("[FSM] 进入 IDLE 状态\n");
}

static void state_idle_run(motor_fsm_t *fsm, motor_event_t evt) {
    switch (evt) {
        case MOTOR_EVT_START:
            fsm_transition(fsm, MOTOR_STATE_RUNNING);
            break;
        case MOTOR_EVT_FAULT_OCCUR:
            fsm->fault_code = 0x01;  // 空闲时故障（外部触发）
            fsm_transition(fsm, MOTOR_STATE_FAULT);
            break;
        default:
            break;  // 其余事件在 IDLE 状态下忽略
    }
}

static void state_idle_exit(motor_fsm_t *fsm) {
    (void)fsm;
    // TODO: 清除空闲标志
}

// ============================================================
// RUNNING 状态
// ============================================================
static void state_running_enter(motor_fsm_t *fsm) {
    fsm->run_cnt = 0;
    // TODO: 启动 PWM，使能电机驱动桥
    printf("[FSM] 进入 RUNNING 状态\n");
}

static void state_running_run(motor_fsm_t *fsm, motor_event_t evt) {
    fsm->run_cnt++;
    switch (evt) {
        case MOTOR_EVT_STOP:
            fsm_transition(fsm, MOTOR_STATE_IDLE);
            break;
        case MOTOR_EVT_FAULT_OCCUR:
            fsm->fault_code = 0x02;  // 运行时故障（过流/过温）
            fsm_transition(fsm, MOTOR_STATE_FAULT);
            break;
        default:
            break;
    }
}

static void state_running_exit(motor_fsm_t *fsm) {
    (void)fsm;
    // TODO: 停止 PWM 输出
}

// ============================================================
// FAULT 状态
// ============================================================
static void state_fault_enter(motor_fsm_t *fsm) {
    // TODO: 关闭驱动桥，点亮故障指示灯，上报故障码
    printf("[FSM] 进入 FAULT 状态，故障码=0x%02X\n", fsm->fault_code);
}

static void state_fault_run(motor_fsm_t *fsm, motor_event_t evt) {
    switch (evt) {
        case MOTOR_EVT_FAULT_CLEAR:
            fsm->fault_code = 0x00;
            fsm_transition(fsm, MOTOR_STATE_IDLE);
            break;
        default:
            break;  // 故障未消除前忽略其他事件
    }
}

static void state_fault_exit(motor_fsm_t *fsm) {
    (void)fsm;
    // TODO: 关闭故障指示灯，清除保护标志
}
