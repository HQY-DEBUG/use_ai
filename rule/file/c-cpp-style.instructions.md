---

description: "C/C++ 代码风格规范：4空格缩进、K&R括号、函数调用同行、行内注释禁用块注释、Doxygen函数头、注释纵向对齐。当编写或修改 .c/.h/.cpp/.hpp 文件时使用。"
applyTo: "**/*.c,**/*.h,**/*.cpp,**/*.hpp"
---

# C/C++ 代码风格规范

## 缩进与括号

- 使用 **4个空格** 缩进，禁止使用 Tab
- 大括号采用 **K&R 风格**：左括号不换行

```c
// ✅ 正确
void foo() {
    if (x) {
        do_something();
    }
}

// ❌ 错误（左括号换行）
void foo()
{
    if (x)
    {
        do_something();
    }
}
```

## 函数调用格式

函数调用**必须写在同一行**，禁止将参数拆分到多行：

```c
// ✅ 正确
Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, gic_ins_ptr);

// ❌ 错误
Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
                              (Xil_ExceptionHandler)XScuGic_InterruptHandler,
                              gic_ins_ptr);
```

## 注释规范

- 函数头使用 Doxygen 风格（中文）：

```c
/**
 * @brief  函数简要说明
 * @param  param1  参数1说明
 * @param  param2  参数2说明
 * @return 返回值说明
 * @note   注意事项（可选）
 */
```

- 行内注释（行尾跟随代码）**必须**使用 `//`，**禁止**使用 `/* */`
- 多行独立注释块使用 `/* */`
- 注释内容使用**中文**

```c
// ✅ 正确（行尾注释）
XTime _log_start_time = 0;  // log.h 中 extern 声明，此处为唯一定义

// ❌ 错误（行尾注释用了块注释）
XTime _log_start_time = 0;  /* log.h 中 extern 声明，此处为唯一定义 */
```

- 区块标题使用 `// ---- 内容 ----//`，**禁止**使用 `/* ---- 内容 ---- */`

```c
// ✅ 正确
// ---- 硬件资源 ----//
#define PL_RST_GPIO_DEV_ID  XPAR_AXI_GPIO_0_DEVICE_ID

// ❌ 错误
/* ---- 硬件资源 ---- */
#define PL_RST_GPIO_DEV_ID  XPAR_AXI_GPIO_0_DEVICE_ID
```

## 注释对齐规范

同一连续代码块（结构体字段、成组宏、初始化表项）的行尾注释**纵向对齐**：

```c
// ✅ 正确（对齐）
#define PL_RST_GPIO_DEV_ID   XPAR_AXI_GPIO_0_DEVICE_ID  // GPIO 设备 ID
#define PL_RST_GPIO_CHANNEL  1                            // 通道号
#define PL_INTER_NUM         0x02                         // 中断持续时钟周期

// ❌ 错误（未对齐）
#define PL_RST_GPIO_DEV_ID XPAR_AXI_GPIO_0_DEVICE_ID // GPIO 设备 ID
#define PL_RST_GPIO_CHANNEL 1 // 通道号
#define PL_INTER_NUM 0x02 // 中断持续时钟周期
```

## 文件头模板

每个 `.c` / `.h` 文件顶部必须包含：

```c
/*
 * 文件 : xxx.c
 * 描述 : 模块简要说明
 * 版本 : v1.0
 * 日期 : YYYY/MM/DD
 *
 * 修改记录（最新版本在最前）:
 *  ver  who      date       modification
 * ----- -------  ---------- ---------------------------------
 * 1.0   ---      YY/MM/DD   创建文件
 */
```

- 修改记录仅保留最近 **3** 个版本，最新在最前

## 命名规范

- 变量/函数：小写下划线，如 `recv_buf`、`init_module()`
- 宏定义：全大写下划线，如 `MAX_BUF_SIZE`
- 全局变量加 `g_` 前缀，如 `g_tx_count`
- 类名/结构体：大驼峰，如 `UdpWorker`
