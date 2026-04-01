# Agent 使用指南

> 版本：v1.0　日期：2026/04/01

# 修改记录

| 版本   | 日期         | 修改内容     |
|------|------------|------------|
| v1.0 | 2026/04/01 | 创建文档      |

---

## 一、什么是 Agent

Agent（自定义智能体）是一种预配置的 AI 工作模式，可以让 Copilot Chat 以特定角色工作。

每个 Agent 包含：
- **系统指令**：定义 AI 的角色、行为方式和输出格式
- **工具限制**：指定该 Agent 可以调用哪些工具（如只读工具、编辑工具）
- **模型选择**：可以绑定特定的 AI 模型
- **交接流程（Handoffs）**：完成后自动推荐切换到下一个 Agent

**与 Skill / Prompt 的区别：**

| 类型 | 适用场景 |
|------|---------|
| **Agent** | 需要固定角色、工具限制、多步骤流程时使用 |
| **Skill** | 可复用的能力模板（生成代码框架等）|
| **Prompt** | 一次性任务，不需要工具限制时使用 |

---

## 二、Agent 文件位置

### 工作区范围（仅当前项目生效）

| 路径 | 说明 |
|------|------|
| `.github/agents/` | VS Code / Copilot 标准格式（`.agent.md`）|
| `.claude/agents/` | Claude Code 格式（`.md`）|

### 用户全局范围（所有项目生效）

| 路径 | 说明 |
|------|------|
| `~/.copilot/agents/` | 全局 Agent，跨工作区复用 |

> **建议**：通用工具类 Agent 放在 `~/.copilot/agents/`，项目专属 Agent 放在 `.github/agents/`。

---

## 三、Agent 文件格式

文件使用 Markdown 格式，扩展名为 `.agent.md`（Claude 格式用 `.md`）。

### 文件结构

```
---
YAML 前置配置
---

Agent 的具体指令（Markdown 正文）
```

### 前置配置字段说明

| 字段 | 必填 | 说明 |
|------|------|------|
| `description` | 推荐 | 简要描述，显示在 Chat 输入框占位符 |
| `name` | 可选 | Agent 名称，默认使用文件名 |
| `tools` | 推荐 | 可用工具列表（数组格式）|
| `model` | 可选 | 使用的 AI 模型，可指定优先级列表 |
| `handoffs` | 可选 | 完成后推荐跳转的下一个 Agent |
| `agents` | 可选 | 允许作为子 Agent 调用的 Agent 列表 |
| `user-invocable` | 可选 | 是否在 Chat 选择器中显示（默认 true）|
| `argument-hint` | 可选 | 输入框提示文字 |

### 常用工具名称

| 工具 | 功能 |
|------|------|
| `search/codebase` | 搜索代码库（只读）|
| `search/usages` | 搜索符号引用（只读）|
| `web/fetch` | 抓取网页内容 |
| `edit` | 编辑文件 |
| `run_in_terminal` | 执行终端命令 |
| `agent` | 调用子 Agent |

> 完整工具列表见 VS Code 文档：Chat → Agent Tools

---

## 四、Agent 示例

### 示例 1：代码规划 Agent（只读，不修改代码）

```markdown
---
description: 分析需求，生成实现方案，不修改代码
name: 规划师
tools: ['web/fetch', 'search/codebase', 'search/usages']
model: ['Claude Sonnet 4.6', 'GPT-5.2']
handoffs:
  - label: 开始实现
    agent: agent
    prompt: 按照上面的方案开始实现代码。
    send: false
---

你是一个技术规划师。任务是分析需求、理解现有代码结构，输出详细的实现方案。

**不要修改任何文件**，只输出方案文档，包含：
- 方案概述
- 涉及文件清单
- 详细实现步骤
- 注意事项
```

保存为 `.github/agents/planner.agent.md`

---

### 示例 2：代码审查 Agent（只读，专注质量）

```markdown
---
description: 审查代码，发现 Bug、安全漏洞和规范问题
name: 审查员
tools: ['search/codebase', 'search/usages']
---

你是一名严格的代码审查员，只关注真正重要的问题：

1. **Bug**：逻辑错误、边界条件、空指针等
2. **安全**：硬编码密钥、SQL 注入、缓冲区溢出等
3. **规范**：违反项目编码规范的问题

输出格式：
- 每个问题标注严重级别（严重 / 警告 / 建议）
- 给出文件名和行号
- 说明问题原因和修改建议

不评论代码风格和格式问题。
```

保存为 `.github/agents/reviewer.agent.md`

---

### 示例 3：Verilog 设计 Agent（工程专属）

```markdown
---
description: 按项目规范编写 Verilog 模块
name: Verilog 设计师
tools: ['search/codebase', 'edit']
---

你是一名 Verilog 设计工程师，严格遵守以下规范：

- 2空格缩进，禁止 Tab
- `begin` 必须另起一行
- 单 bit 信号使用 `1'b0` / `1'b1`，禁止直接写 `0` / `1`
- 时序逻辑用 `<=`，组合逻辑用 `=`
- `case` 语句必须包含 `default` 分支
- `_r` 后缀只用于延时信号（某信号打一拍的版本）
- 普通寄存器（计数器、状态机、移位寄存器）不加 `_r` 后缀

每个新模块须包含标准文件头（参考项目规范）。
```

保存为 `.github/agents/verilog-designer.agent.md`

---

### 示例 4：多 Agent 流水线（协作模式）

**主控 Agent** - `.github/agents/feature-builder.agent.md`

```markdown
---
name: 功能构建器
description: 先研究、再实现的功能开发流水线
tools: ['agent']
agents: ['研究员', '实现者']
---

你负责协调功能开发：
1. 先调用【研究员】Agent 收集现有代码上下文
2. 再调用【实现者】Agent 根据研究结果完成代码实现
```

**研究员** - `.github/agents/researcher.agent.md`

```markdown
---
name: 研究员
description: 只读调研，收集代码上下文
tools: ['search/codebase', 'web/fetch', 'search/usages']
user-invocable: false
---

只使用只读工具进行调研，返回调研摘要，不修改任何文件。
```

**实现者** - `.github/agents/implementer.agent.md`

```markdown
---
name: 实现者
description: 根据调研结果实现代码变更
tools: ['edit', 'search/codebase']
user-invocable: false
---

根据提供的上下文实现代码修改，遵循现有代码风格，做最小化变更。
```

---

## 五、Claude Code 格式（`.claude/agents/`）

Claude Code 使用稍有不同的格式，工具名称用逗号分隔字符串：

```markdown
---
name: 审查员
description: 代码审查，不修改文件
tools: "Read, Grep, Glob, WebSearch"
disallowedTools: "Edit, Write, Bash"
---

你是代码审查员...（指令内容）
```

VS Code 会自动识别 `.claude/agents/` 下的 `.md` 文件，支持在 VS Code 和 Claude Code 之间共用同一套 Agent 定义。

---

## 六、创建 Agent 的步骤

1. 在对应目录新建 `.agent.md` 文件（或 Claude 格式的 `.md`）
2. 编写 YAML 前置配置（description、tools 等）
3. 在正文中写明 Agent 的角色定位和行为规范
4. 重启或刷新 VS Code Chat
5. 在 Chat 界面选择 Agent 即可使用

> 快捷方式：在 Chat 输入框输入 `/agents` 可快速打开 Agent 配置界面

---

## 七、本项目 Agent 存放规范

```
.github/agents/         # 工作区专属 Agent（.agent.md 格式）
.claude/agents/         # Claude Code 专属 Agent（.md 格式）
~/.copilot/agents/      # 全局通用 Agent（跨工作区）
```

新建 Agent 命名规则：`<职责>-<角色>.agent.md`，例如：
- `code-planner.agent.md`
- `verilog-reviewer.agent.md`
- `doc-writer.agent.md`
