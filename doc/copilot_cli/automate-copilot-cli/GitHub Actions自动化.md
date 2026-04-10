# Automating Tasks with Copilot CLI and GitHub Actions / 使用 Copilot CLI 和 GitHub Actions 自动化任务

## Overview / 概述

GitHub Copilot CLI can be integrated into GitHub Actions workflows to enable AI-powered automation within CI/CD pipelines. You can run GitHub Copilot CLI in a GitHub Actions workflow to automate AI-powered tasks as part of your CI/CD process.

GitHub Copilot CLI 可以集成到 GitHub Actions 工作流中，在 CI/CD 管道中实现 AI 驱动的自动化。你可以在 GitHub Actions 工作流中运行 GitHub Copilot CLI，将 AI 驱动的任务作为 CI/CD 流程的一部分。

## Workflow Pattern / 工作流模式

A typical implementation follows these steps:

典型实现遵循以下步骤：

1. **Trigger / 触发** — Initiate via schedule, repository events, or manual dispatch / 通过计划、仓库事件或手动调度启动
2. **Setup / 设置** — Check out code and configure the environment / 检出代码并配置环境
3. **Install / 安装** — Deploy Copilot CLI on the runner / 在运行器上部署 Copilot CLI
4. **Authenticate / 身份验证** — Grant necessary permissions to access the repository / 授予访问仓库所需的权限
5. **Run Copilot CLI / 运行 Copilot CLI** — Execute with a non-interactive prompt for your desired task / 使用非交互式提示词执行所需任务

## Key Implementation Details / 关键实现细节

### Triggering Workflows / 触发工作流

Use `workflow_dispatch` for manual execution and `schedule` with cron syntax for automated runs.

使用 `workflow_dispatch` 进行手动执行，使用 `schedule` 配合 cron 语法进行自动运行。

### Installation / 安装

Install Copilot CLI via npm globally:

通过 npm 全局安装 Copilot CLI：

```bash
npm install -g @github/copilot
```

### Authentication Requirements / 身份验证要求

To authenticate Copilot CLI, you must:

要对 Copilot CLI 进行身份验证，你必须：

- Create a personal access token with "Copilot Requests" permission / 创建具有"Copilot Requests"权限的个人访问令牌
- Store it as a repository secret / 将其存储为仓库密钥
- Set the `COPILOT_GITHUB_TOKEN` environment variable in your workflow step / 在工作流步骤中设置 `COPILOT_GITHUB_TOKEN` 环境变量

### Running Programmatically / 以编程方式运行

Use the `copilot -p PROMPT [OPTIONS]` syntax. Important flags:

使用 `copilot -p PROMPT [OPTIONS]` 语法。重要标志：

- `--allow-tool='shell(git:*)'` — Permits Git command execution / 允许执行 Git 命令
- `--allow-tool='write'` — Enables file writing capabilities / 启用文件写入功能
- `--no-ask-user` — Suppresses interactive prompts (essential for automation) / 抑制交互式提示（自动化必需）

## Example Workflow / 示例工作流

```yaml
name: AI-Powered Daily Summary
on:
  workflow_dispatch:
  schedule:
    - cron: '0 9 * * 1-5'  # Weekdays at 9am / 工作日上午 9 点

jobs:
  daily-summary:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Install Copilot CLI
        run: npm install -g @github/copilot

      - name: Generate summary
        env:
          COPILOT_GITHUB_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
        run: |
          copilot -p "Summarize recent changes and open issues" \
            --allow-tool='shell(git:*)' --no-ask-user \
            --share='./daily-summary.md'
```

## Practical Applications / 实际应用

Beyond the example daily summary workflow, you could adapt this pattern to:

除示例每日摘要工作流外，你还可以将此模式适配为：

- Automatically update changelog files via pull requests / 通过 Pull Request 自动更新变更日志文件
- Distribute summaries via email to maintainers / 通过电子邮件将摘要分发给维护者
- Generate reports or scaffold project templates / 生成报告或构建项目模板

The flexibility of the prompt parameter enables diverse automation scenarios within your development workflow.

提示词参数的灵活性使开发工作流中的多样化自动化场景成为可能。
