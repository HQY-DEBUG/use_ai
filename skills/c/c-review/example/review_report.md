# C/C++ 规范审查示例报告

> 此文件展示 `/c-review` 技能的输出格式，
> 以一段存在多处违规的代码为例。

---

## 被审查代码（违规示例）

```c
#include <stdio.h>

/* ---- 硬件资源 ---- */        // ❌ 区块标题应用 // ---- 内容 ----//
#define buf_size 256            // ❌ 宏应全大写：BUF_SIZE
#define maxRetry 3              // ❌ 宏应全大写下划线：MAX_RETRY

int TxCount = 0;                // ❌ 全局变量应加 g_ 前缀：g_tx_count

void SendData(uint8_t *data, int len,  // ❌ 函数名应小写下划线：send_data
              int retry) {             // ❌ 参数不能换行
    if(len > buf_size) {              // ❌ if 后应有空格
        printf("error\n");            // ❌ 注释应为中文
        return;
    }
    TxCount++;                        // ❌ 全局变量命名不规范
}
```

---

## 审查报告

```
== C/C++ 规范审查报告：bad_example.c ==

✅ 通过项：2 项
❌ 违规项：7 项

违规详情：
  [行  3] 注释规范：区块标题使用 /* ---- 内容 ---- */，应改为 // ---- 内容 ----//
  [行  4] 命名规范：宏 buf_size 未使用全大写下划线，应为 BUF_SIZE
  [行  5] 命名规范：宏 maxRetry 未使用全大写下划线，应为 MAX_RETRY
  [行  7] 命名规范：全局变量 TxCount 缺少 g_ 前缀，应为 g_tx_count
  [行  9] 函数调用：函数定义参数跨行拆分，应写在同一行
  [行  9] 命名规范：函数名 SendData 应使用小写下划线：send_data
  [行 11] 注释规范：注释内容应使用中文

建议：统一宏命名为全大写下划线；全局变量加 g_ 前缀；
      函数名改为小写下划线；注释改为中文；
      区块标题改用 // ---- 内容 ----// 格式。
```

---

## 修正后代码

```c
/*
 * 文件 : example.c
 * 描述 : 示例模块（修正版）
 * 版本 : v1.0
 * 日期 : 2026-03-23
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      26/03/23   创建文件
 */

#include <stdio.h>
#include <stdint.h>

// ---- 宏定义 ----//
#define BUF_SIZE    256  // 缓冲区大小（字节）
#define MAX_RETRY   3    // 最大重试次数

// ---- 全局变量 ----//
uint32_t g_tx_count = 0;  // 累计发送次数

// ---- 函数实现 ----//

/**
 * @brief  发送数据
 * @param  data   数据指针
 * @param  len    数据长度
 * @param  retry  重试次数
 */
void send_data(uint8_t *data, int len, int retry) {
    if (len > BUF_SIZE) {
        printf("错误：数据长度超出缓冲区\n");  // 注释使用中文
        return;
    }
    g_tx_count++;
}
```
