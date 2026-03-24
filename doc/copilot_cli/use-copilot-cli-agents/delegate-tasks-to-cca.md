# Delegating Tasks to GitHub Copilot CLI

Use Copilot CLI's autopilot mode to hand off tasks and have Copilot work autonomously on your behalf.

## Get Copilot to Work Autonomously

You can tell Copilot to use its best judgment to complete a task autonomously, rather than the CLI prompting you for input at each decision point within a task. You do this by using the CLI's autopilot mode.

There are two ways to use autopilot mode:

* **Interactively:** In an interactive session, press **Shift+Tab** until you see "autopilot" in the status bar. If prompted to choose permissions for autopilot mode, allow full permissions, then enter your prompt.
* **Programmatically:** Pass the CLI a prompt directly in a command, and include the `--autopilot` option. For example:

  ```shell
  copilot --autopilot --yolo --max-autopilot-continues 10 -p "YOUR PROMPT HERE"
  ```

## Delegate Tasks to Copilot Coding Agent

The delegate command lets you push your current session to Copilot coding agent on GitHub. This lets you hand off work while preserving all the context Copilot needs to complete your task.

You can delegate a task using the slash command, followed by a prompt:

```shell
/delegate complete the API integration tests and fix any failing edge cases
```

Alternatively, prefix a prompt with `&` to delegate it:

```shell
& complete the API integration tests and fix any failing edge cases
```

Copilot will ask to commit any of your unstaged changes as a checkpoint in a new branch it creates. Copilot coding agent will open a draft pull request, make changes in the background, and request a review from you.

Copilot will provide a link to the pull request and agent session on GitHub once the session begins.

## Next Steps

To learn how to invoke specialized agents tailored to specific tasks, see [Invoking custom agents](invoke-custom-agents.md).
