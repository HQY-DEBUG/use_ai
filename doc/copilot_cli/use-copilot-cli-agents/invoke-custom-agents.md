# Invoking Custom Agents

Extend Copilot CLI capabilities using custom agents, skills, and MCP servers.

## Custom Agents Overview

A custom agent represents a specialized Copilot variant designed to handle unique workflows, coding conventions, and specialist scenarios.

Copilot CLI provides four default agents:

| Agent | Purpose |
|-------|---------|
| Explore | Performs codebase analysis without impacting main context |
| Task | Executes commands like tests and builds with contextual output |
| General-purpose | Handles complex multi-step tasks with full toolset access |
| Code-review | Reviews changes while minimizing false positives |

The system allows the AI model to delegate work to subagent processes when it determines this approach yields better results.

## Creating Custom Agents

Define your own agents using Markdown-based agent profiles that specify expertise, available tools, and response instructions.

**Deployment levels:**

- **User-level**: `~/.copilot/agents` directory (all projects)
- **Repository-level**: `.github/agents` directory (current project only)
- **Organization/Enterprise-level**: `/agents` in `.github-private` repository (all organizational projects)

Priority hierarchy: system agents override repository agents, which override organization-level agents.

## Invoking Custom Agents

Three invocation methods exist:

1. **Slash command**: Use `/agent` in the interactive interface to select from available agents
2. **Direct reference**: Mention the agent in your prompt for automatic inference:
   ```
   Use the security-auditor agent on /src/app
   ```
3. **CLI option**:
   ```shell
   copilot --agent=refactor-agent --prompt "Your task"
   ```

## Skills and MCP Servers

**Skills** enhance Copilot's specialized task capabilities through instructions, scripts, and resources. See [Creating agent skills for GitHub Copilot CLI](create-skills.md).

**MCP servers** extend functionality. The GitHub MCP server comes pre-configured. Add additional servers using `/mcp add`, with configurations stored in `mcp-config.json` (default location: `~/.copilot` directory, customizable via `COPILOT_HOME` environment variable). See [Adding MCP servers for GitHub Copilot CLI](add-mcp-servers.md).
