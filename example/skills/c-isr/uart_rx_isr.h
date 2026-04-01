/*
 * 文件 : uart_rx_isr.h
 * 描述 : UART 接收中断服务程序头文件
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#ifndef UART_RX_ISR_H
#define UART_RX_ISR_H

#include <stdint.h>
#include "xscugic.h"
#include "xuartps.h"

// 接收回调函数类型：每收到一个字节调用一次
typedef void (*uart_rx_cb_t)(uint8_t byte);

int  uart_rx_isr_init(XScuGic *gic_ptr, XUartPs *uart_ptr, uart_rx_cb_t cb);
void uart_rx_isr_deinit(void);

#endif // UART_RX_ISR_H
