/*
 * 文件 : dma_ctrl.h
 * 描述 : DMA 控制模块头文件（由 c-header 技能从 dma_ctrl.c 自动生成）
 * 版本 : v1.0
 * 日期 : 2026/05/26
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/05/26   创建文件
 */

#ifndef DMA_CTRL_H
#define DMA_CTRL_H

#include <stdint.h>
#include <stddef.h>

// ---- 宏定义 ----//
#define DMA_MAX_TRANSFER_LEN  4096U   // 单次最大传输字节数
#define DMA_CHANNEL_TX        0U      // 发送通道索引
#define DMA_CHANNEL_RX        1U      // 接收通道索引

// ---- 类型定义 ----//

/** DMA 传输方向 */
typedef enum {
    DMA_DIR_MEM_TO_DEV = 0,  // 内存 → 外设
    DMA_DIR_DEV_TO_MEM = 1   // 外设 → 内存
} dma_dir_t;

/** DMA 通道句柄 */
typedef struct {
    uint32_t  base_addr;    // DMA 控制器基地址
    uint8_t   channel_id;   // 通道编号（0=TX, 1=RX）
    dma_dir_t direction;    // 传输方向
    uint8_t   is_busy;      // 当前通道是否忙
} dma_channel_t;

// ---- 函数声明 ----//

/**
 * @brief  初始化 DMA 控制器
 * @param  base_addr  DMA 控制器基地址
 * @return 0 成功，-1 初始化失败
 */
int dma_ctrl_init(uint32_t base_addr);

/**
 * @brief  启动一次 DMA 传输
 * @param  ch      通道句柄指针
 * @param  src     源地址
 * @param  dst     目标地址
 * @param  len     传输字节数（最大 DMA_MAX_TRANSFER_LEN）
 * @return 0 成功，-1 参数错误，-2 通道忙
 */
int dma_transfer_start(dma_channel_t *ch, uintptr_t src, uintptr_t dst, size_t len);

/**
 * @brief  等待 DMA 传输完成（阻塞）
 * @param  ch       通道句柄指针
 * @param  timeout  超时等待毫秒数，0 表示无限等待
 * @return 0 成功，-2 超时
 */
int dma_transfer_wait(dma_channel_t *ch, uint32_t timeout);

/**
 * @brief  中止正在进行的 DMA 传输
 * @param  ch  通道句柄指针
 */
void dma_transfer_abort(dma_channel_t *ch);

/**
 * @brief  查询通道是否空闲
 * @param  ch  通道句柄指针
 * @return 1 空闲，0 忙
 */
int dma_is_idle(const dma_channel_t *ch);

#endif // DMA_CTRL_H
