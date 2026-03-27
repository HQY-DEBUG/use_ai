# CLAUDE.md — 振镜控制板 AI 协作规范

> 本文件为项目级规范，通用规则通过下方引入。

@rule/rule.md

---

## 项目结构概览

本仓库（`use_ai`）为 AI 协作配置仓库，存放振镜控制板工程的 AI 使用规范与技能脚本：

| 目录 / 文件    | 用途                              |
|-------------|-----------------------------------|
| `rule/`     | 通用 AI 协作规则（`rule.md`）          |
| `.claude/skills/` | Claude Code 自定义技能脚本        |
| `CLAUDE.md` | 项目级行为规范（本文件）               |
| `README.md` | 仓库说明                           |

> 振镜控制板工程（Zynq FPGA）的实际代码位于独立的工程仓库。

---

## Git 范围（本项目）

本项目 `<范围>` 取值：

`PC`、`qt`、`vitis`、`dma`、`uart`、`ui`、`doc`、`verilog`、`matlab`

---

## 架构要点

**PS 端（Vitis）**：init + poll 模式；Log 四级分层（`prinfo`/`prwarn`/`prerror` 常开，`prbrief` 默认开，`prdebug`/`prlist`/`prhigh` 默认关）

**协议命令**：`CmdType = 0xAABBCCDD`（AA=执行类型，BB=大类，CC=子命令，DD=应答类型）

**DDR 布局**：代码区 → PROG(32MB) → CORR(8MB) → JUMP(4KB) → DMA_X/Y/Z(各10MB) → LIST(16MB)

**PL 端（Verilog）**：时序用 `<=`，组合用 `=`；复位统一命名（低有效 `rstn`，高有效 `rst`）
