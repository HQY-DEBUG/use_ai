# Creating and Using Custom Agents for GitHub Copilot CLI

## Overview

Custom agents let you configure specialized tools tailored to particular development workflows. These agents operate as subagents—temporary instances with isolated context windows—allowing complex tasks to be handled without cluttering the main agent's processing capacity.

## How to Create a Custom Agent

Custom agents are defined through Markdown files with an `.agent.md` extension. You can create them manually or through the CLI's interactive setup.

### Via CLI Interactive Mode

1. Enter `/agent` in interactive mode
2. Select **Create new agent**
3. Choose storage location:
   - **Project**: `.github/agents/`
   - **User**: `~/.copilot/agents/`

   (Note: User-level agents override project-level ones with identical names)

4. Select your creation method:

   **Copilot-Assisted Creation**: Describe the agent's expertise and intended use. Copilot generates an initial profile, which you can review and edit before finalizing.

   **Manual Creation**: Answer CLI prompts for:
   - Agent name (lowercase with hyphens recommended for programmatic use)
   - Description of expertise and use cases
   - Behavioral instructions and constraints

5. Configure tool access (all tools available by default unless restricted)
6. Restart the CLI to activate the new agent

## Custom Agent Frontmatter

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `description` | string | Yes | Shown in agent list and task tool |
| `infer` | boolean | No | Allow auto-delegation (default: true) |
| `mcp-servers` | object | No | MCP servers to connect |
| `model` | string | No | AI model; inherits outer agent if unset |
| `name` | string | No | Display name (defaults to filename) |
| `tools` | string[] | No | Available tools (default: all) |

## Custom Agent Locations

| Scope | Location |
|-------|----------|
| Project | `.github/agents/` or `.claude/agents/` |
| User | `~/.copilot/agents/` or `~/.claude/agents/` |
| Plugin | `<plugin>/agents/` |

Project agents override user agents; plugin agents have lowest priority.

## Built-in Agents

| Agent | Model | Description |
|-------|-------|-------------|
| `code-review` | claude-sonnet-4.5 | High-signal code review analyzing diffs for bugs and issues |
| `explore` | claude-haiku-4.5 | Fast codebase exploration with focused answers |
| `general-purpose` | claude-sonnet-4.5 | Full-capability multi-step task agent |
| `research` | claude-sonnet-4.6 | Deep research generating reports from codebase and web |
| `task` | claude-haiku-4.5 | Command execution (tests, builds, lints) |

## How to Use a Custom Agent

**Slash Command Method:**
Access via `/agent` in interactive mode, then select from available agents.

**Direct Reference:**
Type instructions explicitly: `Use the security-auditor agent on /src/app`

**Automatic Inference:**
Trigger based on prompt content matching agent descriptions or keywords defined in the profile.

**Programmatic Approach:**
```shell
copilot --agent security-auditor --prompt "Check /src/app/validator.go"
```
