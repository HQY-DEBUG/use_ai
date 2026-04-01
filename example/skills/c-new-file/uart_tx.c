/*
 * 文件 : uart_tx.c
 * 描述 : UART 发送模块实现（轮询模式，适用于 Vitis 裸机环境）
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#include "uart_tx.h"
#include "xuartps.h"
#include "xparameters.h"
#include <string.h>

// ---- 内部变量 ----//
static XUartPs        g_uart_inst;       // UART 驱动实例
static uint8_t        g_tx_buf[UART_TX_BUF_SIZE];  // 发送缓冲区
static uint8_t        g_is_init = 0;    // 初始化标志

/**
 * @brief  初始化 UART 发送模块
 * @param  cfg  配置参数指针
 * @return 0 成功，-1 参数错误，-2 硬件初始化失败
 */
int uart_tx_init(const uart_tx_config_t *cfg) {
    XUartPs_Config *uart_cfg;
    int ret;

    if (cfg == NULL) {
        return -1;
    }

    uart_cfg = XUartPs_LookupConfig(XPAR_XUARTPS_0_DEVICE_ID);
    if (uart_cfg == NULL) {
        return -2;
    }

    ret = XUartPs_CfgInitialize(&g_uart_inst, uart_cfg, uart_cfg->BaseAddress);
    if (ret != XST_SUCCESS) {
        return -2;
    }

    // 配置波特率
    ret = XUartPs_SetBaudRate(&g_uart_inst, cfg->baud_rate);
    if (ret != XST_SUCCESS) {
        return -2;
    }

    // 设置数据格式
    XUartPs_SetDataFormat(&g_uart_inst, &(XUartPsFormat){
        .BaudRate = cfg->baud_rate,
        .DataBits = cfg->data_bits,
        .StopBits = cfg->stop_bits,
        .Parity   = cfg->parity
    });

    g_is_init = 1;
    return 0;
}

/**
 * @brief  发送一个字节（轮询等待 FIFO 非满）
 * @param  byte  待发送字节
 * @return 0 成功，-2 超时
 */
int uart_tx_send_byte(uint8_t byte) {
    uint32_t timeout = UART_TX_TIMEOUT_MS * 1000U;  // 粗略循环计数

    if (g_is_init == 0) {
        return -1;
    }

    while (!XUartPs_IsTransmitEmpty(&g_uart_inst)) {
        if (timeout-- == 0U) {
            return -2;  // 超时
        }
    }

    XUartPs_SendByte(g_uart_inst.Config.BaseAddress, byte);
    return 0;
}

/**
 * @brief  发送数据缓冲区
 * @param  buf  数据指针
 * @param  len  字节数
 * @return 实际发送字节数，负数表示错误
 */
int uart_tx_send_buf(const uint8_t *buf, size_t len) {
    int sent = 0;
    int ret;

    if (buf == NULL || len == 0U) {
        return -1;
    }

    for (size_t i = 0; i < len; i++) {
        ret = uart_tx_send_byte(buf[i]);
        if (ret != 0) {
            break;
        }
        sent++;
    }

    return sent;
}

/**
 * @brief  反初始化 UART 发送模块
 */
void uart_tx_deinit(void) {
    memset(&g_uart_inst, 0, sizeof(g_uart_inst));
    memset(g_tx_buf, 0, sizeof(g_tx_buf));
    g_is_init = 0;
}
