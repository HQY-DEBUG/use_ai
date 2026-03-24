# Speeding Up Task Completion with the `/fleet` Command / 使用 `/fleet` 命令加速任务完成

Learn how you can speed up the completion of a multi-step implementation plan by using the `/fleet` slash command.

了解如何使用 `/fleet` 斜杠命令加速多步骤实现计划的完成。

Where a task involves multiple operations, some or all of which can be worked on in parallel, the `/fleet` slash command can speed up task completion. When you use this command, Copilot assigns separate parts of the work to subagents.

当任务涉及多个操作，其中部分或全部可以并行处理时，`/fleet` 斜杠命令可以加速任务完成。使用此命令时，Copilot 将工作的不同部分分配给各个子 Agent。

## Using the `/fleet` Slash Command / 使用 `/fleet` 斜杠命令

To use the `/fleet` slash command, enter the command followed by your prompt.

使用 `/fleet` 斜杠命令时，在命令后输入你的提示词。

### Typical Workflow / 典型工作流

Typically, you'll use the `/fleet` slash command after creating an implementation plan.

通常，你会在创建实现计划后使用 `/fleet` 斜杠命令。

1. In an interactive CLI session, press **Shift+Tab** to switch into plan mode. / 在交互式 CLI 会话中，按 **Shift+Tab** 切换到计划模式。
2. Enter a prompt describing the feature you want to add or the change you want to make. / 输入描述要添加功能或要进行更改的提示词。
3. Work with Copilot in plan mode to create an implementation plan. / 在计划模式下与 Copilot 协作创建实现计划。
4. Once the plan is complete, select one of the following options: / 计划完成后，选择以下选项之一：

   * **Accept plan and build on autopilot + /fleet** / **接受计划并在自动驾驶 + /fleet 模式下构建**：allows Copilot to use subagents and work autonomously to implement the plan without any further input. / 允许 Copilot 使用子 Agent 自主实现计划，无需任何进一步输入。
   * **Exit plan mode and I will prompt myself** / **退出计划模式，由我自行提示**：then enter a prompt such as `/fleet implement the plan`. Copilot will start working on the plan, using subagents to run parts of the work in parallel where possible. / 然后输入如 `/fleet implement the plan` 的提示词。Copilot 将开始执行计划，尽可能使用子 Agent 并行运行各部分工作。

### Monitoring Progress / 监控进度

Use the `/tasks` slash command to see a list of background tasks relating to the current session. This will include any subtasks handled by subagents when you use the `/fleet` command.

使用 `/tasks` 斜杠命令查看当前会话相关的后台任务列表，包括使用 `/fleet` 命令时由子 Agent 处理的所有子任务。

Use up and down keyboard keys to navigate through the list of background tasks. For each subagent task, you can:

使用上下方向键浏览后台任务列表。对于每个子 Agent 任务，你可以：

* Press **Enter** to view details. When the subtask is complete, you will see a summary of what was done. / 按 **Enter** 查看详情。子任务完成时，将显示已完成工作的摘要。
* Press **k** to kill the process. / 按 **k** 终止进程。
* Press **r** to remove completed or killed subtasks from the list. / 按 **r** 从列表中移除已完成或已终止的子任务。

Press **Esc** to exit the task list and return to the main CLI prompt.

按 **Esc** 退出任务列表，返回主 CLI 提示符。

## Further Reading / 延伸阅读

- [GitHub Copilot CLI command reference / 命令参考](reference/cli-command-reference.md)
