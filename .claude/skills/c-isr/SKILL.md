---
name: c-isr
description: 生成 Vitis/裸机中断服务程序框架（XScuGic 注册 + ISR 函数骨架）。用法：/c-isr <中断名> <中断号> [触发方式]
argument-hint: <中断名> <中断号（十六进制）> [触发方式：rising|falling|high|low，默认rising]
allowed-tools: [Read, Write, Bash]
---

# 生成 Vitis 中断服务程序框架

参数：$ARGUMENTS

## 参数格式

```
/c-isr <中断名> <中断号> [触发方式]
```

示例：
```
/c-isr dma_done 0x8F rising
/c-isr spi_rx   0x91 high
/c-isr timer0   0x1D rising
```

## 触发方式说明

| 参数       | GIC 配置值 | 含义         |
|----------|-----------|------------|
| `rising` | `0x03`    | 上升沿触发（默认） |
| `falling`| `0x01`    | 下降沿触发    |
| `high`   | `0x01`    | 高电平触发    |
| `low`    | `0x01`    | 低电平触发    |

## 操作步骤

1. 解析参数：中断名（小写下划线）、中断号（0x 十六进制）、触发方式
2. 生成以下代码片段（**追加**到用户指定的 `.c` 文件，或单独输出代码块）：
   - ISR 函数定义
   - 注册函数（`isr_NAME_register`）
3. 生成对应的 `.h` 声明片段

## 生成代码模板

### ISR 函数（追加到 .c）

```c
// ---- NAME 中断 ----//

/**
 * @brief  NAME 中断服务程序
 * @param  callback_ref  回调参数（通常为外设实例指针，可强转使用）
 * @note   ISR 中禁止调用阻塞函数；仅设置标志位或写环形缓冲区
 */
static void isr_NAME(void *callback_ref) {
    // v1.0 2026/03/27 新增：NAME 中断处理
    (void)callback_ref;

    // TODO: 清除中断源（若需要，视外设而定）

    // TODO: 设置标志位或写数据到缓冲区
    // g_NAME_irq_flag = 1;
}

/**
 * @brief  注册 NAME 中断
 * @param  gic_ins_ptr  GIC 实例指针（由调用方传入）
 * @return 0 成功，-1 失败
 */
int isr_NAME_register(XScuGic *gic_ins_ptr) {
    int ret;

    // 设置中断优先级与触发方式
    XScuGic_SetPriorityTriggerType(gic_ins_ptr, INT_ID_NAME, 0xA0, TRIGGER_TYPE);

    // 注册中断处理函数
    ret = XScuGic_Connect(gic_ins_ptr, INT_ID_NAME, (Xil_InterruptHandler)isr_NAME, NULL);
    if (ret != XST_SUCCESS) {
        return -1;
    }

    // 使能中断
    XScuGic_Enable(gic_ins_ptr, INT_ID_NAME);
    return 0;
}
```

### 头文件声明片段（追加到 .h 或直接输出）

```c
// ---- 中断宏定义 ----//

#define INT_ID_NAME   (INT_NUM)   // NAME 中断 ID

// ---- 函数声明 ----//

/**
 * @brief  注册 NAME 中断
 * @param  gic_ins_ptr  GIC 实例指针
 * @return 0 成功，-1 失败
 */
int isr_NAME_register(XScuGic *gic_ins_ptr);
```

### 调用方初始化示例（提示用户在 init 函数中添加）

```c
// 在系统初始化函数中调用（GIC 初始化完成后）：

ret = isr_NAME_register(&g_gic_ins);
if (ret != 0) {
    log_error("NAME 中断注册失败");
    return -1;
}

// 最后统一使能异常：
Xil_ExceptionEnable();
```

## 完整初始化流程提示

标准 Vitis GIC 初始化顺序（仅在首个中断注册时需要）：

```c
// 1. 初始化 GIC
XScuGic_Config *gic_cfg = XScuGic_LookupConfig(XPAR_SCUGIC_0_DEVICE_ID);
XScuGic_CfgInitialize(&g_gic_ins, gic_cfg, gic_cfg->CpuBaseAddress);

// 2. 注册所有中断（调用各模块的 isr_xxx_register）
isr_NAME_register(&g_gic_ins);

// 3. 连接 GIC 到 ARM 异常向量表
Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, &g_gic_ins);

// 4. 使能异常
Xil_ExceptionEnable();
```

## 注意事项

- ISR 函数必须声明为 `static`，不对外暴露
- ISR 内**禁止**调用 `xil_printf`、`sleep`、`malloc` 等阻塞/耗时函数
- 若多个模块共用一个 GIC 实例（`g_gic_ins`），需确保全局声明后再传指针
- 触发方式选 `rising`（0x03）适用于大多数 PL 侧脉冲信号

## 参考示例

完整示例见 [example/dma_isr.c](example/dma_isr.c)
