/*
 * 文件 : uart_rx_buf.h
 * 描述 : UART 接收环形缓冲区头文件
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#ifndef UART_RX_BUF_H
#define UART_RX_BUF_H

#include <stdint.h>
#include <stddef.h>

// ---- 配置 ----//
#define UART_RX_BUF_SIZE  256U  // 必须为 2 的幂（用位与代替取模）
#define UART_RX_BUF_MASK  (UART_RX_BUF_SIZE - 1U)

// 编译期检查：缓冲区大小必须为 2 的幂
_Static_assert((UART_RX_BUF_SIZE & UART_RX_BUF_MASK) == 0U, "UART_RX_BUF_SIZE 必须为 2 的幂");

// ---- 环形缓冲区结构体 ----//
typedef struct {
    uint8_t  buf[UART_RX_BUF_SIZE];  // 数据存储区
    uint32_t head;                    // 写指针（生产者使用）
    uint32_t tail;                    // 读指针（消费者使用）
} uart_rx_buf_t;

// ---- 接口声明 ----//

/**
 * @brief  初始化环形缓冲区
 * @param  rb  环形缓冲区指针
 */
void uart_rx_buf_init(uart_rx_buf_t *rb);

/**
 * @brief  向缓冲区写入一个字节（通常在 ISR 中调用）
 * @param  rb    环形缓冲区指针
 * @param  byte  待写入字节
 * @return 0 成功，-1 缓冲区已满（丢弃）
 */
int uart_rx_buf_push(uart_rx_buf_t *rb, uint8_t byte);

/**
 * @brief  从缓冲区读取一个字节
 * @param  rb    环形缓冲区指针
 * @param  byte  输出字节指针
 * @return 0 成功，-1 缓冲区为空
 */
int uart_rx_buf_pop(uart_rx_buf_t *rb, uint8_t *byte);

/**
 * @brief  批量读取字节
 * @param  rb   环形缓冲区指针
 * @param  dst  目标缓冲区
 * @param  len  最多读取字节数
 * @return 实际读取字节数
 */
size_t uart_rx_buf_read(uart_rx_buf_t *rb, uint8_t *dst, size_t len);

/**
 * @brief  查询当前可读字节数
 * @param  rb  环形缓冲区指针
 * @return 可读字节数
 */
size_t uart_rx_buf_size(const uart_rx_buf_t *rb);

/**
 * @brief  查询缓冲区是否为空
 * @param  rb  环形缓冲区指针
 * @return 1 为空，0 非空
 */
int uart_rx_buf_is_empty(const uart_rx_buf_t *rb);

/**
 * @brief  查询缓冲区是否已满
 * @param  rb  环形缓冲区指针
 * @return 1 已满，0 未满
 */
int uart_rx_buf_is_full(const uart_rx_buf_t *rb);

/**
 * @brief  清空环形缓冲区
 * @param  rb  环形缓冲区指针
 */
void uart_rx_buf_flush(uart_rx_buf_t *rb);

#endif // UART_RX_BUF_H
