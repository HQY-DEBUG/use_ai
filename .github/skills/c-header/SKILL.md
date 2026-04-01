---
name: c-header
description: 为已有 .c 文件生成或同步对应的 .h 头文件（函数声明、类型导出、include guard）。用法：/c-header <.c文件路径>
argument-hint: <.c文件路径>
allowed-tools: [Read, Write, Edit]
---

# 生成 / 同步 C 头文件

参数：$ARGUMENTS

## 操作步骤

1. 读取 `.c` 文件，提取：
   - 文件头信息（文件名、描述、版本、日期）
   - 所有**非 `static`** 函数的签名（返回类型、函数名、参数列表）
   - 对外导出的 `typedef`、`struct`、`enum` 定义
   - 已 `#include` 的头文件（用于判断依赖）
2. 检查同目录是否已有同名 `.h`：
   - **不存在** → 按模板新建
   - **已存在** → 读取现有 `.h`，仅追加缺失的函数声明，不修改已有内容
3. 写入文件

## 输出模板（新建）

```c
/*
 * 文件 : xxx.h
 * 描述 : xxx 模块头文件
 * 版本 : v1.0
 * 日期 : YYYY/MM/DD
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      YY/MM/DD   创建文件
 */
#ifndef XXX_H
#define XXX_H

#include <stdint.h>

// ---- 类型定义 ----//

// （从 .c 提取的 typedef/struct/enum）

// ---- 函数声明 ----//

/**
 * @brief  函数简要说明（来自 .c 文件的 Doxygen 注释）
 * @param  param1  参数1说明
 * @return 返回值说明
 */
int func_name(int param1);

#endif // XXX_H
```

## 注意事项

- `static` 函数不导出到头文件
- include guard 宏名：文件名全大写 + `_H`（如 `uart_rx.h` → `UART_RX_H`）
- 若 `.c` 中有 Doxygen 注释块，将其复制到声明前
- 已存在头文件时，只追加不覆盖，保留用户手写内容
