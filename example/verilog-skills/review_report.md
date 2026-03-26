# SPI Master 综合评审报告

> 文件：`review_report.md`  版本：v1.0  日期：2026-03-26

---

## 评审目标

| 文件 | 说明 |
|---|---|
| `spi_master.v` | SPI 主机控制器 RTL |
| `spi_master_tb.v` | 仿真 Testbench |

使用技能：`/verilog-review`、`/verilog-lint`、`/verilog-resource`、`/verilog-timing`

---

## 一、规范审查（/verilog-review）

```
== Verilog 规范审查报告：spi_master.v ==

✅ 通过项：11 项
❌ 违规项：0 项
```

| 检查项 | 结果 |
|---|---|
| 文件头（Function/Version/Date/Description/Modify）| ✅ 完整 |
| 修改记录 ≤ 3 版本 | ✅ 1 条（v1.0） |
| 2个空格缩进，无 Tab | ✅ |
| `begin` 独立一行 | ✅ |
| 单bit信号使用 `1'b0`/`1'b1` | ✅ |
| 时序逻辑仅用 `<=` | ✅ |
| 端口每行一个，对齐排列 | ✅ |
| 模块名/信号名小写下划线 | ✅ |
| 参数全大写下划线（`DATA_W`、`CLK_DIV_W`） | ✅ |
| 寄存器加 `_r` 后缀 | ✅（`state_r`、`sclk_r`、`tx_shift_r` 等） |
| 复位信号命名 `rst_n`（低有效） | ✅ |
| 注释使用中文，行内用 `//` | ✅ |

---

## 二、RTL 质量审查（/verilog-lint）

```
== Verilog RTL 质量审查报告：spi_master.v ==

✅ 通过项：9 项
⚠️  警告项：2 项
❌ 问题项：0 项
```

### 通过项

| 检查项 | 说明 |
|---|---|
| 敏感列表 | 时序逻辑使用 `posedge clk or negedge rst_n`，正确 |
| 阻塞/非阻塞赋值 | 时序逻辑全部使用 `<=`，无混用 |
| 锁存器推断 | 全部 `case` 含 `default`，无意外锁存器 |
| 多驱动 | 每个信号仅有一个驱动源 |
| 复位覆盖 | 所有寄存器在复位分支赋初值 |
| 复位极性一致 | `rst_n` 低有效，异步复位 |
| 端口连接完整 | TB 中所有端口已连接 |
| 单bit常量 | 所有单bit赋值/比较均使用 `1'b0`/`1'b1` |
| 位宽拼接 | `{DATA_W{1'b0}}` 位宽明确 |

### 警告项

| 行号 | 类别 | 说明 |
|---|---|---|
| 约 125 行 | 位宽隐式比较 | `bit_cnt_r == (DATA_W - 1)`：`DATA_W` 为 parameter，右侧为 32-bit 整数，建议改为 `bit_cnt_r == DATA_W[3:0] - 1'b1` 确保位宽匹配 |
| 约 140 行 | 位宽比较 | `bit_cnt_r < DATA_W[3:0]`：已做截断处理，可接受；建议 localparam 定义 `DATA_W_4 = DATA_W[3:0]` 提升可读性 |

### 改进建议

```verilog
// 建议在模块内部添加：
localparam [3:0] BIT_MAX = DATA_W[3:0] - 1'b1 ;  // 最后一 bit 索引

// 比较时使用：
if (bit_cnt_r == BIT_MAX) ...
if (bit_cnt_r < DATA_W[3:0]) ...
```

---

## 三、资源分析（/verilog-resource）

目标器件：Zynq-7000（xc7z020clg484-1）

```
== Verilog 资源分析报告：spi_master.v ==
（参数：DATA_W=8，CLK_DIV_W=8）
```

### 寄存器（FF）

| 信号名 | 位宽 | 说明 |
|---|---|---|
| `state_r` | 2 bit | 状态寄存器 |
| `div_cnt_r` | 8 bit | 分频计数器 |
| `sclk_en_r` | 1 bit | SCLK 使能 |
| `sclk_r` | 1 bit | SCLK 状态 |
| `tx_shift_r` | 8 bit | 发送移位寄存器 |
| `rx_shift_r` | 8 bit | 接收移位寄存器 |
| `mosi_r` | 1 bit | MOSI 输出 |
| `bit_cnt_r` | 4 bit | 位计数器 |
| `first_edge_r` | 1 bit | CPHA=1 首沿标志 |
| `spi_cs_n`（输出reg）| 1 bit | 片选 |
| `m_valid`（输出reg）| 1 bit | 接收有效 |
| `m_data`（输出reg）| 8 bit | 接收数据 |
| **合计** | **~44 bit** | **约 44 个 FF** |

### 组合逻辑（LUT）估算

| 逻辑块 | 密度 | 说明 |
|---|---|---|
| 分频计数器比较 `div_tick` | 低 | 8bit 等值比较，约 4 LUT |
| SCLK 边沿检测 | 低 | 2 个 AND 门，约 2 LUT |
| `sample_on_rise_w` / `sample_en` / `shift_en` | 低 | 约 3 LUT |
| `rx_next_w` 选择器 | 低 | 8bit MUX，约 8 LUT |
| FSM 次态逻辑 + case | 中 | 约 12 LUT |
| `tx_bit` / `spi_io_oe` | 低 | 约 4 LUT |
| **合计估算** | **低** | **约 33 LUT** |

### BRAM / DSP

- **BRAM**：无（无大型数组）
- **DSP**：无（无乘法/MAC 运算）

### 资源总结

| 资源 | 估算用量 | Zynq-7020 容量 | 占比 |
|---|---|---|---|
| FF | ~44 | 106,400 | < 0.1% |
| LUT | ~33 | 53,200 | < 0.1% |
| BRAM | 0 | 140 | 0% |
| DSP | 0 | 220 | 0% |

**结论**：极低资源消耗，可多实例化（如同时驱动 4 路 SPI 从机，资源仍远小于 1%）。

---

## 四、时序分析（/verilog-timing）

目标频率：100 MHz（周期 10 ns）

```
== Verilog 时序分析报告：spi_master.v ==
```

### 关键路径分析

| 路径 | 描述 | 逻辑层数估算 | 风险 |
|---|---|---|---|
| `div_cnt_r` 比较链 | 8bit 加法器 → 等值比较（`div_tick`）| 约 4 级 | 低 |
| `bit_cnt_r` → FSM 次态 | 4bit 比较 → case 选择 → state_r | 约 3 级 | 低 |
| `rx_next_w` → `rx_shift_r` | MUX → 移位拼接 → 寄存器 | 约 2 级 | 低 |
| `cfg_cpol`/`cfg_cpha` → `sample_en` | 异或 → MUX → 使能 | 约 2 级 | 低 |

### CDC 风险

**无时钟域交叉问题**：所有逻辑均在单一 `clk` 时钟域。
SCLK（`sclk_r`）为内部生成信号，不跨时钟域。

### 复位分析

- 异步复位（`negedge rst_n`）：✅ 符合规范
- 所有寄存器均在复位中赋初值：✅
- 同步释放：未处理（建议在顶层添加同步释放模块）

> **建议**：若 `rst_n` 来自外部 IO 或跨时钟域，顶层应加两级同步器再输入此模块。可使用 `/verilog-cdc` 技能生成 `pulse` 类型同步器。

### 时序裕量预估

在 100 MHz 时钟下，最长组合逻辑路径约 4 级 LUT（~2.5 ns），时序裕量充裕（>7 ns）。
在 200 MHz 时钟下仍可工作，无需流水线改造。

---

## 五、设计完整性检查

| 功能点 | 覆盖情况 |
|---|---|
| Mode 0（CPOL=0, CPHA=0）| ✅ FSM 支持 |
| Mode 1（CPOL=0, CPHA=1）| ✅ `first_edge_r` 机制处理 |
| Mode 2（CPOL=1, CPHA=0）| ✅ |
| Mode 3（CPOL=1, CPHA=1）| ✅ |
| MSB 先发 | ✅ `cfg_lsb=0` |
| LSB 先发 | ✅ `cfg_lsb=1` |
| 四线全双工 | ✅ `spi_mosi` + `spi_miso` |
| 三线半双工 | ✅ `spi_io_oe` + `spi_io_out` + `spi_io_in` |
| 速率可配 | ✅ `cfg_clk_div`（0=CLK/2，255=CLK/512） |
| 传输中不接受新请求 | ✅ `s_ready` 仅在 IDLE 为 1 |
| CS 建立/保持时序 | ✅ CS_SETUP / CS_HOLD 状态保证 |

---

## 六、改进建议汇总

| 优先级 | 建议 |
|---|---|
| 高 | 顶层加复位同步释放（两级 FF 同步 rst_n） |
| 中 | 用 `localparam BIT_MAX` 替代 `DATA_W-1` 直接比较，消除位宽警告 |
| 中 | TB 从机回环模型改为 CPOL/CPHA 感知型，提升测试覆盖率 |
| 低 | 添加 `data_count` 输出（当前已发送位数），便于调试 |
| 低 | 支持 `burst` 模式（连续帧间 CS_N 保持低） |
