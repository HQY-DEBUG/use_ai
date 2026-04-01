/*
 * 文件 : uart_rx_buf.c
 * 描述 : UART 接收环形缓冲区实现（无锁单生产者单消费者）
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#include "uart_rx_buf.h"
#include <string.h>

/**
 * @brief  初始化环形缓冲区
 */
void uart_rx_buf_init(uart_rx_buf_t *rb) {
    memset(rb->buf, 0, sizeof(rb->buf));
    rb->head = 0U;
    rb->tail = 0U;
}

/**
 * @brief  写入一个字节（ISR 中调用）
 */
int uart_rx_buf_push(uart_rx_buf_t *rb, uint8_t byte) {
    if (uart_rx_buf_is_full(rb)) {
        return -1;  // 缓冲区满，丢弃字节
    }
    rb->buf[rb->head & UART_RX_BUF_MASK] = byte;
    rb->head++;  // head 超过 UINT32_MAX 后自然溢出，位与仍正确
    return 0;
}

/**
 * @brief  读取一个字节
 */
int uart_rx_buf_pop(uart_rx_buf_t *rb, uint8_t *byte) {
    if (uart_rx_buf_is_empty(rb)) {
        return -1;
    }
    *byte = rb->buf[rb->tail & UART_RX_BUF_MASK];
    rb->tail++;
    return 0;
}

/**
 * @brief  批量读取字节
 */
size_t uart_rx_buf_read(uart_rx_buf_t *rb, uint8_t *dst, size_t len) {
    size_t cnt = 0U;

    while (cnt < len && !uart_rx_buf_is_empty(rb)) {
        dst[cnt] = rb->buf[rb->tail & UART_RX_BUF_MASK];
        rb->tail++;
        cnt++;
    }
    return cnt;
}

/**
 * @brief  查询可读字节数
 */
size_t uart_rx_buf_size(const uart_rx_buf_t *rb) {
    return (size_t)(rb->head - rb->tail);
}

/**
 * @brief  查询是否为空
 */
int uart_rx_buf_is_empty(const uart_rx_buf_t *rb) {
    return (rb->head == rb->tail) ? 1 : 0;
}

/**
 * @brief  查询是否已满
 */
int uart_rx_buf_is_full(const uart_rx_buf_t *rb) {
    return (uart_rx_buf_size(rb) >= UART_RX_BUF_SIZE) ? 1 : 0;
}

/**
 * @brief  清空缓冲区
 */
void uart_rx_buf_flush(uart_rx_buf_t *rb) {
    rb->head = 0U;
    rb->tail = 0U;
}
