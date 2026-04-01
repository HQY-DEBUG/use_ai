/*
 * 文件 : uart_config.h
 * 描述 : UART 配置结构体定义（由 c-struct 技能生成）
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#ifndef UART_CONFIG_H
#define UART_CONFIG_H

#include <stdint.h>

// ---- 枚举：校验方式 ----//
typedef enum {
    UART_PARITY_NONE = 0,  // 无校验
    UART_PARITY_ODD  = 1,  // 奇校验
    UART_PARITY_EVEN = 2   // 偶校验
} uart_parity_t;

// ---- 枚举：停止位 ----//
typedef enum {
    UART_STOP_1BIT = 0,  // 1 位停止位
    UART_STOP_2BIT = 1   // 2 位停止位
} uart_stop_t;

/**
 * @brief  UART 通信配置参数
 *
 * @note   使用前须调用 uart_config_default() 填入默认值，
 *         再按需修改个别字段，最后传入 uart_tx_init()。
 */
typedef struct {
    uint32_t      baud_rate ;  // 波特率，如 9600 / 115200 / 921600
    uint8_t       data_bits ;  // 数据位数：7 或 8
    uart_stop_t   stop_bits ;  // 停止位
    uart_parity_t parity    ;  // 校验方式
    uint8_t       flow_ctrl ;  // 硬件流控：0=关闭, 1=RTS/CTS
    uint8_t       reserved  ;  // 对齐填充（保留）
} uart_config_t;

// ---- 函数声明 ----//

/**
 * @brief  填充默认配置（115200-8N1，无流控）
 * @param  cfg  配置指针
 */
static inline void uart_config_default(uart_config_t *cfg) {
    cfg->baud_rate  = 115200U;
    cfg->data_bits  = 8U;
    cfg->stop_bits  = UART_STOP_1BIT;
    cfg->parity     = UART_PARITY_NONE;
    cfg->flow_ctrl  = 0U;
    cfg->reserved   = 0U;
}

#endif // UART_CONFIG_H
