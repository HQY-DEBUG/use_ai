# use_ai

> 版本：v1.0　日期：2026/04/01

振镜控制板工程的 AI 协作配置仓库，存放 **Claude Code** 和 **GitHub Copilot** 的使用规范与技能脚本。

---

## 目录结构

```
use_ai/
├── .claude/                  # Claude Code 配置
│   ├── CLAUDE.md             # 项目级规范（自动加载）
│   ├── rule.md               # 通用 AI 协作规范
│   └── skills/               # Claude Code 技能脚本（38 个，平铺）
│
├── .github/                  # GitHub Copilot 配置
│   ├── copilot-instructions.md   # Copilot 全局指令（自动加载）
│   ├── instructions/             # 分类规范文件（14 个，自动叠加）
│   └── skills/                   # Copilot 技能脚本（38 个，平铺）
│
├── rule/                     # 规范存档（按工具分类）
│   ├── claude/               # Claude Code 规范存档
│   │   ├── CLAUDE.md
│   │   └── rule.md
│   └── copilot/              # Copilot 规范存档
│       ├── copilot-instructions.md
│       └── instructions/     # 14 个 .instructions.md
│
├── skills/                   # 技能脚本分类存档
│   ├── common/               # 通用（2 个）
│   ├── c/                    # C/C++（10 个）
│   ├── qt/                   # Qt C++（3 个）
│   ├── python/               # Python（2 个）
│   └── verilog/              # Verilog/SystemVerilog（21 个）
│
├── example/                  # 技能调用示例输出
│   └── skills/               # 各技能示例文件（24 个目录）
│
└── doc/                      # 参考文档
```

---

## 规范说明

### Claude Code

| 文件 | 说明 |
|------|------|
| `.claude/CLAUDE.md` | 项目级规范，Claude Code 自动加载；通过 `@rule.md` 引入通用规则 |
| `.claude/rule.md` | 通用 AI 协作规范 v1.4，涵盖所有语言规范、Git 规范、命名规范等 |

### GitHub Copilot

| 文件 | 说明 |
|------|------|
| `.github/copilot-instructions.md` | Copilot 全局指令，所有请求自动生效 |
| `.github/instructions/*.instructions.md` | 按文件类型自动叠加的分类规范（14 个） |

---

## 技能列表（Skills）

使用方式：`/技能名 [参数]`

### 通用（2）

| 技能 | 功能 |
|------|------|
| `/gitignore [分类...]` | 生成或更新 `.gitignore` |
| `/doc-update <文件> [版本] [说明]` | 更新 Markdown 文档版本记录表 |

### C / C++（10）

| 技能 | 功能 |
|------|------|
| `/c-new-file <文件名> [描述]` | 新建 `.c`/`.h` 文件对 |
| `/c-header <.c文件>` | 生成或同步 `.h` 头文件 |
| `/c-struct <结构体名> <字段...>` | 生成结构体定义（含 Doxygen 注释） |
| `/c-update <文件> <版本> <说明>` | 更新文件头版本号和修改记录 |
| `/c-review <文件>` | 审查是否符合编码规范 |
| `/c-lint <文件>` | 静态质量审查（空指针/资源泄漏） |
| `/c-fsm <模块名> <状态列表>` | 生成 C 状态机框架 |
| `/c-ringbuf <模块名> [大小] [类型]` | 生成环形缓冲区模板 |
| `/c-isr <中断名> <中断号> [触发方式]` | 生成 Vitis 中断服务程序框架 |
| `/c-conventions` | 加载 C/C++ 规范背景知识 |

### Qt C++（3）

| 技能 | 功能 |
|------|------|
| `/qt-new-class <类名> [描述]` | 新建 Qt 类（Q_OBJECT、信号槽） |
| `/qt-new-widget <类名> [描述]` | 新建 QWidget UI 组件模板 |
| `/qt-update <文件> <版本> <说明>` | 更新 Qt 文件头版本号 |

### Python（2）

| 技能 | 功能 |
|------|------|
| `/py-new-file <文件名> [描述]` | 新建 Python 文件（主程序/PyQt5/通用） |
| `/py-qt-worker <类名> [描述]` | 生成 PyQt5 QThread 工作线程模板 |

### Verilog / SystemVerilog（21）

| 技能 | 功能 |
|------|------|
| `/verilog-new-module <模块名> [描述]` | 新建模块文件 |
| `/verilog-update <文件> <版本> <说明>` | 更新文件头版本号 |
| `/verilog-inst <文件> [实例名]` | 生成对齐例化代码 |
| `/verilog-doc <文件> [输出路径]` | 生成 Markdown 接口文档 |
| `/verilog-hier <顶层> <目录/文件...>` | 分析模块层次树 |
| `/verilog-fsm <模块名> <状态列表>` | 生成 FSM 模板（三段式） |
| `/verilog-fifo <模块名> sync\|async [深度] [位宽]` | 生成同步/异步 FIFO 模板 |
| `/verilog-pipeline <模块名> <级数> [位宽]` | 生成带握手的流水线模板 |
| `/verilog-cdc <模块名> 1bit\|handshake\|pulse` | 生成 CDC 同步器模板 |
| `/verilog-bram <模块名> sp\|dp\|rom [深度] [位宽] [hex]` | 生成 BRAM/ROM 模板 |
| `/verilog-regmap <模块名> <寄存器规格...>` | 生成 AXI-Lite 寄存器映射模块 |
| `/verilog-tb <模块名> [端口]` | 生成 Testbench 框架 |
| `/verilog-tb-assert <tb文件>` | 为 Testbench 添加断言 |
| `/verilog-sim <tb文件> [dut文件...]` | 编译运行 iverilog 仿真 |
| `/verilog-review <文件>` | 审查是否符合编码规范 |
| `/verilog-lint <文件>` | RTL 质量审查 |
| `/verilog-resource <文件>` | 估算 LUT/FF/BRAM/DSP 资源 |
| `/verilog-timing <文件> [目标频率]` | 时序风险分析 |
| `/verilog-constraint <文件> [主时钟MHz]` | 生成 XDC 约束（pin.xdc + time.xdc） |
| `/verilog-conventions` | 加载 Verilog 规范背景知识 |
| `/axi-interface <模块名> lite\|stream [位宽]` | 生成 AXI-Lite / AXI-Stream 从机接口 |

---

## 全局安装

将规范和技能同步到用户主目录，使其在所有工程中生效：

```powershell
# Claude Code 全局规范
Copy-Item .claude\CLAUDE.md  "$env:USERPROFILE\.claude\CLAUDE.md"  -Force
Copy-Item .claude\rule.md    "$env:USERPROFILE\.claude\rule.md"    -Force
Copy-Item -Recurse .claude\skills "$env:USERPROFILE\.claude\skills" -Force

# Copilot 全局规范
Copy-Item .github\copilot-instructions.md "$env:USERPROFILE\.copilot\instructions\copilot-instructions.md" -Force
Copy-Item -Recurse .github\instructions   "$env:USERPROFILE\.copilot\instructions" -Force
Copy-Item -Recurse .github\skills         "$env:USERPROFILE\.copilot\skills"       -Force
```

---

## 修改记录

| 版本   | 日期         | 修改内容                          |
|------|------------|-------------------------------|
| v1.0 | 2026/04/01 | 初始发布，包含完整规范与 38 个技能脚本 |
