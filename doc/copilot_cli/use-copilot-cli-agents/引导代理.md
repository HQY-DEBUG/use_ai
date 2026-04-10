# Steering Agents in GitHub Copilot CLI / 在 GitHub Copilot CLI 中引导 Agent

## Overview / 概述

The GitHub Copilot CLI allows you to guide the AI agent during task execution, ensuring it remains aligned with your intentions and objectives.

GitHub Copilot CLI 允许你在任务执行期间引导 AI Agent，确保其与你的意图和目标保持一致。

## Real-Time Interaction While Processing / 处理中的实时交互

You can engage with Copilot while it's actively working. The platform supports sending follow-up messages to redirect the conversation or add additional instructions that Copilot will address once completing its current task.

你可以在 Copilot 正在工作时与其交互。平台支持发送后续消息以重定向对话，或添加 Copilot 完成当前任务后将处理的额外指令。

## Key Benefits of Steering / 引导的主要好处

This feature enables you to:

此功能使你能够：

* Stop an agent moving toward an incorrect solution / 阻止 Agent 朝错误的解决方案前进
* Give immediate feedback when declining tool permission requests / 在拒绝工具权限请求时提供即时反馈
* Modify or clarify the task requirements mid-execution / 在执行过程中修改或澄清任务要求

## How to Steer / 如何引导

- **Press Esc**: Cancel the current operation if you detect Copilot is heading in the wrong direction. / **按 Esc**：如果发现 Copilot 朝错误方向前进，取消当前操作。
- **Decline tool requests**: When Copilot asks for tool approval, select "No" and provide inline feedback about what you want done differently. Copilot will adapt its approach without stopping entirely. / **拒绝工具请求**：当 Copilot 请求工具批准时，选择"否"并提供内联反馈，说明你希望采取不同的做法。Copilot 将调整其方法而不会完全停止。
- **Send follow-up messages**: While Copilot is processing, you can type follow-up instructions that will be addressed after the current step completes. / **发送后续消息**：在 Copilot 处理时，你可以输入后续指令，这些指令将在当前步骤完成后处理。

## Further Reading / 延伸阅读

- [Requesting a code review with GitHub Copilot CLI](agentic-code-review.md) / [使用 GitHub Copilot CLI 请求代码审查](agentic-code-review.md)
- [Delegating tasks to GitHub Copilot CLI](delegate-tasks-to-cca.md) / [将任务委托给 GitHub Copilot CLI](delegate-tasks-to-cca.md)
