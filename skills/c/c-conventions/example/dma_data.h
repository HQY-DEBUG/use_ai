/*
 * 文件 : dma_data.h
 * 描述 : DMA 数据收发模块头文件
 * 版本 : v1.2
 * 日期 : 2026-03-23
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.2   ---      26/03/23   新增超时重传接口 dma_retry()
 * 1.1   ---      26/03/17   补充错误码定义
 * 1.0   ---      26/03/01   创建文件
 */

#ifndef DMA_DATA_H
#define DMA_DATA_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// ---- 宏定义 ----//
#define DMA_BUF_SIZE     (1024U)  // DMA 缓冲区大小（字节）
#define DMA_MAX_RETRY    (3U)     // 最大重传次数
#define DMA_TIMEOUT_MS   (100U)   // 超时时间（毫秒）

// ---- 错误码 ----//
#define DMA_OK           (0)      // 操作成功
#define DMA_ERR_TIMEOUT  (-1)     // 超时错误
#define DMA_ERR_PARAM    (-2)     // 参数错误

// ---- 类型定义 ----//
typedef struct {
    uint8_t  buf[DMA_BUF_SIZE];  // 数据缓冲区
    uint32_t len;                // 有效数据长度
    uint8_t  is_busy;            // 是否正在传输
} dma_ctx_t;

// ---- 全局变量声明 ----//
extern uint32_t g_tx_count;  // 累计发送次数

// ---- 函数声明 ----//

/**
 * @brief  DMA 模块初始化
 * @param  ctx  DMA 上下文指针
 * @return DMA_OK 成功，DMA_ERR_PARAM 参数无效
 */
int dma_init(dma_ctx_t *ctx);

/**
 * @brief  发送数据
 * @param  ctx   DMA 上下文指针
 * @param  data  待发送数据指针
 * @param  len   数据长度（字节）
 * @return DMA_OK 成功，DMA_ERR_TIMEOUT 超时
 */
int dma_send(dma_ctx_t *ctx, const uint8_t *data, uint32_t len);

/**
 * @brief  超时重传（最多重试 DMA_MAX_RETRY 次）
 * @param  ctx  DMA 上下文指针
 * @return DMA_OK 成功，DMA_ERR_TIMEOUT 重传仍超时
 * @note   2026-03-23 新增：替代旧版 dma_timeout_old()
 */
int dma_retry(dma_ctx_t *ctx);

/**
 * @brief  主循环轮询（poll 模式）
 * @param  ctx  DMA 上下文指针
 */
void dma_poll(dma_ctx_t *ctx);

#ifdef __cplusplus
}
#endif

#endif /* DMA_DATA_H */
