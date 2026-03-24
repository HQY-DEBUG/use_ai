# Getting Started with GitHub Copilot CLI / GitHub Copilot CLI 入门

## Overview / 概述

GitHub Copilot CLI is a powerful terminal-native AI coding assistant that brings agentic capabilities directly to your command line.

GitHub Copilot CLI 是一款强大的终端原生 AI 编程助手，将自主代理能力直接带到你的命令行。

## Installation Options / 安装方式

The setup process offers multiple installation methods depending on your operating system:

根据操作系统不同，提供以下多种安装方式：

- **npm (cross-platform)** / **npm（跨平台）**: Requires Node.js 22 or later / 需要 Node.js 22 或更高版本
  ```shell
  npm install -g @github/copilot
  ```
- **WinGet (Windows)**:
  ```powershell
  winget install GitHub.Copilot
  ```
- **Homebrew (macOS/Linux)**:
  ```shell
  brew install copilot-cli
  ```

For full installation details, see [Installing GitHub Copilot CLI](set-up-copilot-cli/install-copilot-cli.md).

完整安装说明请参见 [安装 GitHub Copilot CLI](set-up-copilot-cli/install-copilot-cli.md)。

## Initial Setup Steps / 初始设置步骤

1. Navigate to your project directory. / 进入你的项目目录。
2. Run `copilot` to start an interactive session. / 运行 `copilot` 启动交互式会话。
3. Authenticate by entering `/login` and following the GitHub account verification prompts. / 输入 `/login` 并按提示完成 GitHub 账号验证。
4. Confirm that the project files are appropriate for AI processing. / 确认项目文件适合 AI 处理。

Copilot won't make changes to your files without your explicit approval.

Copilot 不会在未经你明确批准的情况下修改文件。

## Essential Keyboard Shortcuts / 常用键盘快捷键

| Key / 按键 | Purpose / 用途 |
|-----|---------|
| `Esc` | Cancel current operation / 取消当前操作 |
| `Ctrl+C` | Clear input (press twice to exit) / 清空输入（按两次退出） |
| `Ctrl+L` | Clear the screen / 清屏 |
| `@` | Include specific files in context / 将指定文件加入上下文 |
| `/` | Display available slash commands / 显示可用斜杠命令 |
| `?` | Open help documentation / 打开帮助文档 |
| `Shift+Tab` | Cycle through modes (standard, plan, autopilot) / 切换模式（标准、计划、自动驾驶） |

Access the complete list via `/help` or see the [CLI command reference](reference/cli-command-reference.md).

完整列表请使用 `/help` 或查看 [CLI 命令参考](reference/cli-command-reference.md)。

## Non-Interactive Usage / 非交互式用法

For scripted workflows, use the `-p` flag to submit prompts directly:

用于脚本工作流时，使用 `-p` 标志直接提交提示词：

```shell
copilot -p "Explain what this function does"
```

Adding `-s` outputs only the response, omitting supplementary information, enabling programmatic integration:

添加 `-s` 仅输出响应内容，省略附加信息，便于程序化集成：

```shell
copilot -p "Summarize this file" -s
```

## Next Steps / 后续步骤

- [Installing GitHub Copilot CLI / 安装](set-up-copilot-cli/install-copilot-cli.md)
- [Authenticating GitHub Copilot CLI / 身份验证](set-up-copilot-cli/authenticate-copilot-cli.md)
- [Using GitHub Copilot CLI / 使用指南](use-copilot-cli-agents/overview.md)
- [Best practices for GitHub Copilot CLI / 最佳实践](cli-best-practices.md)
