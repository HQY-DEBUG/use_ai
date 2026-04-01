/*
 * 文件 : uart_tx.h
 * 描述 : UART 发送模块头文件
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#ifndef UART_TX_H
#define UART_TX_H

#include <stdint.h>
#include <stddef.h>

// ---- 宏定义 ----//
#define UART_TX_BUF_SIZE   512U   // 发送缓冲区大小（字节）
#define UART_TX_TIMEOUT_MS 100U   // 发送超时时间（毫秒）

// ---- 类型定义 ----//

/** UART 配置结构体 */
typedef struct {
    uint32_t baud_rate;   // 波特率，如 115200
    uint8_t  data_bits;   // 数据位数（7 或 8）
    uint8_t  stop_bits;   // 停止位数（1 或 2）
    uint8_t  parity;      // 校验方式：0=无, 1=奇, 2=偶
} uart_tx_config_t;

// ---- 函数声明 ----//

/**
 * @brief  初始化 UART 发送模块
 * @param  cfg  配置参数指针
 * @return 0 成功，-1 参数错误，-2 硬件初始化失败
 */
int uart_tx_init(const uart_tx_config_t *cfg);

/**
 * @brief  发送一个字节
 * @param  byte  待发送字节
 * @return 0 成功，-2 超时
 */
int uart_tx_send_byte(uint8_t byte);

/**
 * @brief  发送数据缓冲区
 * @param  buf  数据指针
 * @param  len  字节数
 * @return 实际发送字节数，负数表示错误
 */
int uart_tx_send_buf(const uint8_t *buf, size_t len);

/**
 * @brief  反初始化 UART 发送模块，释放资源
 */
void uart_tx_deinit(void);

#endif // UART_TX_H
