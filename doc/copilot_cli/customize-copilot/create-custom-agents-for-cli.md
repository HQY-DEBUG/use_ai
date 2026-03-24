# Creating and Using Custom Agents for GitHub Copilot CLI / 为 GitHub Copilot CLI 创建和使用自定义 Agent

## Overview / 概述

Custom agents let you configure specialized tools tailored to particular development workflows. These agents operate as subagents—temporary instances with isolated context windows—allowing complex tasks to be handled without cluttering the main agent's processing capacity.

自定义 Agent 让你能够配置专门针对特定开发工作流的工具。这些 Agent 作为子 Agent 运行——具有独立上下文窗口的临时实例——允许处理复杂任务而不会占用主 Agent 的处理能力。

## How to Create a Custom Agent / 如何创建自定义 Agent

Custom agents are defined through Markdown files with an `.agent.md` extension. You can create them manually or through the CLI's interactive setup.

自定义 Agent 通过带有 `.agent.md` 扩展名的 Markdown 文件定义。你可以手动创建，也可以通过 CLI 的交互式设置创建。

### Via CLI Interactive Mode / 通过 CLI 交互模式

1. Enter `/agent` in interactive mode

1. 在交互模式下输入 `/agent`

2. Select **Create new agent**

2. 选择 **Create new agent**

3. Choose storage location:
   - **Project**: `.github/agents/`
   - **User**: `~/.copilot/agents/`

3. 选择存储位置：
   - **Project（项目）**：`.github/agents/`
   - **User（用户）**：`~/.copilot/agents/`

   (Note: User-level agents override project-level ones with identical names)

   （注意：同名时用户级 Agent 会覆盖项目级 Agent）

4. Select your creation method:

4. 选择创建方式：

   **Copilot-Assisted Creation**: Describe the agent's expertise and intended use. Copilot generates an initial profile, which you can review and edit before finalizing.

   **Copilot 辅助创建**：描述 Agent 的专业领域和预期用途。Copilot 生成初始配置文件，你可以在确认前查看和编辑。

   **Manual Creation**: Answer CLI prompts for:
   - Agent name (lowercase with hyphens recommended for programmatic use)
   - Description of expertise and use cases
   - Behavioral instructions and constraints

   **手动创建**：回答 CLI 提示：
   - Agent 名称（建议使用小写连字符格式以便编程使用）
   - 专业领域和使用场景描述
   - 行为指令和约束

5. Configure tool access (all tools available by default unless restricted)

5. 配置工具访问权限（默认所有工具可用，除非有限制）

6. Restart the CLI to activate the new agent

6. 重启 CLI 以激活新 Agent

## Custom Agent Frontmatter / 自定义 Agent Frontmatter

| Field / 字段 | Type / 类型 | Required / 必需 | Description / 说明 |
|-------|------|----------|-------------|
| `description` | string / 字符串 | Yes / 是 | Shown in agent list and task tool / 显示在 Agent 列表和任务工具中 |
| `infer` | boolean / 布尔 | No / 否 | Allow auto-delegation (default: true) / 允许自动委托（默认：true） |
| `mcp-servers` | object / 对象 | No / 否 | MCP servers to connect / 要连接的 MCP 服务器 |
| `model` | string / 字符串 | No / 否 | AI model; inherits outer agent if unset / AI 模型；未设置时继承外部 Agent |
| `name` | string / 字符串 | No / 否 | Display name (defaults to filename) / 显示名称（默认为文件名） |
| `tools` | string[] / 字符串数组 | No / 否 | Available tools (default: all) / 可用工具（默认：全部） |

## Custom Agent Locations / 自定义 Agent 位置

| Scope / 作用域 | Location / 位置 |
|-------|----------|
| Project / 项目 | `.github/agents/` or `.claude/agents/` |
| User / 用户 | `~/.copilot/agents/` or `~/.claude/agents/` |
| Plugin / 插件 | `<plugin>/agents/` |

Project agents override user agents; plugin agents have lowest priority.

项目 Agent 覆盖用户 Agent；插件 Agent 优先级最低。

## Built-in Agents / 内置 Agent

| Agent / Agent 名称 | Model / 模型 | Description / 说明 |
|-------|-------|-------------|
| `code-review` | claude-sonnet-4.5 | High-signal code review analyzing diffs for bugs and issues / 高信噪比代码审查，分析差异以发现 Bug 和问题 |
| `explore` | claude-haiku-4.5 | Fast codebase exploration with focused answers / 快速代码库探索，提供聚焦答案 |
| `general-purpose` | claude-sonnet-4.5 | Full-capability multi-step task agent / 全功能多步骤任务 Agent |
| `research` | claude-sonnet-4.6 | Deep research generating reports from codebase and web / 深度研究，从代码库和网络生成报告 |
| `task` | claude-haiku-4.5 | Command execution (tests, builds, lints) / 命令执行（测试、构建、代码检查） |

## How to Use a Custom Agent / 如何使用自定义 Agent

**Slash Command Method / 斜杠命令方式：**
Access via `/agent` in interactive mode, then select from available agents.

在交互模式下通过 `/agent` 访问，然后从可用 Agent 中选择。

**Direct Reference / 直接引用：**
Type instructions explicitly: `Use the security-auditor agent on /src/app`

明确输入指令：`Use the security-auditor agent on /src/app`

**Automatic Inference / 自动推断：**
Trigger based on prompt content matching agent descriptions or keywords defined in the profile.

根据提示词内容匹配 Agent 描述或配置文件中定义的关键词自动触发。

**Programmatic Approach / 编程方式：**
```shell
copilot --agent security-auditor --prompt "Check /src/app/validator.go"
```
