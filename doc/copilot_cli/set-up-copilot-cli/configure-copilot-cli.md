# GitHub Copilot CLI Configuration Guide

## Overview

GitHub Copilot CLI provides multiple configuration options to control access and permissions. Users can manage trusted directories, tool usage, file path access, and URL permissions.

## Trusted Directories

When launching Copilot CLI, users receive a prompt to confirm trust in the current directory. They may approve access for:

- The current session only
- Current and all future sessions

### Managing Trusted Directories

Users can edit the `config.json` file located at:
- **macOS/Linux**: `~/.copilot/config.json`
- **Windows**: `$HOME\.copilot\config.json`

The `COPILOT_HOME` environment variable allows customizing the config location.

## Tool Access Control

Copilot CLI requires approval before using certain tools like `touch`, `chmod`, `node`, or `sed`. Users have three response options:

1. **Yes** – Allow for this instance only
2. **Yes, and approve for session** – Allow throughout current session
3. **No** – Reject and request alternative approach

### Command-Line Flags for Tools

- `--allow-all-tools` – Skip all tool approvals
- `--allow-tool='TOOL_TYPE'` – Pre-approve specific tools
- `--deny-tool='TOOL_TYPE'` – Block specific tools
- `--available-tools` – Restrict to designated tools only

### Tool Specification Types

- **Shell commands**: `shell(COMMAND)` or `shell(git push)`
- **Write operations**: `'write'`
- **MCP servers**: `'MCP_SERVER_NAME(tool_name)'`

## Path Permissions

By default, Copilot can access the current working directory, subdirectories, and system temp directory.

- `--allow-all-paths` – Disable path verification
- `--disallow-temp-dir` – Block temp directory access

## URL Permissions

All external URLs require approval by default.

- `--allow-all-urls` – Skip URL verification
- `--allow-url=DOMAIN` – Pre-approve specific domains
- `--deny-url=DOMAIN` – Block specific domains

## Comprehensive Permission Flags

The `--allow-all` or `--yolo` flag combines all permissive settings. Interactive sessions also support `/allow-all` and `/yolo` commands.
