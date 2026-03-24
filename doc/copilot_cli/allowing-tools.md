# Allowing and Denying Tool Use in Copilot CLI

## Overview

Copilot CLI provides mechanisms to control which tools the system can access, preventing unintended modifications to your environment. The platform distinguishes between safe read-only operations and potentially destructive actions that require approval.

## Two-Layer Control System

### Layer 1: Tool Availability

The `--available-tools` and `--excluded-tools` flags manage which tools the AI model can even consider using:

- `--available-tools` creates an allowlist, disabling everything else
- `--excluded-tools` creates a denylist for specific tools
- When both are specified, the allowlist takes precedence

**Example:** To prevent web search during benchmarking:
```bash
copilot --excluded-tools='web_fetch, web_search'
```

### Layer 2: Permission Management

The `--allow-tool` and `--deny-tool` flags grant or revoke permission for specific tools:

- Allowed tools execute without prompts
- Denied tools cannot be used, even if optimal
- Deny rules supersede allow rules

**Example patterns:**
- `--allow-tool=shell` — all shell commands
- `--allow-tool='shell(git commit)'` — specific command only
- `--allow-tool='shell(git:*)' --deny-tool='shell(git push)'` — git access excluding push

## Permissive Options

- `--allow-all-tools` — full tool access
- `--allow-all` or `--yolo` — grants all permissions (use only in isolated environments)
- `/allow-all` or `/yolo` — interactive session equivalents

## Session Management

The `/reset-allowed-tools` slash command reverts permissions to either defaults or command-line specifications, removing any permissions granted interactively while preserving original startup configurations.
