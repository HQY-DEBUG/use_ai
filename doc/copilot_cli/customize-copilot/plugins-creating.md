# Creating a Plugin for GitHub Copilot CLI / 为 GitHub Copilot CLI 创建插件

## Overview / 概述

Plugins extend Copilot CLI functionality through customizable, installable packages.

插件通过可自定义、可安装的包来扩展 Copilot CLI 的功能。

## Plugin Architecture / 插件架构

A plugin requires a `plugin.json` manifest at its root. Optional components include agents, skills, hooks, and MCP server configurations. The basic directory structure:

插件需要在根目录有一个 `plugin.json` 清单文件。可选组件包括 Agent、技能、Hooks 和 MCP 服务器配置。基本目录结构：

```
my-plugin/
├── plugin.json
├── agents/
├── skills/
├── hooks.json
└── .mcp.json
```

## plugin.json Manifest / plugin.json 清单

The manifest contains metadata like name, description, version, author information, and license details. Place it in a `.github/plugin` or `.claude-plugin` directory, or at the root.

清单包含名称、描述、版本、作者信息和许可证详情等元数据。将其放在 `.github/plugin` 或 `.claude-plugin` 目录中，或放在根目录。

## Key Development Steps / 主要开发步骤

### Setup and Configuration / 设置和配置

Create your plugin directory and add a `plugin.json` manifest.

创建插件目录并添加 `plugin.json` 清单。

### Adding Components / 添加组件

- **Agents**: defined via `NAME.agent.md` files in an `agents` subdirectory / **Agent**：通过 `agents` 子目录中的 `NAME.agent.md` 文件定义
- **Skills**: require a `skills/NAME/SKILL.md` structure / **技能**：需要 `skills/NAME/SKILL.md` 结构
- **Hooks**: use `hooks.json` / **Hooks**：使用 `hooks.json`
- **MCP servers**: use `.mcp.json` / **MCP 服务器**：使用 `.mcp.json`

### Local Testing / 本地测试

Install locally using:

使用以下命令本地安装：

```shell
copilot plugin install ./my-plugin
```

When you install a plugin its components are cached. Reinstalling is necessary to pick up local modifications.

安装插件时，其组件会被缓存。需要重新安装才能获取本地修改。

### Verification / 验证

Use these commands in interactive sessions to confirm components loaded correctly:

在交互会话中使用以下命令确认组件加载正确：

- `/plugin list` — List installed plugins / 列出已安装的插件
- `/agent` — Browse available agents / 浏览可用 Agent
- `/skills list` — View available skills / 查看可用技能

## Distribution / 分发

Completed plugins can be shared via plugin marketplaces. See [Creating a plugin marketplace for GitHub Copilot CLI](plugins-marketplace.md) for more information.

完成的插件可通过插件市场共享。更多信息请参阅[为 GitHub Copilot CLI 创建插件市场](plugins-marketplace.md)。
