---
name: c-conventions
description: 本项目 C/C++ 编码规范背景知识。凡涉及编写、修改或审查 .c / .h / .cpp / .hpp 文件时自动应用。
user-invocable: false
---

# C/C++ 编码规范（背景知识）

编写或修改任何 C/C++ 文件时，严格遵守以下规则。

## 缩进与括号

- 使用 **4个空格** 缩进，**禁止** Tab
- 大括号采用 **K&R 风格**：左括号不换行，右括号单独占一行

```c
void foo() {
    if (x) {
        do_something();
    }
}
```

## 函数调用格式

- 函数调用**必须写在同一行**，禁止将参数拆分到多行

```c
// ✅ 正确
Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, gic_ins_ptr);

// ❌ 错误
Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
                              (Xil_ExceptionHandler)XScuGic_InterruptHandler,
                              gic_ins_ptr);
```

## 注释规范

- 注释内容使用**中文**
- 行内注释（行尾跟随代码）**必须**使用 `//`，禁止使用 `/* */`
- 多行注释也使用 `//`，禁止使用 `/* */`（文件头除外）
- 区块标题统一使用 `// ---- 内容 ----//`，禁止使用 `/* ---- 内容 ---- */`
- 同一连续代码块中的行尾注释需要**纵向对齐**；典型场景：结构体字段、成组宏定义、初始化表项。若对齐会明显影响可读性或导致频繁大范围改动，则只在本次修改触及的局部代码块内对齐

```c
// ✅ 正确
// ---- 硬件资源 ----//
#define PL_RST_GPIO_DEV_ID   XPAR_AXI_GPIO_0_DEVICE_ID
#define PL_INTER_NUM         0x02  // 中断电平持续时钟周期

// ❌ 错误
/* ---- 硬件资源 ---- */
#define PL_INTER_NUM         0x02  /* 中断电平持续时钟周期 */
```

- 新增代码在行尾或上方标注日期：`// YYYY-MM-DD 新增：说明`
- 废弃代码添加注释说明原因，保留 **3个版本** 后清理：

```c
// [废弃] 2026-03-17 旧版超时逻辑，已由 dma_retry() 替代，待第3版清理
// void dma_timeout_old() { ... }
```

## 函数头注释（Doxygen 风格）

```c
/**
 * @brief  函数简要说明
 * @param  param1  参数1说明
 * @param  param2  参数2说明
 * @return 返回值说明
 * @note   注意事项（可选）
 */
```

## 命名规范

| 类型      | 风格               | 示例                      |
|---------|------------------|-------------------------|
| 变量、函数   | 小写下划线            | `recv_buf`、`init_dma()` |
| 宏定义     | 全大写下划线           | `MAX_BUF_SIZE`          |
| 全局变量    | `g_` 前缀 + 小写下划线  | `g_tx_count`            |
| 类名、结构体  | 大驼峰或小写下划线        | `UdpWorker`             |
| 成员变量    | 小写下划线，可选 `m_` 前缀 | `m_socket`、`buf_len`   |

- 布尔变量用 `is_`、`has_`、`can_` 前缀，如 `is_valid`、`has_data`
- 避免单字母命名（循环变量 `i`、`j`、`k` 除外）

## 修改与废弃

- 修改已有函数或接口时，须说明此改动对其他模块的**影响范围**
- 不随意删除现有代码；废弃代码添加注释说明原因，保留 **3个版本** 后清理

## 文件头模板

每个 `.c` / `.h` 文件顶部必须包含：

```c
/*
 * 文件 : xxx.c
 * 描述 : 模块简要说明
 * 版本 : v1.0
 * 日期 : YYYY-MM-DD
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   xxx      YY/MM/DD   创建文件
 */
```

修改记录仅保留最近 **3** 个版本，最新在最前。
