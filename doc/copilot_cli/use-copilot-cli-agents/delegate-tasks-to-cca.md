# Delegating Tasks to GitHub Copilot CLI / 将任务委托给 GitHub Copilot CLI

Use Copilot CLI's autopilot mode to hand off tasks and have Copilot work autonomously on your behalf.

使用 Copilot CLI 的自动驾驶模式移交任务，让 Copilot 代表你自主工作。

## Get Copilot to Work Autonomously / 让 Copilot 自主工作

You can tell Copilot to use its best judgment to complete a task autonomously, rather than the CLI prompting you for input at each decision point within a task. You do this by using the CLI's autopilot mode.

你可以让 Copilot 使用其最佳判断自主完成任务，而不是 CLI 在每个决策点都提示你输入。通过使用 CLI 的自动驾驶模式来实现这一点。

There are two ways to use autopilot mode:

有两种使用自动驾驶模式的方式：

* **Interactively:** In an interactive session, press **Shift+Tab** until you see "autopilot" in the status bar. If prompted to choose permissions for autopilot mode, allow full permissions, then enter your prompt.

* **交互式：** 在交互会话中，按 **Shift+Tab** 直到状态栏中显示"autopilot"。如果提示选择自动驾驶模式的权限，允许完全权限，然后输入提示词。

* **Programmatically:** Pass the CLI a prompt directly in a command, and include the `--autopilot` option. For example:

* **编程式：** 在命令中直接传递提示词给 CLI，并包含 `--autopilot` 选项。例如：

  ```shell
  copilot --autopilot --yolo --max-autopilot-continues 10 -p "YOUR PROMPT HERE"
  ```

## Delegate Tasks to Copilot Coding Agent / 将任务委托给 Copilot 编码 Agent

The delegate command lets you push your current session to Copilot coding agent on GitHub. This lets you hand off work while preserving all the context Copilot needs to complete your task.

委托命令让你将当前会话推送到 GitHub 上的 Copilot 编码 Agent。这让你能够移交工作，同时保留 Copilot 完成任务所需的所有上下文。

You can delegate a task using the slash command, followed by a prompt:

你可以使用斜杠命令后跟提示词来委托任务：

```shell
/delegate complete the API integration tests and fix any failing edge cases
```

Alternatively, prefix a prompt with `&` to delegate it:

或者，在提示词前加 `&` 来委托：

```shell
& complete the API integration tests and fix any failing edge cases
```

Copilot will ask to commit any of your unstaged changes as a checkpoint in a new branch it creates. Copilot coding agent will open a draft pull request, make changes in the background, and request a review from you.

Copilot 会要求将你未暂存的更改提交为其创建的新分支中的检查点。Copilot 编码 Agent 将开启一个草稿 Pull Request，在后台进行更改，并向你请求审查。

Copilot will provide a link to the pull request and agent session on GitHub once the session begins.

会话开始后，Copilot 会提供 GitHub 上 Pull Request 和 Agent 会话的链接。

## Next Steps / 后续步骤

To learn how to invoke specialized agents tailored to specific tasks, see [Invoking custom agents](invoke-custom-agents.md).

要了解如何调用针对特定任务定制的专业 Agent，请参阅[调用自定义 Agent](invoke-custom-agents.md)。
