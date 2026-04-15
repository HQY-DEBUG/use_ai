# 执行计划

> 生成时间：2026/04/15 10:23
> 需求摘要：为 uart_rx 模块新增奇偶校验功能并补充单测
> 状态：✅ 已完成

---

## 任务依赖图（DAG）

```
步骤1（读现有代码） ──→ 步骤2（修改模块） ──→ 步骤4（校验）
步骤3（新增单测）   ──→ 步骤4（校验）
```

⚡ 可并行执行：步骤2 与 步骤3 无依赖，可同时推进

---

## 任务清单

### 步骤 1：读取现有 uart_rx 模块

- [x] 状态：✅ 完成（10:23）
- 文件变更：无（只读）
- 预估耗时：< 1 min
- 依赖：无
- 备注：确认当前接口与信号命名，避免冲突

### 步骤 2：为 uart_rx 模块新增奇偶校验逻辑

- [x] 状态：✅ 完成（10:25，commit: 3a7f1bc）
- 文件变更：`PL/source/verilog/uart_rx.v`（修改）
- 预估耗时：3 min
- 依赖：步骤1
- 备注：
  - 💡 推荐 Skill：`/verilog-review uart_rx.v` — 可对照规范检查修改后代码

### 步骤 3：新增奇偶校验 Testbench

- [x] 状态：✅ 完成（10:27，commit: 9c2d4e5）
- 文件变更：`PL/source/sim/uart_rx_parity_tb.v`（新增）
- 预估耗时：5 min
- 依赖：步骤1
- 备注：
  - 💡 推荐 Skill：`/verilog-tb uart_rx` — 可生成标准 Testbench 框架

### 步骤 4：运行仿真校验

- [x] 状态：✅ 完成（10:29）
- 文件变更：无
- 预估耗时：< 1 min
- 依赖：步骤2、步骤3
- 备注：iverilog 编译通过，所有断言 PASS

---

## 文件变更总览

| 文件 | 操作 | 步骤 | Commit |
|------|------|------|--------|
| `PL/source/verilog/uart_rx.v` | 修改 | 步骤2 | 3a7f1bc |
| `PL/source/sim/uart_rx_parity_tb.v` | 新增 | 步骤3 | 9c2d4e5 |

---

## 隐式约束（来自工作区规则扫描）

- 缩进：2空格（来自 .editorconfig，Verilog 规范）
- begin 另起一行（来自 verilog-style.instructions.md）
- 单bit常量显式位宽 1'b0/1'b1（来自 verilog-style.instructions.md）

---

## 依赖预检结果

- [x] iverilog 已安装（`iverilog -V` 返回正常）

---

## 模型路由建议

| 步骤 | 复杂度 | 建议模型 |
|------|--------|---------|
| 步骤2 奇偶校验逻辑 | 中 | 强模型 |
| 步骤3 Testbench 生成 | 低 | 轻量模型 |

---

## 执行日志

```
10:23 [步骤1] 读取 uart_rx.v，确认现有接口：clk, rstn, rx_data[7:0], rx_valid
10:25 [步骤2] 新增 parity_err 信号，插入奇偶校验组合逻辑，校验风格：偶校验
10:25 [步骤2] 规则检查通过（2空格缩进、begin换行、1'b0显式位宽）
10:25 [步骤2] git commit 3a7f1bc: feat(pl): uart_rx 新增奇偶校验功能
10:27 [步骤3] 生成 uart_rx_parity_tb.v，含正常帧/奇校验错误/偶校验错误三类激励
10:27 [步骤3] git commit 9c2d4e5: test(pl): 新增 uart_rx 奇偶校验单测
10:29 [步骤4] iverilog 编译成功，vvp 运行，3/3 断言通过
```
