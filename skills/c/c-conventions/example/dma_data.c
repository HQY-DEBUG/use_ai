/*
 * 文件 : dma_data.c
 * 描述 : DMA 数据收发模块实现
 * 版本 : v1.2
 * 日期 : 2026-03-23
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.2   ---      26/03/23   新增 dma_retry() 超时重传逻辑
 * 1.1   ---      26/03/17   补充错误码返回
 * 1.0   ---      26/03/01   创建文件
 */

#include "dma_data.h"
#include "log.h"
#include <string.h>

// ---- 私有宏定义 ----//
#define DMA_POLL_INTERVAL_US  (10U)  // 轮询间隔（微秒）

// ---- 全局变量定义 ----//
uint32_t g_tx_count = 0;  // dma_data.h 中 extern 声明，此处为唯一定义

// ---- 私有变量 ----//
static uint32_t s_timeout_cnt = 0;  // 超时计数器（模块内私有）

// [废弃] 2026-03-17 旧版超时逻辑，已由 dma_retry() 替代，待第3版清理
// static void dma_timeout_old(dma_ctx_t *ctx) { ... }

// ---- 函数实现 ----//

/**
 * @brief  DMA 模块初始化
 * @param  ctx  DMA 上下文指针
 * @return DMA_OK 成功，DMA_ERR_PARAM 参数无效
 */
int dma_init(dma_ctx_t *ctx) {
    if (ctx == NULL) {
        prerror("dma_init: ctx 为空指针\r\n");
        return DMA_ERR_PARAM;
    }
    memset(ctx->buf, 0, DMA_BUF_SIZE);
    ctx->len     = 0;
    ctx->is_busy = 0;
    g_tx_count   = 0;
    prinfo("dma_init: 初始化完成\r\n");
    return DMA_OK;
}

/**
 * @brief  发送数据
 * @param  ctx   DMA 上下文指针
 * @param  data  待发送数据指针
 * @param  len   数据长度（字节）
 * @return DMA_OK 成功，DMA_ERR_TIMEOUT 超时
 */
int dma_send(dma_ctx_t *ctx, const uint8_t *data, uint32_t len) {
    if (ctx == NULL || data == NULL || len == 0 || len > DMA_BUF_SIZE) {
        return DMA_ERR_PARAM;
    }

    // ---- 等待上一次传输完成 ----//
    s_timeout_cnt = 0;
    while (ctx->is_busy) {
        s_timeout_cnt++;
        if (s_timeout_cnt > DMA_TIMEOUT_MS * 1000U / DMA_POLL_INTERVAL_US) {
            prwarn("dma_send: 等待超时，尝试重传\r\n");
            return dma_retry(ctx);
        }
    }

    // 2026-03-23 新增：拷贝数据并启动 DMA 传输
    memcpy(ctx->buf, data, len);
    ctx->len     = len;
    ctx->is_busy = 1;
    g_tx_count++;
    return DMA_OK;
}

/**
 * @brief  超时重传（最多重试 DMA_MAX_RETRY 次）
 * @param  ctx  DMA 上下文指针
 * @return DMA_OK 成功，DMA_ERR_TIMEOUT 重传仍超时
 */
int dma_retry(dma_ctx_t *ctx) {
    uint8_t retry = 0;
    while (retry < DMA_MAX_RETRY) {
        ctx->is_busy = 0;  // 强制复位忙标志
        if (dma_send(ctx, ctx->buf, ctx->len) == DMA_OK) {
            prinfo("dma_retry: 第 %d 次重传成功\r\n", retry + 1);
            return DMA_OK;
        }
        retry++;
    }
    prerror("dma_retry: 重传 %d 次仍失败\r\n", DMA_MAX_RETRY);
    return DMA_ERR_TIMEOUT;
}

/**
 * @brief  主循环轮询（poll 模式）
 * @param  ctx  DMA 上下文指针
 */
void dma_poll(dma_ctx_t *ctx) {
    if (ctx == NULL) {
        return;
    }
    /* 检查 DMA 传输完成中断标志（实际实现需读硬件寄存器） */
    if (ctx->is_busy) {
        ctx->is_busy = 0;
        prbrief("dma_poll: 传输完成，累计 %lu 次\r\n", (unsigned long)g_tx_count);
    }
}
