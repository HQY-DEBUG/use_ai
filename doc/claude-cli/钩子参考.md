# Hooks 参考

> Claude Code hook 事件、配置架构、JSON 输入/输出格式、退出代码、异步 hooks、HTTP hooks、提示 hooks 和 MCP 工具 hooks 的参考。

> **提示**：有关包含示例的快速入门指南，请参阅[使用 hooks 自动化工作流](/zh-CN/hooks-guide)。

Hooks 是用户定义的 shell 命令、HTTP 端点或 LLM 提示，在 Claude Code 生命周期中的特定点自动执行。使用此参考查找事件架构、配置选项、JSON 输入/输出格式以及异步 hooks、HTTP hooks 和 MCP 工具 hooks 等高级功能。如果您是第一次设置 hooks，请改为从指南开始。

## Hook 生命周期

Hooks 在 Claude Code 会话期间的特定点触发。当事件触发且匹配器匹配时，Claude Code 会将关于该事件的 JSON 上下文传递给您的 hook 处理程序。对于命令 hooks，输入通过 stdin 到达。对于 HTTP hooks，它作为 POST 请求体到达。您的处理程序随后可以检查输入、采取行动并可选地返回决定。某些事件每个会话触发一次，而其他事件在代理循环内重复触发。

下表总结了每个事件何时触发：

| Event                | When it fires                                                                                                                                  |
| :------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------- |
| `SessionStart`       | When a session begins or resumes                                                                                                               |
| `UserPromptSubmit`   | When you submit a prompt, before Claude processes it                                                                                           |
| `PreToolUse`         | Before a tool call executes. Can block it                                                                                                      |
| `PermissionRequest`  | When a permission dialog appears                                                                                                               |
| `PostToolUse`        | After a tool call succeeds                                                                                                                     |
| `PostToolUseFailure` | After a tool call fails                                                                                                                        |
| `Notification`       | When Claude Code sends a notification                                                                                                          |
| `SubagentStart`      | When a subagent is spawned                                                                                                                     |
| `SubagentStop`       | When a subagent finishes                                                                                                                       |
| `Stop`               | When Claude finishes responding                                                                                                                |
| `StopFailure`        | When the turn ends due to an API error. Output and exit code are ignored                                                                       |
| `TeammateIdle`       | When an agent team teammate is about to go idle                                                                                                |
| `TaskCompleted`      | When a task is being marked as completed                                                                                                       |
| `InstructionsLoaded` | When a CLAUDE.md or `.claude/rules/*.md` file is loaded into context. Fires at session start and when files are lazily loaded during a session |
| `ConfigChange`       | When a configuration file changes during a session                                                                                             |
| `WorktreeCreate`     | When a worktree is being created via `--worktree` or `isolation: "worktree"`. Replaces default git behavior                                    |
| `WorktreeRemove`     | When a worktree is being removed, either at session exit or when a subagent finishes                                                           |
| `PreCompact`         | Before context compaction                                                                                                                      |
| `PostCompact`        | After context compaction completes                                                                                                             |
| `Elicitation`        | When an MCP server requests user input during a tool call                                                                                      |
| `ElicitationResult`  | After a user responds to an MCP elicitation, before the response is sent back to the server                                                    |
| `SessionEnd`         | When a session terminates                                                                                                                      |

### Hook 如何解析

要了解这些部分如何组合在一起，请考虑这个 `PreToolUse` hook，它阻止破坏性 shell 命令。该 hook 在每个 Bash 工具调用之前运行 `block-rm.sh`：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/block-rm.sh"
          }
        ]
      }
    ]
  }
}
```

该脚本从 stdin 读取 JSON 输入，提取命令，如果包含 `rm -rf`，则返回 `permissionDecision` 为 `"deny"`：

```bash
#!/bin/bash
# .claude/hooks/block-rm.sh
COMMAND=$(jq -r '.tool_input.command')

if echo "$COMMAND" | grep -q 'rm -rf'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Destructive command blocked by hook"
    }
  }'
else
  exit 0  # allow the command
fi
```

现在假设 Claude Code 决定运行 `Bash "rm -rf /tmp/build"`。以下是发生的情况：

**步骤 1 - 事件触发**：`PreToolUse` 事件触发。Claude Code 将工具输入作为 JSON 通过 stdin 发送到 hook：
```json
{ "tool_name": "Bash", "tool_input": { "command": "rm -rf /tmp/build" }, ... }
```

**步骤 2 - 匹配器检查**：匹配器 `"Bash"` 与工具名称匹配，因此 `block-rm.sh` 运行。如果您省略匹配器或使用 `"*"`，hook 在事件的每次出现时运行。仅当定义了匹配器且不匹配时，hooks 才会跳过。

**步骤 3 - Hook 处理程序运行**：脚本从输入中提取 `"rm -rf /tmp/build"` 并找到 `rm -rf`，因此它将决定打印到 stdout：
```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Destructive command blocked by hook"
  }
}
```
如果命令是安全的（如 `npm test`），脚本将改为执行 `exit 0`，这告诉 Claude Code 允许工具调用而无需进一步操作。

**步骤 4 - Claude Code 对结果采取行动**：Claude Code 读取 JSON 决定，阻止工具调用，并向 Claude 显示原因。

## 配置

Hooks 在 JSON 设置文件中定义。配置有三个嵌套级别：

1. 选择要响应的 hook 事件，如 `PreToolUse` 或 `Stop`
2. 添加匹配器组以过滤何时触发，如"仅针对 Bash 工具"
3. 定义一个或多个 hook 处理程序以在匹配时运行

> **注意**：此页面为每个级别使用特定术语：**hook 事件**表示生命周期点，**匹配器组**表示过滤器，**hook 处理程序**表示运行的 shell 命令、HTTP 端点、提示或代理。"Hook"本身指的是一般功能。

### Hook 位置

您定义 hook 的位置决定了其范围：

| 位置                                          | 范围     | 可共享          |
| :------------------------------------------ | :----- | :----------- |
| `~/.claude/settings.json`                   | 您的所有项目 | 否，本地于您的计算机   |
| `.claude/settings.json`                     | 单个项目   | 是，可以提交到仓库    |
| `.claude/settings.local.json`               | 单个项目   | 否，gitignored |
| 托管策略设置                                      | 组织范围   | 是，管理员控制      |
| Plugin `hooks/hooks.json`                   | 启用插件时  | 是，与插件捆绑      |
| Skill 或代理 frontmatter                       | 组件活跃时  | 是，在组件文件中定义   |

### 匹配器模式

`matcher` 字段是一个正则表达式字符串，用于过滤 hooks 何时触发。使用 `"*"`、`""` 或完全省略 `matcher` 以匹配所有出现。每个事件类型在不同的字段上匹配：

| 事件                                                                                                              | 匹配器过滤的内容 | 示例匹配器值                                                                         |
| :-------------------------------------------------------------------------------------------------------------- | :------- | :----------------------------------------------------------------------------- |
| `PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`                                             | 工具名称     | `Bash`、`Edit\|Write`、`mcp__.*`                                                 |
| `SessionStart`                                                                                                  | 会话如何启动   | `startup`、`resume`、`clear`、`compact`                                           |
| `SessionEnd`                                                                                                    | 会话为何结束   | `clear`、`logout`、`prompt_input_exit`、`bypass_permissions_disabled`、`other`     |
| `Notification`                                                                                                  | 通知类型     | `permission_prompt`、`idle_prompt`、`auth_success`、`elicitation_dialog`          |
| `SubagentStart`                                                                                                 | 代理类型     | `Bash`、`Explore`、`Plan` 或自定义代理名称                                               |
| `PreCompact`                                                                                                    | 触发压缩的原因  | `manual`、`auto`                                                                |
| `SubagentStop`                                                                                                  | 代理类型     | 与 `SubagentStart` 相同的值                                                         |
| `ConfigChange`                                                                                                  | 配置源      | `user_settings`、`project_settings`、`local_settings`、`policy_settings`、`skills` |
| `UserPromptSubmit`、`Stop`、`TeammateIdle`、`TaskCompleted`、`WorktreeCreate`、`WorktreeRemove`、`InstructionsLoaded` | 不支持匹配器   | 总是在每次出现时触发                                                                     |

此示例仅在 Claude 写入或编辑文件时运行 linting 脚本：

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/lint-check.sh"
          }
        ]
      }
    ]
  }
}
```

#### 匹配 MCP 工具

MCP 服务器工具在工具事件中显示为常规工具（`PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`PermissionRequest`），因此您可以像匹配任何其他工具名称一样匹配它们。

MCP 工具遵循命名模式 `mcp__<server>__<tool>`，例如：

* `mcp__memory__create_entities`：Memory 服务器的创建实体工具
* `mcp__filesystem__read_file`：Filesystem 服务器的读取文件工具
* `mcp__github__search_repositories`：GitHub 服务器的搜索工具

使用正则表达式模式来针对特定 MCP 工具或工具组：

* `mcp__memory__.*` 匹配来自 `memory` 服务器的所有工具
* `mcp__.*__write.*` 匹配来自任何服务器的任何包含"write"的工具

### Hook 处理程序字段

内部 `hooks` 数组中的每个对象都是一个 hook 处理程序。有四种类型：

* **命令 hooks**（`type: "command"`）：运行 shell 命令。您的脚本在 stdin 上接收事件的 JSON 输入，并通过退出代码和 stdout 传回结果。
* **HTTP hooks**（`type: "http"`）：将事件的 JSON 输入作为 HTTP POST 请求发送到 URL。端点通过使用与命令 hooks 相同的 JSON 输出格式的响应体传回结果。
* **提示 hooks**（`type: "prompt"`）：向 Claude 模型发送提示以进行单轮评估。模型返回 yes/no 决定作为 JSON。
* **代理 hooks**（`type: "agent"`）：生成一个可以使用 Read、Grep 和 Glob 等工具来验证条件的 subagent，然后返回决定。

#### 通用字段

这些字段适用于所有 hook 类型：

| 字段              | 必需 | 描述                                                                                             |
| :-------------- | :- | :--------------------------------------------------------------------------------------------- |
| `type`          | 是  | `"command"`、`"http"`、`"prompt"` 或 `"agent"`                                                    |
| `timeout`       | 否  | 取消前的秒数。默认值：命令 600、提示 30、代理 60                                                                  |
| `statusMessage` | 否  | hook 运行时显示的自定义加载程序消息                                                                           |
| `once`          | 否  | 如果为 `true`，每个会话仅运行一次，然后被移除。仅限 skills，不是代理 |

#### 命令 hook 字段

除了通用字段外，命令 hooks 还接受这些字段：

| 字段        | 必需 | 描述                                                                  |
| :-------- | :- | :------------------------------------------------------------------ |
| `command` | 是  | 要执行的 shell 命令                                                       |
| `async`   | 否  | 如果为 `true`，在后台运行而不阻止 |

#### HTTP hook 字段

除了通用字段外，HTTP hooks 还接受这些字段：

| 字段               | 必需 | 描述                                                                                      |
| :--------------- | :- | :-------------------------------------------------------------------------------------- |
| `url`            | 是  | 发送 POST 请求的 URL                                                                         |
| `headers`        | 否  | 其他 HTTP 标头作为键值对。值支持使用 `$VAR_NAME` 或 `${VAR_NAME}` 语法的环境变量插值。仅解析 `allowedEnvVars` 中列出的变量 |
| `allowedEnvVars` | 否  | 可能被插值到标头值中的环境变量名称列表 |

#### 提示和代理 hook 字段

除了通用字段外，提示和代理 hooks 还接受这些字段：

| 字段       | 必需 | 描述                                               |
| :------- | :- | :----------------------------------------------- |
| `prompt` | 是  | 要发送给模型的提示文本。使用 `$ARGUMENTS` 作为 hook 输入 JSON 的占位符 |
| `model`  | 否  | 用于评估的模型。默认为快速模型                                  |

### 按路径引用脚本

使用环境变量按项目或插件根目录引用 hook 脚本：

* `$CLAUDE_PROJECT_DIR`：项目根目录。用引号包装以处理包含空格的路径。
* `${CLAUDE_PLUGIN_ROOT}`：插件的根目录，用于与插件捆绑的脚本。

项目脚本示例：
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/check-style.sh"
          }
        ]
      }
    ]
  }
}
```

### Skills 和代理中的 Hooks

除了设置文件和插件外，hooks 还可以使用 frontmatter 直接在 skills 和 subagents 中定义。这些 hooks 的范围限于组件的生命周期，仅在该组件活跃时运行。

此 skill 定义了一个 `PreToolUse` hook：

```yaml
---
name: secure-operations
description: Perform operations with security checks
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh"
---
```

### `/hooks` 菜单

在 Claude Code 中键入 `/hooks` 以打开您配置的 hooks 的只读浏览器。菜单显示每个 hook 事件及其配置的 hooks 计数，让您深入了解匹配器，并显示每个 hook 处理程序的完整详细信息。

菜单显示所有四种 hook 类型：`command`、`prompt`、`agent` 和 `http`。每个 hook 都标有 `[type]` 前缀和指示其定义位置的源：`User`、`Project`、`Local`、`Plugin`、`Session`、`Built-in`。

### 禁用或移除 hooks

要移除 hook，请从设置 JSON 文件中删除其条目。

要临时禁用所有 hooks 而不移除它们，请在设置文件中设置 `"disableAllHooks": true`。

## Hook 输入和输出

命令 hooks 通过 stdin 接收 JSON 数据，并通过退出代码、stdout 和 stderr 传回结果。HTTP hooks 接收相同的 JSON 作为 POST 请求体，并通过 HTTP 响应体传回结果。

### 通用输入字段

所有 hook 事件都接收这些字段作为 JSON：

| 字段                | 描述                                                                                                                     |
| :---------------- | :--------------------------------------------------------------------------------------------------------------------- |
| `session_id`      | 当前会话标识符                                                                                                                |
| `transcript_path` | 对话 JSON 的路径                                                                                                            |
| `cwd`             | 调用 hook 时的当前工作目录                                                                                                       |
| `permission_mode` | 当前权限模式：`"default"`、`"plan"`、`"acceptEdits"`、`"dontAsk"` 或 `"bypassPermissions"` |
| `hook_event_name` | 触发的事件名称                                                                                                                |

使用 `--agent` 运行或在 subagent 内部时，包括两个额外字段：

| 字段           | 描述                                                                                                                                 |
| :----------- | :--------------------------------------------------------------------------------------------------------------------------------- |
| `agent_id`   | Subagent 的唯一标识符                                                                                                                   |
| `agent_type` | 代理名称（例如，`"Explore"` 或 `"security-reviewer"`） |

### 退出代码输出

**退出 0** 表示成功。Claude Code 解析 stdout 以获取 JSON 输出字段。

**退出 2** 表示阻止错误。Claude Code 忽略 stdout 和其中的任何 JSON。相反，stderr 文本被反馈给 Claude 作为错误消息。

**任何其他退出代码** 是非阻止错误。stderr 在详细模式中显示，执行继续。

示例：

```bash
#!/bin/bash
# 从 stdin 读取 JSON 输入，检查命令
command=$(jq -r '.tool_input.command' < /dev/stdin)

if [[ "$command" == rm* ]]; then
  echo "Blocked: rm commands are not allowed" >&2
  exit 2  # 阻止错误：工具调用被阻止
fi

exit 0  # 成功：工具调用继续
```

#### 每个事件的退出代码 2 行为

| Hook 事件              | 可以阻止？ | 退出 2 时发生的情况                    |
| :------------------- | :---- | :----------------------------- |
| `PreToolUse`         | 是     | 阻止工具调用                         |
| `PermissionRequest`  | 是     | 拒绝权限                           |
| `UserPromptSubmit`   | 是     | 阻止提示处理并从上下文中删除提示               |
| `Stop`               | 是     | 防止 Claude 停止，继续对话              |
| `SubagentStop`       | 是     | 防止 subagent 停止                 |
| `TeammateIdle`       | 是     | 防止队友空闲（队友继续工作）                 |
| `TaskCompleted`      | 是     | 防止任务被标记为已完成                    |
| `ConfigChange`       | 是     | 阻止配置更改生效（除了 `policy_settings`） |
| `PostToolUse`        | 否     | 向 Claude 显示 stderr（工具已运行）      |
| `PostToolUseFailure` | 否     | 向 Claude 显示 stderr（工具已失败）      |
| `Notification`       | 否     | 仅向用户显示 stderr                  |
| `SubagentStart`      | 否     | 仅向用户显示 stderr                  |
| `SessionStart`       | 否     | 仅向用户显示 stderr                  |
| `SessionEnd`         | 否     | 仅向用户显示 stderr                  |
| `PreCompact`         | 否     | 仅向用户显示 stderr                  |
| `PostCompact`        | 否     | 仅向用户显示 stderr                  |
| `Elicitation`        | 是     | 拒绝 elicitation                 |
| `ElicitationResult`  | 是     | 阻止响应（操作变为 decline）             |
| `WorktreeCreate`     | 是     | 任何非零退出代码都会导致 worktree 创建失败     |
| `WorktreeRemove`     | 否     | 失败仅在调试模式下记录                    |
| `InstructionsLoaded` | 否     | 退出代码被忽略                        |

### JSON 输出

退出代码让您允许或阻止，但 JSON 输出提供更细粒度的控制。与其使用代码 2 退出来阻止，不如退出 0 并将 JSON 对象打印到 stdout。

> **注意**：您必须为每个 hook 选择一种方法，而不是两种：要么单独使用退出代码进行信号传递，要么退出 0 并打印 JSON 以进行结构化控制。Claude Code 仅在退出 0 时处理 JSON。如果您退出 2，任何 JSON 都会被忽略。

JSON 对象支持三种字段：

| 字段               | 默认      | 描述                                                   |
| :--------------- | :------ | :--------------------------------------------------- |
| `continue`       | `true`  | 如果为 `false`，Claude 在 hook 运行后完全停止处理   |
| `stopReason`     | 无       | hook 运行后 `continue` 为 `false` 时向用户显示的消息 |
| `suppressOutput` | `false` | 如果为 `true`，从详细模式输出中隐藏 stdout                         |
| `systemMessage`  | 无       | 向用户显示的警告消息                                           |

要无论事件类型如何都完全停止 Claude：

```json
{ "continue": false, "stopReason": "Build failed, fix errors before continuing" }
```

#### 决定控制

| 事件                                                                               | 决定模式                    | 关键字段                                                                                               |
| :------------------------------------------------------------------------------- | :---------------------- | :------------------------------------------------------------------------------------------------- |
| UserPromptSubmit、PostToolUse、PostToolUseFailure、Stop、SubagentStop、ConfigChange   | 顶级 `decision`           | `decision: "block"`、`reason`                                                                       |
| TeammateIdle、TaskCompleted                                                       | 退出代码或 `continue: false` | 退出代码 2 使用 stderr 反馈阻止操作 |
| PreToolUse                                                                       | `hookSpecificOutput`    | `permissionDecision`（allow/deny/ask）、`permissionDecisionReason`                                    |
| PermissionRequest                                                                | `hookSpecificOutput`    | `decision.behavior`（allow/deny）                                                                    |
| WorktreeCreate                                                                   | stdout 路径               | Hook 打印创建的 worktree 的绝对路径 |
| Elicitation                                                                      | `hookSpecificOutput`    | `action`（accept/decline/cancel）                                                                    |
| ElicitationResult                                                                | `hookSpecificOutput`    | `action`（accept/decline/cancel）                                                                    |
| WorktreeRemove、Notification、SessionEnd、PreCompact、PostCompact、InstructionsLoaded | 无                       | 无决定控制 |

## Hook 事件

### SessionStart

在 Claude Code 启动新会话或恢复现有会话时运行。SessionStart 在每个会话上运行，因此保持这些 hooks 快速。仅支持 `type: "command"` hooks。

匹配器值对应于会话的启动方式：

| 匹配器       | 何时触发                                |
| :-------- | :---------------------------------- |
| `startup` | 新会话                                 |
| `resume`  | `--resume`、`--continue` 或 `/resume` |
| `clear`   | `/clear`                            |
| `compact` | 自动或手动压缩                             |

#### SessionStart 输入

```json
{
  "session_id": "abc123",
  "transcript_path": "/Users/.../.claude/projects/.../00893aaf.jsonl",
  "cwd": "/Users/...",
  "permission_mode": "default",
  "hook_event_name": "SessionStart",
  "source": "startup",
  "model": "claude-sonnet-4-6"
}
```

SessionStart 还支持 `additionalContext` 字段和持久化环境变量（通过 `CLAUDE_ENV_FILE`）。

### InstructionsLoaded

当 `CLAUDE.md` 或 `.claude/rules/*.md` 文件加载到上下文中时触发。该 hook 不支持阻止或决定控制。它异步运行以用于可观测性目的。

#### InstructionsLoaded 输入

| 字段                  | 描述                                                                                |
| :------------------ | :-------------------------------------------------------------------------------- |
| `file_path`         | 加载的指令文件的绝对路径                                                                      |
| `memory_type`       | 文件的范围：`"User"`、`"Project"`、`"Local"` 或 `"Managed"`                                |
| `load_reason`       | 文件被加载的原因：`"session_start"`、`"nested_traversal"`、`"path_glob_match"` 或 `"include"` |
| `globs`             | 文件 `paths:` frontmatter 中的路径 glob 模式（如果有）                                        |
| `trigger_file_path` | 触发此加载的文件的路径，用于懒加载                                                                 |
| `parent_file_path`  | 包含此文件的父指令文件的路径，用于 `include` 加载                                                    |

### UserPromptSubmit

在用户提交提示时运行，在 Claude 处理之前。这允许您根据提示/对话添加额外上下文、验证提示或阻止某些类型的提示。

有两种方法可以在退出代码 0 时向对话添加上下文：
* **纯文本 stdout**：写入 stdout 的任何非 JSON 文本都作为上下文添加
* **带 `additionalContext` 的 JSON**：使用 JSON 格式以获得更多控制

要阻止提示，返回一个 JSON 对象，其中 `decision` 设置为 `"block"`：

```json
{
  "decision": "block",
  "reason": "Explanation for decision",
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "My additional context here"
  }
}
```

### PreToolUse

在 Claude 创建工具参数后和处理工具调用之前运行。在工具名称上匹配：`Bash`、`Edit`、`Write`、`Read`、`Glob`、`Grep`、`Agent`、`WebFetch`、`WebSearch` 和任何 MCP 工具名称。

#### PreToolUse 工具输入字段

**Bash**：`command`（string）、`description`（string）、`timeout`（number）、`run_in_background`（boolean）

**Write**：`file_path`（string）、`content`（string）

**Edit**：`file_path`（string）、`old_string`（string）、`new_string`（string）、`replace_all`（boolean）

**Read**：`file_path`（string）、`offset`（number）、`limit`（number）

**Glob**：`pattern`（string）、`path`（string）

**Grep**：`pattern`（string）、`path`（string）、`glob`（string）、`output_mode`（string）、`-i`（boolean）、`multiline`（boolean）

**WebFetch**：`url`（string）、`prompt`（string）

**WebSearch**：`query`（string）、`allowed_domains`（array）、`blocked_domains`（array）

**Agent**：`prompt`（string）、`description`（string）、`subagent_type`（string）、`model`（string）

#### PreToolUse 决定控制

`PreToolUse` hooks 在 `hookSpecificOutput` 对象内返回其决定：

| 字段                         | 描述                                                                |
| :------------------------- | :---------------------------------------------------------------- |
| `permissionDecision`       | `"allow"` 绕过权限系统，`"deny"` 防止工具调用，`"ask"` 提示用户确认                   |
| `permissionDecisionReason` | 对于 `"allow"` 和 `"ask"`，向用户显示。对于 `"deny"`，向 Claude 显示 |
| `updatedInput`             | 在执行前修改工具的输入参数                                                     |
| `additionalContext`        | 在工具执行前添加到 Claude 上下文的字符串                                          |

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "My reason here",
    "updatedInput": {
      "field_to_modify": "new value"
    },
    "additionalContext": "Current environment: production. Proceed with caution."
  }
}
```

### PermissionRequest

在向用户显示权限对话框时运行。在工具名称上匹配，与 PreToolUse 相同的值。

#### PermissionRequest 决定控制

| 字段                   | 描述                                                                             |
| :------------------- | :----------------------------------------------------------------------------- |
| `behavior`           | `"allow"` 授予权限，`"deny"` 拒绝它                                                    |
| `updatedInput`       | 仅对 `"allow"`：在执行前修改工具的输入参数                                                     |
| `updatedPermissions` | 仅对 `"allow"`：应用权限规则更新                                                          |
| `message`            | 仅对 `"deny"`：告诉 Claude 为什么权限被拒绝                                                 |
| `interrupt`          | 仅对 `"deny"`：如果为 `true`，停止 Claude                                               |

#### 权限更新条目

`updatedPermissions` 输出字段使用条目数组，每个条目有 `type`、相关字段和 `destination`：

| `type`              | 效果                                          |
| :------------------ | :------------------------------------------ |
| `addRules`          | 添加权限规则                                      |
| `replaceRules`      | 替换指定 behavior 的所有规则                         |
| `removeRules`       | 移除给定 behavior 的匹配规则                          |
| `setMode`           | 更改权限模式                                      |
| `addDirectories`    | 添加工作目录                                      |
| `removeDirectories` | 移除工作目录                                      |

`destination` 可以是 `session`、`localSettings`、`projectSettings` 或 `userSettings`。

### PostToolUse

在工具成功完成后立即运行。在工具名称上匹配，与 PreToolUse 相同的值。

#### PostToolUse 决定控制

| 字段                     | 描述                                        |
| :--------------------- | :---------------------------------------- |
| `decision`             | `"block"` 用 `reason` 提示 Claude              |
| `reason`               | 当 `decision` 为 `"block"` 时向 Claude 显示的解释  |
| `additionalContext`    | Claude 要考虑的额外上下文                          |
| `updatedMCPToolOutput` | 仅对 MCP 工具：用提供的值替换工具的输出                   |

### PostToolUseFailure

当工具执行失败时运行。在工具名称上匹配，与 PreToolUse 相同的值。

### Notification

在 Claude Code 发送通知时运行。在通知类型上匹配：`permission_prompt`、`idle_prompt`、`auth_success`、`elicitation_dialog`。

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "permission_prompt",
        "hooks": [{ "type": "command", "command": "/path/to/permission-alert.sh" }]
      },
      {
        "matcher": "idle_prompt",
        "hooks": [{ "type": "command", "command": "/path/to/idle-notification.sh" }]
      }
    ]
  }
}
```

### SubagentStart

当通过 Agent 工具生成 Claude Code subagent 时运行。支持按代理类型名称过滤。SubagentStart hooks 无法阻止 subagent 创建，但可以向 subagent 注入上下文。

### SubagentStop

当 Claude Code subagent 完成响应时运行。在代理类型上匹配，与 SubagentStart 相同的值。

SubagentStop hooks 使用与 Stop hooks 相同的决定控制格式。

### Stop

在主 Claude Code 代理完成响应时运行。如果停止是由于用户中断，则不运行。

#### Stop 决定控制

| 字段         | 描述                                              |
| :--------- | :---------------------------------------------- |
| `decision` | `"block"` 防止 Claude 停止                          |
| `reason`   | 当 `decision` 为 `"block"` 时必需。告诉 Claude 为什么它应该继续 |

```json
{
  "decision": "block",
  "reason": "Must be provided when Claude is blocked from stopping"
}
```

### TeammateIdle

当代理团队队友在完成其轮次后即将空闲时运行。支持两种控制方式：
* **退出代码 2**：队友接收 stderr 消息作为反馈并继续工作
* **JSON `{"continue": false, "stopReason": "..."}`**：完全停止队友

### TaskCompleted

当任务被标记为已完成时运行。支持两种控制方式：
* **退出代码 2**：任务不被标记为已完成，stderr 消息作为反馈反馈给模型
* **JSON `{"continue": false, "stopReason": "..."}`**：完全停止队友

### ConfigChange

当会话期间配置文件更改时运行。匹配器在配置源上过滤：

| 匹配器                | 何时触发                             |
| :----------------- | :------------------------------- |
| `user_settings`    | `~/.claude/settings.json` 更改     |
| `project_settings` | `.claude/settings.json` 更改       |
| `local_settings`   | `.claude/settings.local.json` 更改 |
| `policy_settings`  | 托管策略设置更改                         |
| `skills`           | `.claude/skills/` 中的 skill 文件更改  |

### WorktreeCreate

当您运行 `claude --worktree` 或 subagent 使用 `isolation: "worktree"` 时，Claude Code 使用 `git worktree` 创建隔离的工作副本。如果您配置 WorktreeCreate hook，它替换默认的 git 行为。

Hook 必须在 stdout 上打印创建的 worktree 目录的绝对路径。

```json
{
  "hooks": {
    "WorktreeCreate": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'NAME=$(jq -r .name); DIR=\"$HOME/.claude/worktrees/$NAME\"; svn checkout https://svn.example.com/repo/trunk \"$DIR\" >&2 && echo \"$DIR\"'"
          }
        ]
      }
    ]
  }
}
```

### WorktreeRemove

WorktreeCreate 的清理对应物。在 worktree 被移除时触发。对非 git 版本控制系统，将其与 WorktreeCreate hook 配对以处理清理。

### PreCompact 和 PostCompact

在 Claude Code 即将运行压缩操作之前（PreCompact）和完成压缩操作后（PostCompact）运行。

匹配器值：

| 匹配器      | 何时触发      |
| :------- | :--------- |
| `manual` | `/compact` |
| `auto`   | 上下文窗口满时自动压缩 |

### SessionEnd

当 Claude Code 会话结束时运行。支持按退出原因过滤。

退出原因：

| 原因                            | 描述                 |
| :---------------------------- | :----------------- |
| `clear`                       | 使用 `/clear` 命令清除   |
| `logout`                      | 用户登出               |
| `prompt_input_exit`           | 用户在提示输入可见时退出       |
| `bypass_permissions_disabled` | 绕过权限模式被禁用          |
| `other`                       | 其他退出原因             |

SessionEnd hooks 的默认超时为 1.5 秒。要增加超时：

```bash
CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS=5000 claude
```

### Elicitation

当 MCP 服务器在任务中途请求用户输入时运行。Hooks 可以拦截此请求并以编程方式响应：

```json
{
  "hookSpecificOutput": {
    "hookEventName": "Elicitation",
    "action": "accept",
    "content": {
      "username": "alice"
    }
  }
}
```

`action` 可以是 `accept`、`decline` 或 `cancel`。

### ElicitationResult

在用户响应 MCP elicitation 后运行。Hooks 可以观察、修改或阻止响应。

## 基于提示的 Hooks

基于提示的 hooks（`type: "prompt"`）使用 LLM 来评估是否允许或阻止操作。

支持所有四种 hook 类型的事件：`PermissionRequest`、`PostToolUse`、`PostToolUseFailure`、`PreToolUse`、`Stop`、`SubagentStop`、`TaskCompleted`、`UserPromptSubmit`。

仅支持 `type: "command"` 的事件：`ConfigChange`、`Elicitation`、`ElicitationResult`、`InstructionsLoaded`、`Notification`、`PostCompact`、`PreCompact`、`SessionEnd`、`SessionStart`、`SubagentStart`、`TeammateIdle`、`WorktreeCreate`、`WorktreeRemove`。

### 提示 hook 配置

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Evaluate if Claude should stop: $ARGUMENTS. Check if all tasks are complete."
          }
        ]
      }
    ]
  }
}
```

LLM 必须使用包含以下内容的 JSON 响应：

```json
{
  "ok": true | false,
  "reason": "Explanation for the decision"
}
```

### 示例：多条件 Stop hook

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "You are evaluating whether Claude should stop working. Context: $ARGUMENTS\n\nAnalyze the conversation and determine if:\n1. All user-requested tasks are complete\n2. Any errors need to be addressed\n3. Follow-up work is needed\n\nRespond with JSON: {\"ok\": true} to allow stopping, or {\"ok\": false, \"reason\": \"your explanation\"} to continue working.",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

## 基于代理的 Hooks

基于代理的 hooks（`type: "agent"`）类似于基于提示的 hooks，但具有多轮工具访问。代理 hook 生成一个可以读取文件、搜索代码和检查代码库以验证条件的 subagent。

当代理 hook 触发时，Claude Code 生成一个 subagent，带有您的提示和 hook 的 JSON 输入，subagent 可以使用 Read、Grep 和 Glob 等工具进行调查，在最多 50 轮后，subagent 返回结构化的 `{ "ok": true/false }` 决定。

| 字段        | 必需 | 描述                                               |
| :-------- | :- | :----------------------------------------------- |
| `type`    | 是  | 必须是 `"agent"`                                    |
| `prompt`  | 是  | 描述要验证的内容的提示                                       |
| `model`   | 否  | 要使用的模型。默认为快速模型                                   |
| `timeout` | 否  | 超时（秒）。默认值：60                                     |

## 在后台运行 Hooks

设置 `"async": true` 以在后台运行 hook，同时 Claude 继续工作。异步 hooks 无法阻止或控制 Claude 的行为。

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/run-tests.sh",
            "async": true,
            "timeout": 120
          }
        ]
      }
    ]
  }
}
```

### 限制

* 仅 `type: "command"` hooks 支持 `async`
* 异步 hooks 无法阻止工具调用或返回决定
* Hook 输出在下一个对话轮次传递

## 安全考虑

> **警告**：命令 hooks 使用您的完整用户权限执行 shell 命令。它们可以修改、删除或访问您的用户帐户可以访问的任何文件。在将任何 hook 命令添加到您的配置之前，请审查并测试它们。

安全最佳实践：

* **验证和清理输入**：永远不要盲目信任输入数据
* **始终引用 shell 变量**：使用 `"$VAR"` 而不是 `$VAR`
* **阻止路径遍历**：检查文件路径中的 `..`
* **使用绝对路径**：为脚本指定完整路径，使用 `"$CLAUDE_PROJECT_DIR"` 作为项目根目录
* **跳过敏感文件**：避免 `.env`、`.git/`、密钥等

## 调试 Hooks

运行 `claude --debug` 以查看 hook 执行详细信息，包括哪些 hooks 匹配、它们的退出代码和输出。使用 `Ctrl+O` 切换详细模式以在成绩单中查看 hook 进度。

```text
[DEBUG] Executing hooks for PostToolUse:Write
[DEBUG] Getting matching hook commands for PostToolUse with query: Write
[DEBUG] Found 1 hook matchers in settings
[DEBUG] Matched 1 hooks for query "Write"
[DEBUG] Found 1 hook commands to execute
[DEBUG] Executing hook command: <Your command> with timeout 600000ms
[DEBUG] Hook command completed with status 0: <Your stdout>
```
