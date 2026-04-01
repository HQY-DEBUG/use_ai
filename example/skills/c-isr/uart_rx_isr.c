/*
 * 文件 : uart_rx_isr.c
 * 描述 : UART 接收中断服务程序（XScuGic 注册，中断号 56）
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#include "uart_rx_isr.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xuartps.h"
#include <string.h>

// ---- 中断配置参数 ----//
#define UART_RX_INT_ID       56U                       // UART 接收中断 ID
#define UART_RX_INT_PRI      0xA0U                     // 中断优先级（0x00最高，0xF8最低）
#define UART_RX_INT_TRIGGER  XSCUGIC_INT_CFG_EDGE_RISING  // 上升沿触发

// ---- 全局变量 ----//
static XScuGic       *g_gic_ptr   = NULL;  // GIC 实例指针（由外部传入）
static XUartPs       *g_uart_ptr  = NULL;  // UART 实例指针
static uart_rx_cb_t   g_rx_cb     = NULL;  // 接收回调函数

// ---- 私有函数声明 ----//
static void uart_rx_isr_handler(void *callback_ref);

/**
 * @brief  注册并使能 UART 接收中断
 * @param  gic_ptr   已初始化的 XScuGic 实例指针
 * @param  uart_ptr  已初始化的 XUartPs 实例指针
 * @param  cb        接收完成回调（接收到数据后被 ISR 调用）
 * @return 0 成功，-1 参数为空，-2 注册失败
 */
int uart_rx_isr_init(XScuGic *gic_ptr, XUartPs *uart_ptr, uart_rx_cb_t cb) {
    int ret;

    if (gic_ptr == NULL || uart_ptr == NULL || cb == NULL) {
        return -1;
    }

    g_gic_ptr  = gic_ptr;
    g_uart_ptr = uart_ptr;
    g_rx_cb    = cb;

    // 设置中断优先级与触发方式
    XScuGic_SetPriorityTriggerType(g_gic_ptr, UART_RX_INT_ID, UART_RX_INT_PRI, UART_RX_INT_TRIGGER);

    // 注册中断处理函数
    ret = XScuGic_Connect(g_gic_ptr, UART_RX_INT_ID, (Xil_ExceptionHandler)uart_rx_isr_handler, (void *)g_uart_ptr);
    if (ret != XST_SUCCESS) {
        return -2;
    }

    // 使能该中断
    XScuGic_Enable(g_gic_ptr, UART_RX_INT_ID);

    // 使能 CPU 全局中断（若尚未使能）
    Xil_ExceptionEnable();

    return 0;
}

/**
 * @brief  去注册 UART 接收中断（关闭中断并断开连接）
 */
void uart_rx_isr_deinit(void) {
    if (g_gic_ptr == NULL) {
        return;
    }
    XScuGic_Disable(g_gic_ptr, UART_RX_INT_ID);
    XScuGic_Disconnect(g_gic_ptr, UART_RX_INT_ID);
    g_gic_ptr  = NULL;
    g_uart_ptr = NULL;
    g_rx_cb    = NULL;
}

/**
 * @brief  UART 接收中断服务程序（由 GIC 直接调用，不得阻塞）
 * @param  callback_ref  XUartPs 实例指针（注册时传入）
 * @note   在 ISR 中仅读取硬件 FIFO，数据处理应移至任务层
 */
static void uart_rx_isr_handler(void *callback_ref) {
    XUartPs *uart  = (XUartPs *)callback_ref;
    uint8_t  rx_byte;
    uint32_t isr_status;

    // 读取中断状态寄存器
    isr_status = XUartPs_ReadReg(uart->Config.BaseAddress, XUARTPS_ISR_OFFSET);

    // 处理接收 FIFO 非空中断
    if ((isr_status & XUARTPS_IXR_RXOVR) != 0U || (isr_status & XUARTPS_IXR_RXFULL) != 0U) {
        // 逐字节读取 FIFO 直至为空
        while (XUartPs_IsReceiveData(uart->Config.BaseAddress) != 0) {
            rx_byte = (uint8_t)XUartPs_ReadReg(uart->Config.BaseAddress, XUARTPS_FIFO_OFFSET);
            if (g_rx_cb != NULL) {
                g_rx_cb(rx_byte);  // 通知上层
            }
        }
    }

    // 清除中断标志
    XUartPs_WriteReg(uart->Config.BaseAddress, XUARTPS_ISR_OFFSET, isr_status);
}
