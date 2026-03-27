/*
 * 文件 : uart_rx_ringbuf.c
 * 描述 : UART 接收环形缓冲区示例（由 /c-ringbuf 生成）
 * 版本 : v1.0
 * 日期 : 2026/03/27
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/03/27   创建文件
 */

#include "uart_rx_ringbuf.h"
#include <string.h>

// ---- 私有变量 ----//

static UartRxRingbuf g_uart_rx_rb;  // UART 接收缓冲区（全局单例）

// ---- 公共函数 ----//

void uart_rx_ringbuf_init(UartRxRingbuf *rb) {
    memset(rb, 0, sizeof(UartRxRingbuf));
}

int uart_rx_ringbuf_push(UartRxRingbuf *rb, uint8_t val) {
    if (uart_rx_ringbuf_free(rb) == 0) {
        return -1;  // 满，丢弃
    }
    rb->buf[rb->head & UART_RX_RINGBUF_MASK] = val;
    rb->head++;
    return 0;
}

uint32_t uart_rx_ringbuf_push_buf(UartRxRingbuf *rb, const uint8_t *src, uint32_t len) {
    uint32_t i;
    uint32_t cnt = 0;
    for (i = 0; i < len; i++) {
        if (uart_rx_ringbuf_push(rb, src[i]) != 0) {
            break;
        }
        cnt++;
    }
    return cnt;
}

int uart_rx_ringbuf_pop(UartRxRingbuf *rb, uint8_t *out) {
    if (uart_rx_ringbuf_size(rb) == 0) {
        return -1;  // 空
    }
    *out = rb->buf[rb->tail & UART_RX_RINGBUF_MASK];
    rb->tail++;
    return 0;
}

uint32_t uart_rx_ringbuf_pop_buf(UartRxRingbuf *rb, uint8_t *dst, uint32_t len) {
    uint32_t i;
    uint32_t cnt = 0;
    for (i = 0; i < len; i++) {
        if (uart_rx_ringbuf_pop(rb, &dst[i]) != 0) {
            break;
        }
        cnt++;
    }
    return cnt;
}

uint32_t uart_rx_ringbuf_size(const UartRxRingbuf *rb) {
    return rb->head - rb->tail;
}

uint32_t uart_rx_ringbuf_free(const UartRxRingbuf *rb) {
    return UART_RX_RINGBUF_SIZE - uart_rx_ringbuf_size(rb);
}

void uart_rx_ringbuf_clear(UartRxRingbuf *rb) {
    rb->head = 0;
    rb->tail = 0;
}

// ---- 使用示例（ISR 写入 + 主循环读取）----//

/*
 * UART 接收中断 ISR（在中断上下文调用 push）:
 *
 *   void uart_rx_isr(void *callback_ref) {
 *       uint8_t byte = XUartPs_RecvByte(UART_BASE_ADDR);
 *       uart_rx_ringbuf_push(&g_uart_rx_rb, byte);
 *   }
 *
 * 主循环轮询（pop 取出数据处理）:
 *
 *   void uart_rx_poll(void) {
 *       uint8_t byte;
 *       while (uart_rx_ringbuf_pop(&g_uart_rx_rb, &byte) == 0) {
 *           process_byte(byte);
 *       }
 *   }
 *
 * 注意：若 ISR 与主循环并发访问，需在 push 前禁止中断，pop 后恢复。
 */
