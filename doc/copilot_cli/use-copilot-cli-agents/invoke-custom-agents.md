# Invoking Custom Agents / 调用自定义 Agent

Extend Copilot CLI capabilities using custom agents, skills, and MCP servers.

使用自定义 Agent、技能和 MCP 服务器扩展 Copilot CLI 的功能。

## Custom Agents Overview / 自定义 Agent 概述

A custom agent represents a specialized Copilot variant designed to handle unique workflows, coding conventions, and specialist scenarios.

自定义 Agent 代表专为处理独特工作流、编码规范和专业场景而设计的 Copilot 变体。

Copilot CLI provides four default agents:

Copilot CLI 提供四个默认 Agent：

| Agent / Agent 名称 | Purpose / 用途 |
|-------|---------|
| Explore | Performs codebase analysis without impacting main context / 在不影响主上下文的情况下执行代码库分析 |
| Task | Executes commands like tests and builds with contextual output / 执行测试和构建等命令，提供上下文输出 |
| General-purpose | Handles complex multi-step tasks with full toolset access / 处理复杂多步骤任务，可访问完整工具集 |
| Code-review | Reviews changes while minimizing false positives / 审查变更，同时减少误报 |

The system allows the AI model to delegate work to subagent processes when it determines this approach yields better results.

当系统判断这种方式能产生更好结果时，允许 AI 模型将工作委托给子 Agent 进程。

## Creating Custom Agents / 创建自定义 Agent

Define your own agents using Markdown-based agent profiles that specify expertise, available tools, and response instructions.

使用基于 Markdown 的 Agent 配置文件定义你自己的 Agent，指定专业领域、可用工具和响应指令。

**Deployment levels:**

**部署级别：**

- **User-level**: `~/.copilot/agents` directory (all projects) / **用户级**：`~/.copilot/agents` 目录（所有项目）
- **Repository-level**: `.github/agents` directory (current project only) / **仓库级**：`.github/agents` 目录（仅当前项目）
- **Organization/Enterprise-level**: `/agents` in `.github-private` repository (all organizational projects) / **组织/企业级**：`.github-private` 仓库中的 `/agents`（所有组织项目）

Priority hierarchy: system agents override repository agents, which override organization-level agents.

优先级层次：系统 Agent 覆盖仓库 Agent，仓库 Agent 覆盖组织级 Agent。

## Invoking Custom Agents / 调用自定义 Agent

Three invocation methods exist:

存在三种调用方式：

1. **Slash command**: Use `/agent` in the interactive interface to select from available agents / **斜杠命令**：在交互界面使用 `/agent` 从可用 Agent 中选择
2. **Direct reference**: Mention the agent in your prompt for automatic inference: / **直接引用**：在提示词中提及 Agent 进行自动推断：
   ```
   Use the security-auditor agent on /src/app
   ```
3. **CLI option**: / **CLI 选项**：
   ```shell
   copilot --agent=refactor-agent --prompt "Your task"
   ```

## Skills and MCP Servers / 技能和 MCP 服务器

**Skills** enhance Copilot's specialized task capabilities through instructions, scripts, and resources. See [Creating agent skills for GitHub Copilot CLI](create-skills.md).

**技能**通过指令、脚本和资源增强 Copilot 的专业任务能力。请参阅[为 GitHub Copilot CLI 创建 Agent 技能](create-skills.md)。

**MCP servers** extend functionality. The GitHub MCP server comes pre-configured. Add additional servers using `/mcp add`, with configurations stored in `mcp-config.json` (default location: `~/.copilot` directory, customizable via `COPILOT_HOME` environment variable). See [Adding MCP servers for GitHub Copilot CLI](add-mcp-servers.md).

**MCP 服务器**扩展功能。GitHub MCP 服务器已预配置。使用 `/mcp add` 添加其他服务器，配置存储在 `mcp-config.json` 中（默认位置：`~/.copilot` 目录，可通过 `COPILOT_HOME` 环境变量自定义）。请参阅[为 GitHub Copilot CLI 添加 MCP 服务器](add-mcp-servers.md)。
