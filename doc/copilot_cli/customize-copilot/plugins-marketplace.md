# Creating a Plugin Marketplace for GitHub Copilot CLI / 为 GitHub Copilot CLI 创建插件市场

## Overview / 概述

A plugin marketplace serves as a registry where Copilot CLI plugins can be discovered and installed. These marketplaces can be hosted on GitHub.com, alternative Git services, or local file systems.

插件市场作为注册表，用于发现和安装 Copilot CLI 插件。这些市场可以托管在 GitHub.com、其他 Git 服务或本地文件系统上。

## Key Requirements / 关键要求

Before establishing a marketplace, you must have created one or more plugins that you want to share.

在建立市场之前，你必须已经创建了一个或多个要共享的插件。

## Setup Steps / 设置步骤

### 1. Create marketplace.json / 创建 marketplace.json

The core component is a `marketplace.json` file containing marketplace metadata and plugin listings. This file enables Copilot CLI to recognize your repository as a marketplace.

核心组件是包含市场元数据和插件列表的 `marketplace.json` 文件。此文件使 Copilot CLI 能够将你的仓库识别为市场。

Structure includes:

结构包括：

- Marketplace name and owner information / 市场名称和所有者信息
- Metadata with description and version / 包含描述和版本的元数据
- A `plugins` array listing available plugins with names, descriptions, versions, and source paths / 列出可用插件的 `plugins` 数组，包含名称、描述、版本和源路径

### 2. File Placement / 文件放置

Place `marketplace.json` in the `.github/plugin` directory (alternatively: `.claude-plugin/`).

将 `marketplace.json` 放在 `.github/plugin` 目录中（或者 `.claude-plugin/`）。

### 3. Directory Organization / 目录组织

Store plugin directories at locations specified in the `source` field. Paths are relative to the repository root and don't require `./` prefix.

将插件目录存放在 `source` 字段中指定的位置。路径相对于仓库根目录，不需要 `./` 前缀。

### 4. User Access / 用户访问

Share your repository and provide installation instructions. Users add the marketplace using:

共享你的仓库并提供安装说明。用户使用以下命令添加市场：

```shell
copilot plugin marketplace add OWNER/REPO
```

## Reference Materials / 参考材料

For implementation guidance, refer to the working examples in the `github/copilot-plugins` and `github/awesome-copilot` repositories.

有关实现指导，请参阅 `github/copilot-plugins` 和 `github/awesome-copilot` 仓库中的工作示例。
