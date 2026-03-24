# Creating a Plugin for GitHub Copilot CLI

## Overview

Plugins extend Copilot CLI functionality through customizable, installable packages.

## Plugin Architecture

A plugin requires a `plugin.json` manifest at its root. Optional components include agents, skills, hooks, and MCP server configurations. The basic directory structure:

```
my-plugin/
├── plugin.json
├── agents/
├── skills/
├── hooks.json
└── .mcp.json
```

## plugin.json Manifest

The manifest contains metadata like name, description, version, author information, and license details. Place it in a `.github/plugin` or `.claude-plugin` directory, or at the root.

## Key Development Steps

### Setup and Configuration

Create your plugin directory and add a `plugin.json` manifest.

### Adding Components

- **Agents**: defined via `NAME.agent.md` files in an `agents` subdirectory
- **Skills**: require a `skills/NAME/SKILL.md` structure
- **Hooks**: use `hooks.json`
- **MCP servers**: use `.mcp.json`

### Local Testing

Install locally using:
```shell
copilot plugin install ./my-plugin
```

When you install a plugin its components are cached. Reinstalling is necessary to pick up local modifications.

### Verification

Use these commands in interactive sessions to confirm components loaded correctly:
- `/plugin list` — List installed plugins
- `/agent` — Browse available agents
- `/skills list` — View available skills

## Distribution

Completed plugins can be shared via plugin marketplaces. See [Creating a plugin marketplace for GitHub Copilot CLI](plugins-marketplace.md) for more information.
