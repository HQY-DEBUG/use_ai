# 创建自定义 subagents

> 在 Claude Code 中创建和使用专门的 AI subagents，用于特定任务的工作流和改进的上下文管理。

Subagents 是处理特定类型任务的专门 AI 助手。每个 subagent 在自己的 context window 中运行，具有自定义系统提示、特定的工具访问权限和独立的权限。当 Claude 遇到与 subagent 描述相匹配的任务时，它会委托给该 subagent，该 subagent 独立工作并返回结果。

Subagents 帮助您：

* **保留上下文**，通过将探索和实现保持在主对话之外
* **强制执行约束**，通过限制 subagent 可以使用的工具
* **跨项目重用配置**，使用用户级 subagents
* **专门化行为**，为特定领域使用专注的系统提示
* **控制成本**，通过将任务路由到更快、更便宜的模型（如 Haiku）

## 内置 subagents

Claude Code 包括内置 subagents，Claude 在适当时自动使用：

| Agent | Purpose |
|-------|---------|
| Explore | 快速只读代理，针对搜索和分析代码库优化（Haiku 模型） |
| Plan | 在 plan mode 期间使用的研究代理，只读工具 |
| General-purpose | 处理复杂多步骤任务，可使用所有工具 |
| Bash | 在单独上下文中运行终端命令 |
| statusline-setup | 配置状态行时使用 |
| Claude Code Guide | 回答关于 Claude Code 功能的问题 |

## 快速入门：创建第一个 subagent

使用 `/agents` 命令：

1. 运行 `/agents`
2. 选择 **Create new agent** → **User-level**（保存到 `~/.claude/agents/`）
3. 选择 **Generate with Claude** 并描述 subagent
4. 选择工具、模型、颜色，保存

## 配置 subagents

### Subagent 文件格式

Subagents 是带有 YAML frontmatter 的 Markdown 文件：

```markdown
---
name: code-reviewer
description: Reviews code for quality and best practices
tools: Read, Glob, Grep
model: sonnet
---

You are a code reviewer. When invoked, analyze the code and provide
specific, actionable feedback on quality, security, and best practices.
```

### Subagent 作用域

| Location | Scope | Priority |
|----------|-------|----------|
| `--agents` CLI 标志 | 当前会话 | 1（最高） |
| `.claude/agents/` | 当前项目 | 2 |
| `~/.claude/agents/` | 所有项目 | 3 |
| Plugin 的 `agents/` | 启用 plugin 的位置 | 4（最低） |

### 支持的 frontmatter 字段

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | 唯一标识符，小写字母和连字符 |
| `description` | Yes | Claude 何时应该委托给此 subagent |
| `tools` | No | 可使用的工具列表（省略则继承所有） |
| `disallowedTools` | No | 要拒绝的工具 |
| `model` | No | `sonnet`、`opus`、`haiku`、完整模型 ID 或 `inherit` |
| `permissionMode` | No | `default`、`acceptEdits`、`dontAsk`、`bypassPermissions` 或 `plan` |
| `maxTurns` | No | subagent 停止前的最大轮数 |
| `skills` | No | 启动时预加载的 skills |
| `mcpServers` | No | 对此 subagent 可用的 MCP 服务器 |
| `hooks` | No | 生命周期 hooks |
| `memory` | No | 持久内存范围：`user`、`project` 或 `local` |
| `background` | No | `true` 则始终作为后台任务运行 |
| `isolation` | No | `worktree` 则在临时 git worktree 中运行 |

### 选择模型

* `sonnet`、`opus`、`haiku`：使用别名
* 完整模型 ID：如 `claude-opus-4-6`
* `inherit`：使用与主对话相同的模型（默认）

### 权限模式

| Mode | Behavior |
|------|----------|
| `default` | 标准权限检查，带有提示 |
| `acceptEdits` | 自动接受文件编辑 |
| `dontAsk` | 自动拒绝权限提示 |
| `bypassPermissions` | 跳过所有权限检查 |
| `plan` | Plan mode（只读探索） |

### 将 MCP 服务器限定于 subagent

```yaml
---
name: browser-tester
description: Tests features in a real browser using Playwright
mcpServers:
  # 内联定义：仅限于此 subagent
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
  # 引用已配置的服务器
  - github
---
```

### 启用持久内存

```yaml
---
name: code-reviewer
description: Reviews code for quality and best practices
memory: user
---
```

内存范围：

| Scope | Location | 使用时机 |
|-------|----------|---------|
| `user` | `~/.claude/agent-memory/<name>/` | 在所有项目中记住 |
| `project` | `.claude/agent-memory/<name>/` | 特定项目，版本控制共享 |
| `local` | `.claude/agent-memory-local/<name>/` | 特定项目，不检入版本控制 |

### Hooks

#### Subagent frontmatter 中的 hooks

```yaml
---
name: code-reviewer
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-command.sh $TOOL_INPUT"
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
---
```

#### 项目级 subagent 事件 hooks（settings.json）

```json
{
  "hooks": {
    "SubagentStart": [
      {
        "matcher": "db-agent",
        "hooks": [
          { "type": "command", "command": "./scripts/setup-db-connection.sh" }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          { "type": "command", "command": "./scripts/cleanup.sh" }
        ]
      }
    ]
  }
}
```

### 禁用特定 subagents

```json
{
  "permissions": {
    "deny": ["Agent(Explore)", "Agent(my-custom-agent)"]
  }
}
```

或使用 CLI 标志：

```bash
claude --disallowedTools "Agent(Explore)"
```

## 使用 subagents

### 自动委托

Claude 根据任务描述和 `description` 字段自动委托。在描述中使用 "use proactively" 等短语鼓励主动委托。

显式调用：

```
Use the test-runner subagent to fix failing tests
```

### 前台 vs 后台

* **前台**：阻塞主对话直到完成，权限提示传递给用户
* **后台**：并发运行，Claude Code 预先提示所需权限

按 **Ctrl+B** 将运行中的任务放到后台。设置 `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1` 禁用后台任务。

### 常见模式

#### 隔离高容量操作

```
Use a subagent to run the test suite and report only the failing tests
```

#### 并行研究

```
Research the authentication, database, and API modules in parallel using separate subagents
```

#### 链接 subagents

```
Use the code-reviewer subagent to find performance issues, then use the optimizer subagent to fix them
```

### 恢复 subagents

每个 subagent 调用创建新的上下文实例。要继续现有 subagent 的工作：

```
Continue that code review and now analyze the authorization logic
```

Subagent 转录存储在 `~/.claude/projects/{project}/{sessionId}/subagents/agent-{agentId}.jsonl`。

## 示例 subagents

### 代码审查者

```markdown
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability.
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer ensuring high standards of code quality and security.

When invoked:
1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:
- Code is clear and readable
- No exposed secrets or API keys
- Input validation implemented
- Good test coverage

Provide feedback organized by priority:
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider improving)
```

### 调试器

```markdown
---
name: debugger
description: Debugging specialist for errors, test failures, and unexpected behavior.
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert debugger specializing in root cause analysis.

When invoked:
1. Capture error message and stack trace
2. Identify reproduction steps
3. Isolate the failure location
4. Implement minimal fix
5. Verify solution works
```

### 数据库查询验证器（带 hook）

```markdown
---
name: db-reader
description: Execute read-only database queries.
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---

You are a database analyst with read-only access. Execute SELECT queries only.
```

验证脚本：

```bash
#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -iE '\b(INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|TRUNCATE)\b' > /dev/null; then
  echo "Blocked: Only SELECT queries are allowed" >&2
  exit 2
fi

exit 0
```

## CLI 定义的 subagents

```bash
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  }
}'
```

## 后续步骤

* [使用 plugins 分发 subagents](/zh-CN/plugins)
* [以编程方式运行 Claude Code](/zh-CN/headless)
* [使用 MCP 服务器](/zh-CN/mcp)
