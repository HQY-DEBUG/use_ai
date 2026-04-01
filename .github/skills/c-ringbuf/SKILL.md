---
name: c-ringbuf
description: 生成 C 语言环形缓冲区模块（适用于 DMA/UART 数据收发）。用法：/c-ringbuf <模块名> [缓冲区大小] [元素类型]
argument-hint: <模块名> [大小，默认1024] [元素类型，默认uint8_t]
allowed-tools: [Read, Write, Bash]
---

# 生成 C 环形缓冲区模块

参数：$ARGUMENTS

## 参数格式

```
/c-ringbuf <模块名> [缓冲区大小] [元素类型]
```

示例：
```
/c-ringbuf uart_rx 1024 uint8_t
/c-ringbuf dma_data 4096 uint32_t
```

## 操作步骤

1. 解析参数：
   - `模块名`：小写下划线，如 `uart_rx`
   - `缓冲区大小`：默认 `1024`，**必须为 2 的幂次**（方便取模用位与）
   - `元素类型`：默认 `uint8_t`
2. 生成两个文件：`<模块名>_ringbuf.h` 和 `<模块名>_ringbuf.c`
3. 若大小不是 2 的幂次，自动向上取整并提示用户

## 头文件模板（_ringbuf.h）

```c
/*
 * 文件 : MODULE_ringbuf.h
 * 描述 : MODULE 环形缓冲区
 * 版本 : v1.0
 * 日期 : TODAY
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      TODAY_SHORT   创建文件
 */

#ifndef MODULE_RINGBUF_H
#define MODULE_RINGBUF_H

#include <stdint.h>
#include <string.h>

// ---- 宏定义 ----//

#define MODULE_RINGBUF_SIZE   (SIZE)   // 缓冲区容量（必须为 2 的幂次）
#define MODULE_RINGBUF_MASK   (MODULE_RINGBUF_SIZE - 1)

// ---- 类型定义 ----//

/**
 * @brief  MODULE 环形缓冲区结构体
 */
typedef struct {
    ELEM_TYPE  buf[MODULE_RINGBUF_SIZE];  // 数据缓冲区
    uint32_t   head;                      // 写指针（入队）
    uint32_t   tail;                      // 读指针（出队）
} ModuleRingbuf;

// ---- 函数声明 ----//

/**
 * @brief  初始化环形缓冲区
 * @param  rb  缓冲区指针
 */
void module_ringbuf_init(ModuleRingbuf *rb);

/**
 * @brief  写入一个元素
 * @param  rb   缓冲区指针
 * @param  val  待写入值
 * @return 0 成功，-1 缓冲区已满
 */
int module_ringbuf_push(ModuleRingbuf *rb, ELEM_TYPE val);

/**
 * @brief  批量写入
 * @param  rb   缓冲区指针
 * @param  src  源数据指针
 * @param  len  写入数量
 * @return 实际写入数量
 */
uint32_t module_ringbuf_push_buf(ModuleRingbuf *rb, const ELEM_TYPE *src, uint32_t len);

/**
 * @brief  读出一个元素
 * @param  rb   缓冲区指针
 * @param  out  输出值指针
 * @return 0 成功，-1 缓冲区为空
 */
int module_ringbuf_pop(ModuleRingbuf *rb, ELEM_TYPE *out);

/**
 * @brief  批量读出
 * @param  rb   缓冲区指针
 * @param  dst  目标缓冲区指针
 * @param  len  期望读取数量
 * @return 实际读取数量
 */
uint32_t module_ringbuf_pop_buf(ModuleRingbuf *rb, ELEM_TYPE *dst, uint32_t len);

/**
 * @brief  查询当前存储元素数量
 * @param  rb  缓冲区指针
 * @return 可读元素数量
 */
uint32_t module_ringbuf_size(const ModuleRingbuf *rb);

/**
 * @brief  查询剩余可写空间
 * @param  rb  缓冲区指针
 * @return 可写元素数量
 */
uint32_t module_ringbuf_free(const ModuleRingbuf *rb);

/**
 * @brief  清空缓冲区
 * @param  rb  缓冲区指针
 */
void module_ringbuf_clear(ModuleRingbuf *rb);

#endif /* MODULE_RINGBUF_H */
```

## 源文件模板（_ringbuf.c）

```c
/*
 * 文件 : MODULE_ringbuf.c
 * 描述 : MODULE 环形缓冲区实现
 * 版本 : v1.0
 * 日期 : TODAY
 */
#include "MODULE_ringbuf.h"

void module_ringbuf_init(ModuleRingbuf *rb) {
    memset(rb, 0, sizeof(ModuleRingbuf));
}

int module_ringbuf_push(ModuleRingbuf *rb, ELEM_TYPE val) {
    if (module_ringbuf_free(rb) == 0) {
        return -1;  // 满
    }
    rb->buf[rb->head & MODULE_RINGBUF_MASK] = val;
    rb->head++;
    return 0;
}

uint32_t module_ringbuf_push_buf(ModuleRingbuf *rb, const ELEM_TYPE *src, uint32_t len) {
    uint32_t i;
    uint32_t cnt = 0;
    for (i = 0; i < len; i++) {
        if (module_ringbuf_push(rb, src[i]) != 0) {
            break;
        }
        cnt++;
    }
    return cnt;
}

int module_ringbuf_pop(ModuleRingbuf *rb, ELEM_TYPE *out) {
    if (module_ringbuf_size(rb) == 0) {
        return -1;  // 空
    }
    *out = rb->buf[rb->tail & MODULE_RINGBUF_MASK];
    rb->tail++;
    return 0;
}

uint32_t module_ringbuf_pop_buf(ModuleRingbuf *rb, ELEM_TYPE *dst, uint32_t len) {
    uint32_t i;
    uint32_t cnt = 0;
    for (i = 0; i < len; i++) {
        if (module_ringbuf_pop(rb, &dst[i]) != 0) {
            break;
        }
        cnt++;
    }
    return cnt;
}

uint32_t module_ringbuf_size(const ModuleRingbuf *rb) {
    return rb->head - rb->tail;
}

uint32_t module_ringbuf_free(const ModuleRingbuf *rb) {
    return MODULE_RINGBUF_SIZE - module_ringbuf_size(rb);
}

void module_ringbuf_clear(ModuleRingbuf *rb) {
    rb->head = 0;
    rb->tail = 0;
}
```

## 设计说明

- `head`/`tail` 使用**无符号自增**（永不清零），取索引时用 `& MASK`，天然处理绕回
- `size = head - tail`，无符号整数自然溢出保证正确性
- 缓冲区大小必须为 2 的幂次，否则位与取模不正确
- **非线程安全**：若 ISR 与主循环共用，需在读写前禁用/恢复中断（生成后提示用户）

## 注意事项

- ISR 场景提醒：`push` 在 ISR 中调用时，主循环 `pop` 前需关闭对应中断或使用临界区
- 缓冲区大小建议：UART 1024B，DMA 4096B 以上
- 生成后提示用户确认大小是否为 2 的幂次

## 参考示例

完整示例见 [example/uart_rx_ringbuf.c](example/uart_rx_ringbuf.c)
