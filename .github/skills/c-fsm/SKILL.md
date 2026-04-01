---
name: c-fsm
description: 生成 C 语言状态机框架（状态枚举、switch-case 转移、动作函数骨架）。用法：/c-fsm <模块名> <状态列表>
argument-hint: <模块名> <状态列表（空格分隔）>
allowed-tools: [Read, Write, Bash]
---

# 生成 C 语言状态机框架

参数：$ARGUMENTS

## 参数格式

```
/c-fsm <模块名> <状态1> <状态2> ... <状态N>
```

示例：
```
/c-fsm laser_ctrl IDLE INIT RUNNING ERROR STOP
```

## 操作步骤

1. 解析参数：提取**模块名**（小写下划线）和**状态列表**
2. 自动推导：
   - 枚举前缀：模块名全大写 + `_STATE_`，如 `LASER_CTRL_STATE_`
   - 函数前缀：模块名 + `_`，如 `laser_ctrl_`
3. 生成两个文件：`<模块名>_fsm.h` 和 `<模块名>_fsm.c`

## 头文件模板（_fsm.h）

```c
/*
 * 文件 : MODULE_fsm.h
 * 描述 : MODULE 状态机头文件
 * 版本 : v1.0
 * 日期 : TODAY
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      TODAY_SHORT   创建文件
 */

#ifndef MODULE_FSM_H
#define MODULE_FSM_H

#include <stdint.h>

// ---- 状态枚举 ----//

typedef enum {
    PREFIX_STATE1 = 0,  // 状态1说明
    PREFIX_STATE2,      // 状态2说明
    /* ... */
    PREFIX_STATE_MAX    // 状态总数（边界值，勿直接使用）
} ModuleState;

// ---- 上下文结构体 ----//

/**
 * @brief  MODULE 状态机上下文
 */
typedef struct {
    ModuleState  cur_state;   // 当前状态
    ModuleState  pre_state;   // 上一状态
    uint32_t     state_timer; // 状态内计时（tick）
} ModuleFsm;

// ---- 函数声明 ----//

/**
 * @brief  初始化状态机
 * @param  fsm  状态机上下文指针
 */
void module_fsm_init(ModuleFsm *fsm);

/**
 * @brief  状态机轮询（主循环调用）
 * @param  fsm  状态机上下文指针
 */
void module_fsm_poll(ModuleFsm *fsm);

/**
 * @brief  获取当前状态名称字符串（调试用）
 * @param  state  状态枚举值
 * @return 状态名称字符串
 */
const char *module_fsm_state_name(ModuleState state);

#endif /* MODULE_FSM_H */
```

## 源文件模板（_fsm.c）

```c
/*
 * 文件 : MODULE_fsm.c
 * 描述 : MODULE 状态机实现
 * 版本 : v1.0
 * 日期 : TODAY
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      TODAY_SHORT   创建文件
 */

#include "MODULE_fsm.h"
#include <string.h>

// ---- 私有函数声明 ----//

static void fsm_enter_STATE1(ModuleFsm *fsm);
static void fsm_run_STATE1(ModuleFsm *fsm);
static void fsm_exit_STATE1(ModuleFsm *fsm);
/* 每个状态对应 enter / run / exit 三个函数 */

// ---- 状态名称表（调试用）----//

static const char *const STATE_NAMES[] = {
    "STATE1",
    "STATE2",
    /* ... */
};

// ---- 公共函数 ----//

/**
 * @brief  初始化状态机
 */
void module_fsm_init(ModuleFsm *fsm) {
    memset(fsm, 0, sizeof(ModuleFsm));
    fsm->cur_state = PREFIX_STATE1;
    fsm_enter_STATE1(fsm);
}

/**
 * @brief  状态机轮询（主循环调用）
 */
void module_fsm_poll(ModuleFsm *fsm) {
    fsm->state_timer++;

    switch (fsm->cur_state) {
        case PREFIX_STATE1: fsm_run_STATE1(fsm); break;
        case PREFIX_STATE2: fsm_run_STATE2(fsm); break;
        /* ... */
        default: break;
    }
}

/**
 * @brief  状态转移（内部调用）
 */
static void fsm_trans(ModuleFsm *fsm, ModuleState next) {
    // 调用当前状态的 exit
    switch (fsm->cur_state) {
        case PREFIX_STATE1: fsm_exit_STATE1(fsm); break;
        /* ... */
        default: break;
    }
    fsm->pre_state    = fsm->cur_state;
    fsm->cur_state    = next;
    fsm->state_timer  = 0;
    // 调用新状态的 enter
    switch (next) {
        case PREFIX_STATE1: fsm_enter_STATE1(fsm); break;
        /* ... */
        default: break;
    }
}

const char *module_fsm_state_name(ModuleState state) {
    if (state >= PREFIX_STATE_MAX) {
        return "UNKNOWN";
    }
    return STATE_NAMES[state];
}

// ---- 状态实现 ----//

static void fsm_enter_STATE1(ModuleFsm *fsm) { (void)fsm; }
static void fsm_run_STATE1(ModuleFsm *fsm)   { (void)fsm; }
static void fsm_exit_STATE1(ModuleFsm *fsm)  { (void)fsm; }
```

## 生成规则

- 状态枚举值全大写，前缀为模块名大写 + `_STATE_`
- 每个状态生成 `enter` / `run` / `exit` 三个私有函数（三段式）
- `fsm_trans()` 负责调用 exit→切换→enter，保证状态切换完整性
- `state_timer` 在 `fsm_trans()` 内自动清零，供超时判断
- 调试名称表与枚举顺序保持一致

## 注意事项

- 生成后提示用户在各 `run_*` 函数内填写转移条件，调用 `fsm_trans()`
- `STATE_MAX` 仅用于数组边界，不作为有效状态
- 若模块已有 `.c`/`.h`，询问是否追加到现有文件或新建 `_fsm` 子文件

## 参考示例

完整示例见 [example/cmd_fsm.c](example/cmd_fsm.c)
