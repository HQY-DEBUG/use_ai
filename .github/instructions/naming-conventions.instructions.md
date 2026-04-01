---

description: "变量与标识符命名规范：C/C++、Python、MATLAB、Verilog/SystemVerilog。当编写或修改 .c/.h/.cpp/.hpp/.py/.m/.v/.sv 文件时使用。"
applyTo: "**/*.c,**/*.h,**/*.cpp,**/*.hpp,**/*.py,**/*.m,**/*.v,**/*.sv,**/*.vh,**/*.svh"
---

# 命名规范

## C/C++

|类型|风格|示例|
|--|--|--|
|变量、函数|小写下划线|`recv_buf`、`init_dma()`|
|宏定义|全大写下划线|`MAX_BUF_SIZE`|
|全局变量|`g_` 前缀 + 小写下划线|`g_tx_count`|
|类名、结构体|大驼峰或小写下划线|`UdpWorker`、`udp_worker`|
|成员变量|小写下划线，可选 `m_` 前缀|`m_socket`、`buf_len`|

## Python

|类型|风格|示例|
|--|--|--|
|变量、函数|小写下划线|`recv_buf`、`init_dma()`|
|常量|全大写下划线|`MAX_BUF_SIZE`|
|类名|大驼峰|`UdpWorker`|
|私有成员|单下划线前缀|`_internal_var`|

## MATLAB

|类型|风格|示例|
|--|--|--|
|变量、函数|小写下划线|`recv_buf`、`parse_csv()`|
|常量|全大写下划线|`MAX_ROWS`|

## Verilog / SystemVerilog

|类型|风格|示例|
|--|--|--|
|模块名、信号名|小写下划线|`axis_rx`、`data_valid`|
|参数、宏|全大写下划线|`DATA_WIDTH`|
|延时信号|`_r` 后缀；多级延时用 `_r1`、`_r2` 递增|`cnt_r`、`data_r1`、`data_r2`|
|复位信号|低有效 `rstn`，高有效 `rst`|`rstn`、`rst`|
|输入/输出冲突消歧|优先不加后缀；冲突时输入加 `_i`、输出加 `_o`|`data_i`、`data_o`|

> 注意：总线接口信号（AXI/AXIS 等）不使用 `_i`/`_o` 后缀；非必要不加后缀。

## 通用原则

- 命名要有意义，避免单字母（除循环变量 `i`、`j`、`k`）
- 布尔变量用 `is_`、`has_`、`can_` 等前缀，如 `is_valid`、`has_data`（仅适用于 C/C++/Python/Qt，Verilog 不使用）
