# Allowing and Denying Tool Use in Copilot CLI / Copilot CLI 工具使用的允许与拒绝

## Overview / 概述

Copilot CLI provides mechanisms to control which tools the system can access, preventing unintended modifications to your environment. The platform distinguishes between safe read-only operations and potentially destructive actions that require approval.

Copilot CLI 提供了控制系统可访问工具的机制，防止对环境的意外修改。平台区分安全的只读操作和需要审批的潜在破坏性操作。

## Two-Layer Control System / 双层控制系统

### Layer 1: Tool Availability / 第一层：工具可用性

The `--available-tools` and `--excluded-tools` flags manage which tools the AI model can even consider using:

`--available-tools` 和 `--excluded-tools` 标志管理 AI 模型可以考虑使用的工具范围：

- `--available-tools` creates an allowlist, disabling everything else / 创建允许列表，禁用其他所有工具
- `--excluded-tools` creates a denylist for specific tools / 为特定工具创建拒绝列表
- When both are specified, the allowlist takes precedence / 两者同时指定时，允许列表优先

**Example / 示例：** To prevent web search during benchmarking / 在基准测试时禁止网络搜索：
```bash
copilot --excluded-tools='web_fetch, web_search'
```

### Layer 2: Permission Management / 第二层：权限管理

The `--allow-tool` and `--deny-tool` flags grant or revoke permission for specific tools:

`--allow-tool` 和 `--deny-tool` 标志授予或撤销特定工具的使用权限：

- Allowed tools execute without prompts / 允许的工具无需弹窗确认即可执行
- Denied tools cannot be used, even if optimal / 被拒绝的工具即使是最优选择也无法使用
- Deny rules supersede allow rules / 拒绝规则优先于允许规则

**Example patterns / 示例模式：**
- `--allow-tool=shell` — all shell commands / 所有 shell 命令
- `--allow-tool='shell(git commit)'` — specific command only / 仅限特定命令
- `--allow-tool='shell(git:*)' --deny-tool='shell(git push)'` — git access excluding push / 允许 git 但排除 push

## Permissive Options / 宽松权限选项

- `--allow-all-tools` — full tool access / 完全工具访问权限
- `--allow-all` or `--yolo` — grants all permissions (use only in isolated environments) / 授予所有权限（仅在隔离环境中使用）
- `/allow-all` or `/yolo` — interactive session equivalents / 交互式会话中的等效命令

## Session Management / 会话管理

The `/reset-allowed-tools` slash command reverts permissions to either defaults or command-line specifications, removing any permissions granted interactively while preserving original startup configurations.

`/reset-allowed-tools` 斜杠命令将权限恢复为默认值或命令行指定值，移除交互式授予的权限，同时保留原始启动配置。
