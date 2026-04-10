# Using Hooks with GitHub Copilot CLI / 在 GitHub Copilot CLI 中使用 Hooks

Hooks enable customization of GitHub Copilot agent behavior by executing shell commands at specific execution points.

Hooks 通过在特定执行点执行 shell 命令来自定义 GitHub Copilot Agent 的行为。

## Overview / 概述

Hooks allow you to extend and customize the behavior of GitHub Copilot agents by executing custom shell commands at key points during agent execution.

Hooks 允许你在 Agent 执行的关键节点通过执行自定义 shell 命令来扩展和自定义 GitHub Copilot Agent 的行为。

## Repository Setup / 仓库设置

To implement hooks:

实现 Hooks 的步骤：

1. Create a `hooks.json` file in your repository's `.github/hooks/` directory. This configuration must exist on your default branch for the Copilot coding agent to use it. For CLI usage, hooks load from your working directory. / 在仓库的 `.github/hooks/` 目录中创建 `hooks.json` 文件。此配置必须存在于默认分支上，供 Copilot 编码 Agent 使用。CLI 使用时，Hooks 从工作目录加载。

2. Use this template structure, removing unused hooks: / 使用此模板结构，删除未使用的 Hooks：

```json
{
  "version": 1,
  "hooks": {
    "sessionStart": [...],
    "sessionEnd": [...],
    "userPromptSubmitted": [...],
    "preToolUse": [...],
    "postToolUse": [...],
    "errorOccurred": [...]
  }
}
```

3. Configure commands using `bash` or `powershell` keys, or reference external scripts. Specify working directory and timeout values as needed. / 使用 `bash` 或 `powershell` 键配置命令，或引用外部脚本。根据需要指定工作目录和超时值。

4. Commit and merge the file to your default branch. / 将文件提交并合并到默认分支。

## Hook Configuration Format / Hook 配置格式

```json
{
  "version": 1,
  "hooks": {
    "hookType": [
      {
        "type": "command",
        "bash": "command",
        "powershell": "command",
        "cwd": "optional/path",
        "env": { "VAR": "value" },
        "timeoutSec": 30
      }
    ]
  }
}
```

### Command Hook Fields / 命令 Hook 字段

| Field / 字段 | Type / 类型 | Required / 必需 | Description / 说明 |
|-------|------|----------|-------------|
| `type` | "command" | Yes / 是 | Must be "command" / 必须为 "command" |
| `bash` | string | One of bash/powershell / 二选一 | Unix command / Unix 命令 |
| `powershell` | string | One of bash/powershell / 二选一 | Windows command / Windows 命令 |
| `cwd` | string | No / 否 | Working directory / 工作目录 |
| `env` | object | No / 否 | Environment variables / 环境变量 |
| `timeoutSec` | number | No / 否 | Timeout in seconds (default: 30) / 超时时间（默认：30） |

## Hook Events / Hook 事件

| Event / 事件 | Triggers When / 触发时机 | Output Processed / 处理输出 |
|-------|---------------|------------------|
| `sessionStart` | New or resumed session / 新建或恢复会话 | No / 否 |
| `sessionEnd` | Session terminates / 会话终止 | No / 否 |
| `userPromptSubmitted` | User submits prompt / 用户提交提示词 | No / 否 |
| `preToolUse` | Before tool execution / 工具执行前 | Yes—can allow/deny/modify / 是—可允许/拒绝/修改 |
| `postToolUse` | After tool completes / 工具完成后 | No / 否 |
| `agentStop` | Main agent finishes turn / 主 Agent 完成轮次 | Yes—can block/continue / 是—可阻止/继续 |
| `subagentStop` | Subagent completes / 子 Agent 完成 | Yes—can block/continue / 是—可阻止/继续 |
| `errorOccurred` | Error during execution / 执行期间出错 | No / 否 |

## Pre-Tool Decision Control / 工具前决策控制

The `preToolUse` hook can output JSON to control execution:

`preToolUse` Hook 可以输出 JSON 来控制执行：

```json
{
  "permissionDecision": "allow|deny|ask",
  "permissionDecisionReason": "Reason for denial",
  "modifiedArgs": { "field": "value" }
}
```

## Agent Stop Decision Control / Agent 停止决策控制

```json
{
  "decision": "block|allow",
  "reason": "Prompt for next turn"
}
```

## Troubleshooting Guide / 故障排查指南

| Problem / 问题 | Solutions / 解决方案 |
|---------|-----------|
| Hooks not executing / Hooks 未执行 | Verify `.github/hooks/` location; validate JSON syntax; confirm `version: 1` present / 验证 `.github/hooks/` 位置；验证 JSON 语法；确认存在 `version: 1` |
| Timeout issues / 超时问题 | Default timeout is 30 seconds; increase `timeoutSec` if necessary / 默认超时为 30 秒，必要时增加 `timeoutSec` |
| Invalid JSON output / JSON 输出无效 | Keep output on single lines; use `jq -c` (Unix) or `ConvertTo-Json -Compress` (PowerShell) / 保持输出在单行；使用 `jq -c`（Unix）或 `ConvertTo-Json -Compress`（PowerShell） |

## Debugging Methods / 调试方法

Enable verbose logging within scripts using `set -x` for bash to trace execution and inspect input data.

在脚本中使用 bash 的 `set -x` 启用详细日志记录，以跟踪执行并检查输入数据。

Test hooks locally by piping sample input and validating JSON output with `jq .` to confirm proper functioning before deployment.

通过管道传输示例输入并使用 `jq .` 验证 JSON 输出来本地测试 Hooks，以在部署前确认其正常工作。
