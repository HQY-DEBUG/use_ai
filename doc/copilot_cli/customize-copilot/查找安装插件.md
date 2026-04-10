# Finding and Installing Plugins for GitHub Copilot CLI / 查找和安装 GitHub Copilot CLI 插件

## Overview / 概述

Plugins are packages that extend the functionality of Copilot CLI. You can obtain them from registered marketplaces, Git repositories, or local directories. Copilot comes with two default marketplaces: `copilot-plugins` and `awesome-copilot`.

插件是扩展 Copilot CLI 功能的包。你可以从已注册的市场、Git 仓库或本地目录获取插件。Copilot 默认包含两个市场：`copilot-plugins` 和 `awesome-copilot`。

## Discovering Plugins / 发现插件

### List Registered Marketplaces / 列出已注册的市场

Check available marketplaces using:

使用以下命令查看可用市场：

```shell
copilot plugin marketplace list
```

Or in an interactive session:

或在交互会话中：

```
/plugin marketplace list
```

### Browse Marketplace Contents / 浏览市场内容

To explore plugins in a specific marketplace:

浏览特定市场中的插件：

```shell
copilot plugin marketplace browse MARKETPLACE-NAME
```

## Installation Methods / 安装方法

### From a Registered Marketplace / 从已注册市场安装

```shell
copilot plugin install PLUGIN-NAME@MARKETPLACE-NAME
```

Example: `copilot plugin install database-data-management@awesome-copilot`

示例：`copilot plugin install database-data-management@awesome-copilot`

### From GitHub Repositories / 从 GitHub 仓库安装

For GitHub.com repos:

对于 GitHub.com 仓库：

```shell
copilot plugin install OWNER/REPO
```

For any Git repository:

对于任意 Git 仓库：

```shell
copilot plugin install URL-OF-GIT-REPO
```

**Important:** The repository must contain a `plugin.json` file in a `.github/plugin` or `.claude-plugin` directory, or at the root.

**重要：** 仓库必须在 `.github/plugin` 或 `.claude-plugin` 目录中，或在根目录包含 `plugin.json` 文件。

For plugins with `plugin.json` elsewhere:

对于 `plugin.json` 在其他位置的插件：

```shell
copilot plugin install OWNER/REPO:PATH/TO/PLUGIN
```

### From Local Paths / 从本地路径安装

```shell
copilot plugin install ./PATH/TO/PLUGIN
```

## Plugin Management Commands / 插件管理命令

```bash
copilot plugin list                    # View installed plugins / 查看已安装的插件
copilot plugin update PLUGIN-NAME      # Update plugin / 更新插件
copilot plugin uninstall PLUGIN-NAME   # Remove plugin / 移除插件
```

## Plugin Storage Location / 插件存储位置

- Marketplace plugins: `~/.copilot/state/installed-plugins/MARKETPLACE/PLUGIN-NAME/` / 市场插件：`~/.copilot/state/installed-plugins/MARKETPLACE/PLUGIN-NAME/`
- Direct installations: `~/.copilot/state/installed-plugins/PLUGIN-NAME/` / 直接安装：`~/.copilot/state/installed-plugins/PLUGIN-NAME/`

## Managing Marketplaces / 管理市场

### Adding Marketplaces / 添加市场

For GitHub repositories:

对于 GitHub 仓库：

```shell
copilot plugin marketplace add OWNER/REPO
```

For local directories:

对于本地目录：

```shell
copilot plugin marketplace add /PATH/TO/MARKETPLACE-DIRECTORY
```

For non-GitHub repositories:

对于非 GitHub 仓库：

```shell
copilot plugin marketplace add https://gitlab.com/OWNER/REPO.git
```

### Removing Marketplaces / 移除市场

```shell
copilot plugin marketplace remove MARKETPLACE-NAME
```

**Note:** Removing a marketplace with installed plugins requires the `--force` flag to proceed.

**注意：** 移除包含已安装插件的市场需要使用 `--force` 标志。
