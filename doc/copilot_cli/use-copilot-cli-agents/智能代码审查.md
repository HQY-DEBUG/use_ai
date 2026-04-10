# Requesting a Code Review with GitHub Copilot CLI / 使用 GitHub Copilot CLI 请求代码审查

GitHub Copilot CLI offers an agentic code review feature through the terminal, enabling developers to obtain feedback on code modifications without leaving their command-line environment.

GitHub Copilot CLI 通过终端提供智能代码审查功能，使开发者无需离开命令行环境即可获得代码修改的反馈。

## How Agentic Code Review Works / 智能代码审查的工作原理

The process involves three main steps:

该流程包含三个主要步骤：

### Step 1: Initiate the Review / 步骤 1：启动审查

Enter the `/review` command with optional parameters to focus the analysis. You can specify a custom prompt, file path, or pattern to limit the review's scope, then press Enter to begin.

输入 `/review` 命令以及可选参数来聚焦分析。你可以指定自定义提示词、文件路径或模式来限制审查范围，然后按 Enter 开始。

```shell
/review
```

Or with a focused prompt:

或使用聚焦提示词：

```shell
/review Focus on security vulnerabilities in the authentication module
```

### Step 2: Respond to Proposed Commands / 步骤 2：响应建议的命令

Copilot may suggest running commands to examine diffs or validate files. Use arrow keys to navigate between "Yes" and "No" options. Selecting Yes executes the command; selecting No allows you to redirect Copilot's approach.

Copilot 可能会建议运行命令来检查差异或验证文件。使用方向键在"是"和"否"选项之间导航。选择"是"执行命令；选择"否"允许你重定向 Copilot 的方法。

### Step 3: Apply Recommendations / 步骤 3：应用建议

Once Copilot completes its analysis, review the feedback provided and implement any suggested enhancements directly in your code editor.

Copilot 完成分析后，查看提供的反馈，并直接在代码编辑器中实施任何建议的改进。

## Related Resources / 相关资源

- [Automating tasks with Copilot CLI and GitHub Actions](../automate-copilot-cli/automate-with-actions.md) / [使用 Copilot CLI 和 GitHub Actions 自动化任务](../automate-copilot-cli/automate-with-actions.md)
- [Adding custom instructions for GitHub Copilot CLI](../customize-copilot/add-custom-instructions.md) / [为 GitHub Copilot CLI 添加自定义指令](../customize-copilot/add-custom-instructions.md)
