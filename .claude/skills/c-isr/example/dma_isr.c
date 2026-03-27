/*
 * 文件 : dma_isr.c
 * 描述 : DMA 传输完成中断示例（由 /c-isr 生成）
 * 版本 : v1.0
 * 日期 : 2026/03/27
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/03/27   创建文件
 */

#include "dma_isr.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "log.h"

// ---- DMA 完成中断 ----//

/**
 * @brief  DMA 传输完成中断服务程序
 * @param  callback_ref  回调参数（此处未使用）
 * @note   ISR 中禁止调用阻塞函数；仅设置标志位
 */
static void isr_dma_done(void *callback_ref) {
    (void)callback_ref;

    // 清除 DMA 中断状态寄存器（示例）
    // XAxiDma_IntrAckIrq(&g_dma_ins, XAXIDMA_IRQ_IOC_MASK, XAXIDMA_DEVICE_TO_DMA);

    // 设置完成标志（主循环轮询此标志）
    g_dma_done_flag = 1;
}

/**
 * @brief  注册 DMA 完成中断
 * @param  gic_ins_ptr  GIC 实例指针
 * @return 0 成功，-1 失败
 */
int isr_dma_done_register(XScuGic *gic_ins_ptr) {
    int ret;

    // 设置优先级 0xA0，上升沿触发
    XScuGic_SetPriorityTriggerType(gic_ins_ptr, INT_ID_DMA_DONE, 0xA0, 0x03);

    ret = XScuGic_Connect(gic_ins_ptr, INT_ID_DMA_DONE, (Xil_InterruptHandler)isr_dma_done, NULL);
    if (ret != XST_SUCCESS) {
        prlog_error("DMA 中断连接失败，ret=%d", ret);
        return -1;
    }

    XScuGic_Enable(gic_ins_ptr, INT_ID_DMA_DONE);
    return 0;
}
