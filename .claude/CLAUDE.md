# CLAUDE.md — 振镜控制板 AI 协作规范

> 本文件为项目级规范，通用规则通过下方引入。

@../rule/rule.md

---

## 项目结构概览

本仓库（`use_ai`）为 AI 协作配置仓库，存放振镜控制板工程的 AI 使用规范与技能脚本：

| 目录 / 文件              | 用途                                         |
|------------------------|---------------------------------------------|
| `rule/`                | 通用 AI 协作规则（`rule.md`）及各语言 Copilot 规范   |
| `.claude/CLAUDE.md`    | 项目级行为规范（本文件）                             |
| `.github/skills/`      | Copilot 技能脚本（平铺，由 VS Code Copilot 加载）   |
| `skills/`              | 技能脚本按语言分类存档（与 `.github/skills/` 内容一致） |
| `README.md`            | 仓库说明                                      |

> 振镜控制板工程（Zynq FPGA）的实际代码位于独立的工程仓库。

---

## 可用技能（Skills）

用 `/技能名` 调用，详细说明见各 `SKILL.md`。

### 通用

| 技能 | 功能 |
|------|------|
| `/gitignore [分类...]` | 生成或更新 `.gitignore`（os/vscode/qt/python/vitis/vivado/matlab/c/claude） |
| `/doc-update <文件> [版本] [说明]` | 更新 Markdown 文档版本记录表 |
| `/axi-interface <模块名> lite\|stream [位宽]` | 生成 AXI-Lite / AXI-Stream 从机接口模板 |

### C / C++

| 技能 | 功能 |
|------|------|
| `/c-new-file <文件名> [描述]` | 新建 `.c`/`.h` 文件对（含规范文件头） |
| `/c-header <.c文件>` | 为已有 `.c` 生成或同步 `.h`（函数声明、include guard） |
| `/c-struct <结构体名> <字段...>` | 生成结构体定义（Doxygen 注释、字段对齐） |
| `/c-update <文件> <版本> <说明>` | 更新文件头版本号和修改记录 |
| `/c-review <文件>` | 审查是否符合编码规范 |
| `/c-lint <文件>` | 静态质量审查（空指针/资源泄漏/未检查返回值） |
| `/c-fsm <模块名> <状态列表>` | 生成 C 状态机框架（状态枚举、三段式 enter/run/exit） |
| `/c-ringbuf <模块名> [大小] [类型]` | 生成环形缓冲区模板（DMA/UART 数据缓冲） |
| `/c-isr <中断名> <中断号> [触发方式]` | 生成 Vitis 中断服务程序框架（XScuGic 注册 + ISR 骨架） |
| `/c-conventions` | 加载 C/C++ 规范背景知识（自动触发） |

### Qt C++

| 技能 | 功能 |
|------|------|
| `/qt-new-class <类名> [描述]` | 新建 Qt 类（Q_OBJECT、信号槽、线程安全框架） |
| `/qt-new-widget <类名> [描述]` | 新建 QWidget UI 组件模板 |
| `/qt-update <文件> <版本> <说明>` | 更新 Qt 文件头版本号和修改记录 |

### Python

| 技能 | 功能 |
|------|------|
| `/py-new-file <文件名> [描述]` | 新建 Python 文件（含规范文件头，支持主程序/PyQt5/通用三种模板） |
| `/py-qt-worker <类名> [描述]` | 生成 PyQt5 QThread 工作线程模板（支持 UDP/串口/通用） |

### Verilog / SystemVerilog

| 技能 | 功能 |
|------|------|
| `/verilog-new-module <模块名> [描述]` | 新建模块文件（规范文件头、端口框架） |
| `/verilog-update <文件> <版本> <说明>` | 更新文件头版本号和修改记录 |
| `/verilog-inst <文件> [实例名]` | 从模块定义生成对齐例化代码 |
| `/verilog-doc <文件> [输出路径]` | 提取端口/参数，生成 Markdown 接口文档 |
| `/verilog-hier <顶层> <目录/文件...>` | 分析模块层次树，标注 IP 核/循环依赖 |
| `/verilog-fsm <模块名> <状态列表>` | 生成 FSM 模板（二段式/三段式） |
| `/verilog-fifo <模块名> sync\|async [深度] [位宽]` | 生成同步/异步 FIFO 模板 |
| `/verilog-pipeline <模块名> <级数> [位宽]` | 生成带握手的流水线模板 |
| `/verilog-cdc <模块名> 1bit\|handshake\|pulse` | 生成 CDC 同步器模板 |
| `/verilog-bram <模块名> sp\|dp\|rom [深度] [位宽] [hex]` | 生成 BRAM/ROM 模板 |
| `/verilog-regmap <模块名> <寄存器规格...>` | 生成 AXI-Lite 寄存器映射模块 |
| `/verilog-tb <模块名> [端口]` | 生成 Testbench 框架 |
| `/verilog-tb-assert <tb文件>` | 为 Testbench 添加断言和结果统计 |
| `/verilog-sim <tb文件> [dut文件...]` | iverilog 编译运行仿真，报告通过/失败 |
| `/verilog-review <文件>` | 审查是否符合编码规范 |
| `/verilog-lint <文件>` | RTL 质量审查（与工具无关） |
| `/verilog-resource <文件>` | 估算 LUT/FF/BRAM/DSP 资源用量 |
| `/verilog-timing <文件> [目标频率]` | 时序风险分析，生成 XDC 约束建议 |
| `/verilog-constraint <文件> [主时钟MHz]` | 生成 Vivado XDC 时序约束文件（pin.xdc + time.xdc） |
| `/verilog-conventions` | 加载 Verilog 规范背景知识（自动触发） |

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
