/*
 * 文件 : dma_data.h
 * 描述 : DMA 数据收发模块头文件
 * 版本 : v1.0
 * 日期 : 2026-03-23
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/03/23   创建文件
 */

#ifndef DMA_DATA_H
#define DMA_DATA_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// ---- 宏定义 ----//

// ---- 类型定义 ----//

// ---- 函数声明 ----//

/**
 * @brief  模块初始化
 * @return 0 成功，-1 失败
 */
int dma_data_init(void);

/**
 * @brief  模块轮询处理（主循环调用）
 */
void dma_data_poll(void);

#ifdef __cplusplus
}
#endif

#endif /* DMA_DATA_H */
