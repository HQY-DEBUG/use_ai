/*
 * 文件 : cmd_fsm.c
 * 描述 : 命令处理状态机示例（由 /c-fsm 生成）
 * 版本 : v1.0
 * 日期 : 2026/03/27
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/03/27   创建文件
 */

#include "cmd_fsm.h"
#include <string.h>

// ---- 状态名称表（调试用）----//

static const char *const STATE_NAMES[] = {
    "IDLE",
    "RECV",
    "PROC",
    "SEND",
    "ERROR",
};

// ---- 私有函数声明 ----//

static void fsm_enter_idle(CmdFsm *fsm);
static void fsm_run_idle(CmdFsm *fsm);
static void fsm_exit_idle(CmdFsm *fsm);

static void fsm_enter_recv(CmdFsm *fsm);
static void fsm_run_recv(CmdFsm *fsm);
static void fsm_exit_recv(CmdFsm *fsm);

static void fsm_enter_proc(CmdFsm *fsm);
static void fsm_run_proc(CmdFsm *fsm);
static void fsm_exit_proc(CmdFsm *fsm);

static void fsm_enter_send(CmdFsm *fsm);
static void fsm_run_send(CmdFsm *fsm);
static void fsm_exit_send(CmdFsm *fsm);

static void fsm_enter_error(CmdFsm *fsm);
static void fsm_run_error(CmdFsm *fsm);
static void fsm_exit_error(CmdFsm *fsm);

// ---- 公共函数 ----//

void cmd_fsm_init(CmdFsm *fsm) {
    memset(fsm, 0, sizeof(CmdFsm));
    fsm->cur_state = CMD_STATE_IDLE;
    fsm_enter_idle(fsm);
}

void cmd_fsm_poll(CmdFsm *fsm) {
    fsm->state_timer++;

    switch (fsm->cur_state) {
        case CMD_STATE_IDLE:  fsm_run_idle(fsm);  break;
        case CMD_STATE_RECV:  fsm_run_recv(fsm);  break;
        case CMD_STATE_PROC:  fsm_run_proc(fsm);  break;
        case CMD_STATE_SEND:  fsm_run_send(fsm);  break;
        case CMD_STATE_ERROR: fsm_run_error(fsm); break;
        default:              break;
    }
}

static void fsm_trans(CmdFsm *fsm, CmdState next) {
    switch (fsm->cur_state) {
        case CMD_STATE_IDLE:  fsm_exit_idle(fsm);  break;
        case CMD_STATE_RECV:  fsm_exit_recv(fsm);  break;
        case CMD_STATE_PROC:  fsm_exit_proc(fsm);  break;
        case CMD_STATE_SEND:  fsm_exit_send(fsm);  break;
        case CMD_STATE_ERROR: fsm_exit_error(fsm); break;
        default:              break;
    }
    fsm->pre_state   = fsm->cur_state;
    fsm->cur_state   = next;
    fsm->state_timer = 0;
    switch (next) {
        case CMD_STATE_IDLE:  fsm_enter_idle(fsm);  break;
        case CMD_STATE_RECV:  fsm_enter_recv(fsm);  break;
        case CMD_STATE_PROC:  fsm_enter_proc(fsm);  break;
        case CMD_STATE_SEND:  fsm_enter_send(fsm);  break;
        case CMD_STATE_ERROR: fsm_enter_error(fsm); break;
        default:              break;
    }
}

const char *cmd_fsm_state_name(CmdState state) {
    if (state >= CMD_STATE_MAX) {
        return "UNKNOWN";
    }
    return STATE_NAMES[state];
}

// ---- IDLE 状态 ----//

static void fsm_enter_idle(CmdFsm *fsm) { (void)fsm; }

static void fsm_run_idle(CmdFsm *fsm) {
    if (fsm->has_new_data == 1) {   // 有新数据 → 进入接收
        fsm_trans(fsm, CMD_STATE_RECV);
    }
}

static void fsm_exit_idle(CmdFsm *fsm) { (void)fsm; }

// ---- RECV 状态 ----//

static void fsm_enter_recv(CmdFsm *fsm) { (void)fsm; }

static void fsm_run_recv(CmdFsm *fsm) {
    if (fsm->recv_done == 1) {       // 接收完成 → 处理
        fsm_trans(fsm, CMD_STATE_PROC);
    } else if (fsm->state_timer > 1000) {  // 超时 → 错误
        fsm_trans(fsm, CMD_STATE_ERROR);
    }
}

static void fsm_exit_recv(CmdFsm *fsm) { (void)fsm; }

// ---- PROC 状态 ----//

static void fsm_enter_proc(CmdFsm *fsm) { (void)fsm; }

static void fsm_run_proc(CmdFsm *fsm) {
    // 处理完成 → 发送应答
    fsm_trans(fsm, CMD_STATE_SEND);
}

static void fsm_exit_proc(CmdFsm *fsm) { (void)fsm; }

// ---- SEND 状态 ----//

static void fsm_enter_send(CmdFsm *fsm) { (void)fsm; }

static void fsm_run_send(CmdFsm *fsm) {
    if (fsm->send_done == 1) {       // 发送完成 → 回到 IDLE
        fsm_trans(fsm, CMD_STATE_IDLE);
    }
}

static void fsm_exit_send(CmdFsm *fsm) { (void)fsm; }

// ---- ERROR 状态 ----//

static void fsm_enter_error(CmdFsm *fsm) { (void)fsm; }

static void fsm_run_error(CmdFsm *fsm) {
    if (fsm->state_timer > 100) {    // 等待 100 tick 后复位
        fsm_trans(fsm, CMD_STATE_IDLE);
    }
}

static void fsm_exit_error(CmdFsm *fsm) { (void)fsm; }
