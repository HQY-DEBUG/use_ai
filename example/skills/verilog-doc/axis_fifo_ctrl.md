# axis_fifo_ctrl 接口说明文档

> 版本：v1.0　日期：2026/05/26

# 修改记录

| 版本   | 日期         | 修改内容     |
|------|------------|------------|
| v1.0 | 2026/05/26 | 创建文档      |

---

## 功能描述

`axis_fifo_ctrl` 是一个 AXI-Stream FIFO 控制器模块，用于在两个不同速率的 AXI-Stream 数据流之间提供缓冲。主要特性：

- 支持可配置深度（默认 512）和数据位宽（默认 32 位）
- 内置满/空标志及可编程阈值
- 支持背压机制（`tready` / `tvalid` 握手）
- 同步 FIFO，单时钟域

---

## 参数列表

| 参数名         | 默认值 | 说明                      |
|-------------|------|-------------------------|
| `DATA_WIDTH` | 32   | 数据位宽（bit）               |
| `DEPTH`      | 512  | FIFO 深度（必须为 2 的幂）       |
| `PROG_FULL`  | 480  | 可编程满阈值（超过此值 `prog_full` 拉高）|

---

## 端口列表

### 全局信号

| 端口名    | 方向    | 位宽 | 说明          |
|--------|-------|-----|-------------|
| `clk`  | input | 1   | 系统时钟        |
| `rstn` | input | 1   | 低有效同步复位     |

### AXI-Stream 写端口（Slave）

| 端口名              | 方向    | 位宽            | 说明              |
|------------------|-------|---------------|-----------------|
| `s_axis_tdata`   | input | `DATA_WIDTH`  | 输入数据            |
| `s_axis_tvalid`  | input | 1             | 输入数据有效          |
| `s_axis_tready`  | output| 1             | 接收就绪（FIFO 非满时高）|
| `s_axis_tlast`   | input | 1             | 帧结束标志（可选）       |

### AXI-Stream 读端口（Master）

| 端口名              | 方向    | 位宽            | 说明              |
|------------------|-------|---------------|-----------------|
| `m_axis_tdata`   | output| `DATA_WIDTH`  | 输出数据            |
| `m_axis_tvalid`  | output| 1             | 输出有效（FIFO 非空时高）|
| `m_axis_tready`  | input | 1             | 下游就绪信号          |
| `m_axis_tlast`   | output| 1             | 帧结束标志透传         |

### 状态信号

| 端口名           | 方向    | 位宽                      | 说明            |
|---------------|-------|-------------------------|---------------|
| `fifo_count`  | output| `$clog2(DEPTH+1)`       | 当前 FIFO 数据量   |
| `full`        | output| 1                       | FIFO 满标志      |
| `empty`       | output| 1                       | FIFO 空标志      |
| `prog_full`   | output| 1                       | 可编程满标志        |

---

## 时序说明

- **写入时序**：`s_axis_tvalid` 与 `s_axis_tready` 同时为高时，数据在当前时钟上升沿写入 FIFO。
- **读出时序**：`m_axis_tvalid` 与 `m_axis_tready` 同时为高时，数据在当前时钟上升沿被消费。
- **满保护**：`full` 拉高后，`s_axis_tready` 立即拉低，写端不会丢数据。

---

## 例化示例

```verilog
axis_fifo_ctrl #(
  .DATA_WIDTH ( 32  ),
  .DEPTH      ( 512 ),
  .PROG_FULL  ( 480 )
) u_axis_fifo_ctrl (
  .clk             ( clk              ),
  .rstn            ( rstn             ),
  .s_axis_tdata    ( s_axis_tdata     ),
  .s_axis_tvalid   ( s_axis_tvalid    ),
  .s_axis_tready   ( s_axis_tready    ),
  .s_axis_tlast    ( s_axis_tlast     ),
  .m_axis_tdata    ( m_axis_tdata     ),
  .m_axis_tvalid   ( m_axis_tvalid    ),
  .m_axis_tready   ( m_axis_tready    ),
  .m_axis_tlast    ( m_axis_tlast     ),
  .fifo_count      ( fifo_count       ),
  .full            ( fifo_full        ),
  .empty           ( fifo_empty       ),
  .prog_full       ( fifo_prog_full   )
);
```
