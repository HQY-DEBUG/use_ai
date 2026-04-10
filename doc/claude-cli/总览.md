# Claude Code 概述

> 文件：`overview.md`  版本：v1.0  日期：2026-03-24

> Claude Code 是一个代理编码工具，可以读取你的代码库、编辑文件、运行命令，并与你的开发工具集成。可在终端、IDE、桌面应用和浏览器中使用。

Claude Code 是一个由 AI 驱动的编码助手，可帮助你构建功能、修复错误和自动化开发任务。它理解你的整个代码库，可以跨多个文件和工具工作以完成任务。

---

## 开始使用

选择你的环境来开始使用。大多数界面需要 [Claude 订阅](https://claude.com/pricing) 或 [Anthropic 控制台](https://console.anthropic.com/) 账户。终端 CLI 和 VS Code 也支持第三方提供商。

### Terminal（终端 CLI）

功能完整的 CLI，用于直接在终端中使用 Claude Code。编辑文件、运行命令，并从命令行管理整个项目。

**安装方式：**

**macOS / Linux / WSL：**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows PowerShell：**

```powershell
irm https://claude.ai/install.ps1 | iex
```

**Windows CMD：**

```batch
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

Windows 需要先安装 [Git for Windows](https://git-scm.com/downloads/win)。

> 原生安装会在后台自动更新，保持最新版本。

**Homebrew：**

```bash
brew install --cask claude-code
```

> Homebrew 安装不会自动更新，请定期运行 `brew upgrade claude-code`。

**WinGet：**

```powershell
winget install Anthropic.ClaudeCode
```

> WinGet 安装不会自动更新，请定期运行 `winget upgrade Anthropic.ClaudeCode`。

然后在任何项目中启动 Claude Code：

```bash
cd your-project
claude
```

首次使用时，系统会提示你登录。

### VS Code

VS Code 扩展在编辑器中直接提供内联差异、@-提及、计划审查和对话历史。

- [为 VS Code 安装](vscode:extension/anthropic.claude-code)
- [为 Cursor 安装](cursor:extension/anthropic.claude-code)

或在扩展视图中搜索 "Claude Code"（Mac 上为 `Cmd+Shift+X`，Windows/Linux 上为 `Ctrl+Shift+X`）。安装后，打开命令面板（`Cmd+Shift+P` / `Ctrl+Shift+P`），输入 "Claude Code"，然后选择**在新标签页中打开**。

### 桌面应用

一个独立应用，用于在 IDE 或终端之外运行 Claude Code。直观地查看差异、并行运行多个会话、安排定期任务，并启动云会话。

下载并安装：

- [macOS](https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect)（Intel 和 Apple Silicon）
- [Windows](https://claude.ai/api/desktop/win32/x64/exe/latest/redirect)（x64）
- [Windows ARM64](https://claude.ai/api/desktop/win32/arm64/exe/latest/redirect)（仅限远程会话）

安装后，启动 Claude，登录，然后点击**代码**标签开始编码。需要付费订阅。

### Web

在浏览器中运行 Claude Code，无需本地设置。启动长时间运行的任务，完成后再检查，处理你本地没有的仓库，或并行运行多个任务。可在桌面浏览器和 Claude iOS 应用中使用。

在 [claude.ai/code](https://claude.ai/code) 开始编码。

### JetBrains

一个用于 IntelliJ IDEA、PyCharm、WebStorm 和其他 JetBrains IDE 的插件，具有交互式差异查看和选择上下文共享。

从 JetBrains Marketplace 安装 [Claude Code 插件](https://plugins.jetbrains.com/plugin/27310-claude-code-beta-)，然后重启你的 IDE。

---

## 你可以做什么

### 自动化你一直在推迟的工作

Claude Code 处理那些占用你一整天的繁琐任务：为未测试的代码编写测试、修复项目中的 lint 错误、解决合并冲突、更新依赖项和编写发布说明。

```bash
claude "write tests for the auth module, run them, and fix any failures"
```

### 构建功能和修复错误

用简单的语言描述你想要的内容。Claude Code 规划方法、跨多个文件编写代码，并验证其工作。

对于错误，粘贴错误消息或描述症状。Claude Code 通过你的代码库追踪问题、识别根本原因并实施修复。

### 创建提交和拉取请求

Claude Code 直接与 git 配合工作。它暂存更改、编写提交消息、创建分支并打开拉取请求。

```bash
claude "commit my changes with a descriptive message"
```

在 CI 中，你可以使用 GitHub Actions 或 GitLab CI/CD 自动化代码审查和问题分类。

### 使用 MCP 连接你的工具

Model Context Protocol (MCP) 是一个开放标准，用于将 AI 工具连接到外部数据源。使用 MCP，Claude Code 可以读取 Google Drive 中的设计文档、更新 Jira 中的工单、从 Slack 拉取数据，或使用你自己的自定义工具。

### 使用说明、skills 和 hooks 进行自定义

`CLAUDE.md` 是一个 markdown 文件，你可以将其添加到项目根目录，Claude Code 会在每个会话开始时读取它。使用它来设置编码标准、架构决策、首选库和审查清单。Claude 还会在工作时构建自动内存，保存学习内容，如构建命令和调试见解，跨会话使用。

创建自定义命令来打包你的团队可以共享的可重复工作流，如 `/review-pr` 或 `/deploy-staging`。

Hooks 让你在 Claude Code 操作之前或之后运行 shell 命令，如在每次文件编辑后自动格式化或在提交前运行 lint。

### 运行代理团队并构建自定义代理

生成多个 Claude Code 代理，同时处理任务的不同部分。主导代理协调工作、分配子任务并合并结果。

对于完全自定义的工作流，Agent SDK 让你构建由 Claude Code 的工具和功能驱动的自己的代理，完全控制编排、工具访问和权限。

### 使用 CLI 进行管道、脚本和自动化

Claude Code 是可组合的，遵循 Unix 哲学。将日志管道传入其中、在 CI 中运行它，或将其与其他工具链接：

```bash
# 监控日志并获得提醒
tail -f app.log | claude -p "Slack me if you see any anomalies"

# 在 CI 中自动化翻译
claude -p "translate new strings into French and raise a PR for review"

# 跨文件批量操作
git diff main --name-only | claude -p "review these changed files for security issues"
```

### 从任何地方工作

会话不受限于单一界面。当你的上下文改变时，在环境之间移动工作：

- 离开你的办公桌，使用远程控制从你的手机或任何浏览器继续工作
- 在网络或 iOS 应用上启动长时间运行的任务，然后使用 `/teleport` 将其拉入你的终端
- 使用 `/desktop` 将终端会话交给桌面应用进行视觉差异审查
- 从团队聊天路由任务：在 Slack 中提及 `@Claude` 并附上错误报告，获得拉取请求

---

## 在任何地方使用 Claude Code

每个界面都连接到相同的底层 Claude Code 引擎，因此你的 CLAUDE.md 文件、设置和 MCP 服务器可在所有界面中工作。

| 我想要...                        | 最佳选项                           |
| -------------------------------- | ---------------------------------- |
| 从我的手机或另一台设备继续本地会话 | 远程控制                           |
| 在本地启动任务，在移动设备上继续   | 网络或 Claude iOS 应用             |
| 自动化 PR 审查和问题分类          | GitHub Actions 或 GitLab CI/CD     |
| 在每个 PR 上获得自动代码审查       | GitHub Code Review                 |
| 将 Slack 中的错误报告路由到拉取请求 | Slack                             |
| 调试实时网络应用                   | Chrome                            |
| 为你自己的工作流构建自定义代理     | Agent SDK                         |

---

## 后续步骤

安装 Claude Code 后，这些指南可帮助你深入了解。

- **快速入门**：通过你的第一个真实任务，从探索代码库到提交修复
- **存储说明和内存**：使用 CLAUDE.md 文件和自动内存为 Claude 提供持久说明
- **常见工作流和最佳实践**：充分利用 Claude Code 的模式
- **设置**：为你的工作流自定义 Claude Code
- **故障排除**：常见问题的解决方案
