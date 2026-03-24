# Installing GitHub Copilot CLI / 安装 GitHub Copilot CLI

Learn how to set up Copilot CLI for command-line usage.

了解如何为命令行使用配置 Copilot CLI。

## Prerequisites / 前提条件

To install Copilot CLI, you'll need:

安装 Copilot CLI 需要：

* An active GitHub Copilot subscription / 有效的 GitHub Copilot 订阅
* PowerShell v6 or higher (Windows only) / PowerShell v6 或更高版本（仅 Windows）

Organization or enterprise users should verify that their administrator hasn't disabled Copilot CLI in settings.

组织或企业用户应确认管理员未在设置中禁用 Copilot CLI。

## Installation Methods / 安装方式

You have four options for installing Copilot CLI:

安装 Copilot CLI 有以下四种方式：

**npm (all platforms)** — Requires Node.js 22+ / **npm（所有平台）** — 需要 Node.js 22+
```shell
npm install -g @github/copilot
```

If your `~/.npmrc` file contains `ignore-scripts=true`, use:

如果 `~/.npmrc` 文件包含 `ignore-scripts=true`，请使用：
```shell
npm_config_ignore_scripts=false npm install -g @github/copilot
```

**WinGet (Windows)**
```powershell
winget install GitHub.Copilot
```

**Homebrew (macOS and Linux)**
```shell
brew install copilot-cli
```

**Install script (macOS and Linux)** / **安装脚本（macOS 和 Linux）**
```shell
curl -fsSL https://gh.io/copilot-install | bash
```

You can also specify custom installation parameters with environment variables (`PREFIX` and `VERSION`).

也可以通过环境变量（`PREFIX` 和 `VERSION`）指定自定义安装参数。

Alternatively, download executables directly from the GitHub repository releases page.

或者直接从 GitHub 仓库的 releases 页面下载可执行文件。

## Authentication / 身份验证

On first launch, use the `/login` slash command to authenticate via GitHub. You can also authenticate using a fine-grained personal access token with "Copilot Requests" permission by exporting it as `COPILOT_GITHUB_TOKEN`, `GH_TOKEN`, or `GITHUB_TOKEN`.

首次启动时，使用 `/login` 斜杠命令通过 GitHub 进行身份验证。也可以使用具有"Copilot Requests"权限的细粒度个人访问令牌，将其导出为 `COPILOT_GITHUB_TOKEN`、`GH_TOKEN` 或 `GITHUB_TOKEN`。

## Getting Started / 开始使用

After installation and authentication, you're ready to use Copilot from your terminal.

安装和身份验证完成后，即可从终端开始使用 Copilot。
