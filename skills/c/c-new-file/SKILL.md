---
name: c-new-file
description: 新建 C/C++ 源文件（.c/.cpp）及对应头文件（.h/.hpp），自动生成符合项目规范的文件头、include guard 和函数框架。用法：/c-new-file <文件名（不含扩展名）> [模块描述]
argument-hint: <文件名> [模块描述]
allowed-tools: [Read, Write, Bash]
disable-model-invocation: true
---

# 新建 C/C++ 文件对

参数：$ARGUMENTS

## 操作步骤

1. 从参数解析**文件名**（第一个词，小写下划线）和**模块描述**（其余部分）
2. 根据扩展名规则判断类型：
   - 含 `qt` 或用户指定 `cpp` → 生成 `.cpp` + `.h`
   - 否则 → 生成 `.c` + `.h`
3. 替换占位符后生成两个文件：
   - `FILE_NAME` → 文件名（小写下划线）
   - `GUARD_NAME` → 全大写下划线（用于 include guard），如 `DMA_DATA_H`
   - `MODULE_DESC` → 模块描述
   - `TODAY` → 今天日期（格式 YYYY-MM-DD）
   - `TODAY_SHORT` → 今天日期（格式 YY/MM/DD）

## 头文件模板（.h）

```c
/*
 * 文件 : FILE_NAME.h
 * 描述 : MODULE_DESC
 * 版本 : v1.0
 * 日期 : TODAY
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      TODAY_SHORT   创建文件
 */

#ifndef FILE_NAME_H
#define FILE_NAME_H

#ifdef __cplusplus
extern "C" {
#endif

// ---- 宏定义 ----//

// ---- 类型定义 ----//

// ---- 函数声明 ----//

/**
 * @brief  模块初始化
 * @return 0 成功，-1 失败
 */
int FILE_NAME_init(void);

/**
 * @brief  模块轮询处理（主循环调用）
 */
void FILE_NAME_poll(void);

#ifdef __cplusplus
}
#endif

#endif /* FILE_NAME_H */
```

## 源文件模板（.c）

```c
/*
 * 文件 : FILE_NAME.c
 * 描述 : MODULE_DESC
 * 版本 : v1.0
 * 日期 : TODAY
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      TODAY_SHORT   创建文件
 */

#include "FILE_NAME.h"

// ---- 私有宏定义 ----//

// ---- 私有类型定义 ----//

// ---- 私有变量 ----//

// ---- 函数实现 ----//

/**
 * @brief  模块初始化
 * @return 0 成功，-1 失败
 */
int FILE_NAME_init(void) {
    return 0;
}

/**
 * @brief  模块轮询处理（主循环调用）
 */
void FILE_NAME_poll(void) {

}
```

4. 生成文件后告知用户路径，提示按需增删函数声明
5. 提醒用户执行 `git commit`
