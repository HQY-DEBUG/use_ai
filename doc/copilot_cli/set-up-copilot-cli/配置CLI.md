# GitHub Copilot CLI Configuration Guide / GitHub Copilot CLI 配置指南

## Overview / 概述

GitHub Copilot CLI provides multiple configuration options to control access and permissions. Users can manage trusted directories, tool usage, file path access, and URL permissions.

GitHub Copilot CLI 提供多种配置选项来控制访问权限。用户可以管理受信任目录、工具使用、文件路径访问和 URL 权限。

## Trusted Directories / 受信任目录

When launching Copilot CLI, users receive a prompt to confirm trust in the current directory. They may approve access for:

启动 Copilot CLI 时，用户会收到提示以确认对当前目录的信任。可以批准以下访问：

- The current session only / 仅限当前会话
- Current and all future sessions / 当前及所有未来会话

### Managing Trusted Directories / 管理受信任目录

Users can edit the `config.json` file located at:

用户可以编辑以下位置的 `config.json` 文件：

- **macOS/Linux**: `~/.copilot/config.json`
- **Windows**: `$HOME\.copilot\config.json`

The `COPILOT_HOME` environment variable allows customizing the config location.

`COPILOT_HOME` 环境变量允许自定义配置文件位置。

## Tool Access Control / 工具访问控制

Copilot CLI requires approval before using certain tools like `touch`, `chmod`, `node`, or `sed`. Users have three response options:

Copilot CLI 在使用 `touch`、`chmod`、`node` 或 `sed` 等工具前需要批准。用户有三种响应选项：

1. **Yes / 是** – Allow for this instance only / 仅允许此次
2. **Yes, and approve for session / 是，并批准整个会话** – Allow throughout current session / 在当前会话中全程允许
3. **No / 否** – Reject and request alternative approach / 拒绝并要求替代方案

### Command-Line Flags for Tools / 工具命令行标志

- `--allow-all-tools` – Skip all tool approvals / 跳过所有工具审批
- `--allow-tool='TOOL_TYPE'` – Pre-approve specific tools / 预批准特定工具
- `--deny-tool='TOOL_TYPE'` – Block specific tools / 阻止特定工具
- `--available-tools` – Restrict to designated tools only / 仅限于指定工具

### Tool Specification Types / 工具规范类型

- **Shell commands / Shell 命令**: `shell(COMMAND)` or `shell(git push)`
- **Write operations / 写操作**: `'write'`
- **MCP servers / MCP 服务器**: `'MCP_SERVER_NAME(tool_name)'`

## Path Permissions / 路径权限

By default, Copilot can access the current working directory, subdirectories, and system temp directory.

默认情况下，Copilot 可以访问当前工作目录、子目录和系统临时目录。

- `--allow-all-paths` – Disable path verification / 禁用路径验证
- `--disallow-temp-dir` – Block temp directory access / 阻止临时目录访问

## URL Permissions / URL 权限

All external URLs require approval by default.

默认情况下，所有外部 URL 都需要批准。

- `--allow-all-urls` – Skip URL verification / 跳过 URL 验证
- `--allow-url=DOMAIN` – Pre-approve specific domains / 预批准特定域名
- `--deny-url=DOMAIN` – Block specific domains / 阻止特定域名

## Comprehensive Permission Flags / 综合权限标志

The `--allow-all` or `--yolo` flag combines all permissive settings. Interactive sessions also support `/allow-all` and `/yolo` commands.

`--allow-all` 或 `--yolo` 标志组合了所有宽松设置。交互式会话同样支持 `/allow-all` 和 `/yolo` 命令。
