# Using Hooks with GitHub Copilot CLI

Hooks enable customization of GitHub Copilot agent behavior by executing shell commands at specific execution points.

## Overview

Hooks allow you to extend and customize the behavior of GitHub Copilot agents by executing custom shell commands at key points during agent execution.

## Repository Setup

To implement hooks:

1. Create a `hooks.json` file in your repository's `.github/hooks/` directory. This configuration must exist on your default branch for the Copilot coding agent to use it. For CLI usage, hooks load from your working directory.

2. Use this template structure, removing unused hooks:

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

3. Configure commands using `bash` or `powershell` keys, or reference external scripts. Specify working directory and timeout values as needed.

4. Commit and merge the file to your default branch.

## Hook Configuration Format

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

### Command Hook Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | "command" | Yes | Must be "command" |
| `bash` | string | One of bash/powershell | Unix command |
| `powershell` | string | One of bash/powershell | Windows command |
| `cwd` | string | No | Working directory |
| `env` | object | No | Environment variables |
| `timeoutSec` | number | No | Timeout in seconds (default: 30) |

## Hook Events

| Event | Triggers When | Output Processed |
|-------|---------------|------------------|
| `sessionStart` | New or resumed session | No |
| `sessionEnd` | Session terminates | No |
| `userPromptSubmitted` | User submits prompt | No |
| `preToolUse` | Before tool execution | Yes—can allow/deny/modify |
| `postToolUse` | After tool completes | No |
| `agentStop` | Main agent finishes turn | Yes—can block/continue |
| `subagentStop` | Subagent completes | Yes—can block/continue |
| `errorOccurred` | Error during execution | No |

## Pre-Tool Decision Control

The `preToolUse` hook can output JSON to control execution:

```json
{
  "permissionDecision": "allow|deny|ask",
  "permissionDecisionReason": "Reason for denial",
  "modifiedArgs": { "field": "value" }
}
```

## Agent Stop Decision Control

```json
{
  "decision": "block|allow",
  "reason": "Prompt for next turn"
}
```

## Troubleshooting Guide

| Problem | Solutions |
|---------|-----------|
| Hooks not executing | Verify `.github/hooks/` location; validate JSON syntax; confirm `version: 1` present; ensure scripts are executable with proper shebangs |
| Timeout issues | Default timeout is 30 seconds; increase `timeoutSec` if necessary; optimize script performance |
| Invalid JSON output | Keep output on single lines; use `jq -c` (Unix) or `ConvertTo-Json -Compress` (PowerShell) |

## Debugging Methods

Enable verbose logging within scripts using `set -x` for bash to trace execution and inspect input data.

Test hooks locally by piping sample input and validating JSON output with `jq .` to confirm proper functioning before deployment.
