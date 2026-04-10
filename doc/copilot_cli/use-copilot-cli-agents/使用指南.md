# Using GitHub Copilot CLI / 使用 GitHub Copilot CLI

Learn how to use GitHub Copilot from the command line.

了解如何从命令行使用 GitHub Copilot。

The command-line interface (CLI) for GitHub Copilot allows you to use Copilot directly from your terminal.

GitHub Copilot 的命令行界面（CLI）允许你直接从终端使用 Copilot。

## Prerequisite / 前提条件

Install Copilot CLI. See [Installing GitHub Copilot CLI](../set-up-copilot-cli/install-copilot-cli.md).

安装 Copilot CLI。请参阅[安装 GitHub Copilot CLI](../set-up-copilot-cli/install-copilot-cli.md)。

## Using Copilot CLI / 使用 Copilot CLI

1. In your terminal, navigate to a folder that contains code you want to work with.

1. 在终端中，导航到包含你要处理的代码的文件夹。

2. Enter `copilot` to start Copilot CLI.

2. 输入 `copilot` 启动 Copilot CLI。

   Copilot will ask you to confirm that you trust the files in this folder.

   Copilot 会要求你确认是否信任此文件夹中的文件。

   > **IMPORTANT**: During this GitHub Copilot CLI session, Copilot may attempt to read, modify, and execute files in and below this folder. You should only proceed if you trust the files in this location.

   > **重要**：在此 GitHub Copilot CLI 会话期间，Copilot 可能会尝试读取、修改和执行此文件夹及其子文件夹中的文件。只有在信任此位置的文件时才应继续。

3. Choose one of the options:

3. 选择以下选项之一：

   - **Yes, proceed**: Copilot can work with the files in this location for this session only. / **是，继续**：Copilot 仅在此会话中处理此位置的文件。
   - **Yes, and remember this folder for future sessions**: You trust the files in this folder for this and future sessions. You won't be asked again when you start Copilot CLI from this folder. Only choose this option if you are sure that it will always be safe for Copilot to work with files in this location. / **是，并记住此文件夹供以后使用**：你信任此文件夹中的文件，本次及以后的会话均如此。从此文件夹启动 Copilot CLI 时不会再次询问。只有确信 Copilot 处理此位置的文件始终安全时才选择此选项。
   - **No, exit (Esc)**: End your Copilot CLI session. / **否，退出（Esc）**：结束 Copilot CLI 会话。

4. If you are not currently logged in to GitHub, you'll be prompted to use the `/login` slash command. Enter this command and follow the on-screen instructions to authenticate.

4. 如果当前未登录 GitHub，系统会提示你使用 `/login` 斜杠命令。输入此命令并按照屏幕上的说明进行身份验证。

5. Enter a prompt in the CLI.

5. 在 CLI 中输入提示词。

   This can be a simple chat question, or a request for Copilot to perform a specific task, such as fixing a bug, adding a feature to an existing application, or creating a new application.

   这可以是简单的聊天问题，也可以是要求 Copilot 执行特定任务的请求，例如修复 Bug、向现有应用程序添加功能或创建新应用程序。

6. When Copilot wants to use a tool that could modify or execute files—for example, `touch`, `chmod`, `node`, or `sed`—it will ask you to approve the use of the tool.

6. 当 Copilot 想要使用可能修改或执行文件的工具（例如 `touch`、`chmod`、`node` 或 `sed`）时，会要求你批准该工具的使用。

   Choose one of the options:

   选择以下选项之一：

   - **Yes**: Allow Copilot to use this tool. The next time Copilot wants to use this tool, it will ask you to approve it again. / **是**：允许 Copilot 使用此工具。下次 Copilot 想使用此工具时，会再次要求你批准。
   - **Yes, and approve TOOL for the rest of the running session**: Allow Copilot to use this tool—with any options—without asking again, for the rest of the currently running session. / **是，并批准 TOOL 用于本次会话剩余时间**：允许 Copilot 在当前运行会话的剩余时间内使用此工具（任何选项），不再询问。
   - **No, and tell Copilot what to do differently (Esc)**: Copilot will not run the command. Instead, it ends the current operation and awaits your next prompt. / **否，并告知 Copilot 采取不同操作（Esc）**：Copilot 不会运行该命令。它会结束当前操作并等待你的下一个提示词。

## Tips / 使用技巧

### Stop a currently running operation / 停止当前运行的操作

If you enter a prompt and then decide you want to stop Copilot from completing the task while it is still "Thinking," press **Esc**.

如果你输入提示词后决定在 Copilot 仍处于"思考"状态时停止其完成任务，请按 **Esc**。

### Use plan mode / 使用计划模式

Plan mode lets you collaborate with Copilot on an implementation plan before any code is written. Press **Shift+Tab** to cycle in and out of plan mode.

计划模式让你在编写任何代码之前与 Copilot 协作制定实施计划。按 **Shift+Tab** 切换进出计划模式。

### Include a specific file in your prompt / 在提示词中包含特定文件

To add a specific file to your prompt, use `@` followed by the relative path to the file. For example: `Explain @config/ci/ci-required-checks.yml` or `Fix the bug in @src/app.js`.

要在提示词中添加特定文件，使用 `@` 后跟文件的相对路径。例如：`Explain @config/ci/ci-required-checks.yml` 或 `Fix the bug in @src/app.js`。

When you start typing a file path, the matching paths are displayed below the prompt box. Use the arrow keys to select a path and press **Tab** to complete the path in your prompt.

当你开始输入文件路径时，匹配的路径会显示在提示框下方。使用方向键选择路径，按 **Tab** 在提示词中补全路径。

### Work with files in a different location / 处理不同位置的文件

You can also add a trusted directory manually at any time by using the slash command:

你也可以随时使用斜杠命令手动添加受信任的目录：

```shell
/add-dir /path/to/directory
```

If all of the files you want to work with are in a different location, you can switch the current working directory without starting a new Copilot CLI session by using either the `/cwd` or `/cd` slash commands:

如果你要处理的所有文件都在不同位置，可以使用 `/cwd` 或 `/cd` 斜杠命令切换当前工作目录，而无需启动新的 Copilot CLI 会话：

```shell
/cwd /path/to/directory
```

### Run shell commands / 运行 Shell 命令

You can prepend your input with `!` to directly run shell commands, without making a call to the model.

你可以在输入前加 `!` 直接运行 Shell 命令，而不调用模型。

```shell
!git clone https://github.com/github/copilot-cli
```

### Resume an interactive session / 恢复交互会话

You can use the `--resume` command-line option or the `/resume` slash command to select and resume an interactive CLI session.

你可以使用 `--resume` 命令行选项或 `/resume` 斜杠命令选择并恢复交互式 CLI 会话。

> **TIP**: To quickly resume the most recently closed local session, enter this in your terminal:
>
> **提示**：要快速恢复最近关闭的本地会话，在终端中输入：
>
> ```shell
> copilot --continue
> ```

### Use custom instructions / 使用自定义指令

You can enhance Copilot's performance by adding custom instructions to the repository you are working in. Copilot CLI supports:

你可以通过向工作仓库添加自定义指令来增强 Copilot 的性能。Copilot CLI 支持：

- Repository-wide instructions in the `.github/copilot-instructions.md` file. / `.github/copilot-instructions.md` 文件中的仓库范围指令。
- Path-specific instructions files: `.github/instructions/**/*.instructions.md`. / 路径特定指令文件：`.github/instructions/**/*.instructions.md`。
- Agent files such as `AGENTS.md`. / Agent 文件，例如 `AGENTS.md`。

For more information, see [Adding custom instructions for GitHub Copilot CLI](../customize-copilot/add-custom-instructions.md).

更多信息请参阅[为 GitHub Copilot CLI 添加自定义指令](../customize-copilot/add-custom-instructions.md)。

### Use custom agents / 使用自定义 Agent

A custom agent is a specialized version of Copilot. Copilot CLI includes a default group of custom agents for common tasks:

自定义 Agent 是 Copilot 的专业化版本。Copilot CLI 包含一组用于常见任务的默认自定义 Agent：

| Agent / Agent 名称 | Description / 说明 |
|-------|-------------|
| Explore | Performs quick codebase analysis, allowing you to ask questions about your code without adding to your main context. / 执行快速代码库分析，让你在不增加主上下文的情况下询问代码相关问题。 |
| Task | Executes commands such as tests and builds, providing brief summaries on success and full output on failure. / 执行测试和构建等命令，成功时提供简要摘要，失败时提供完整输出。 |
| General-purpose | Handles complex, multi-step tasks that require the full toolset and high-quality reasoning, running in a separate context to keep your main conversation clearly focused. / 处理需要完整工具集和高质量推理的复杂多步骤任务，在独立上下文中运行，保持主对话清晰聚焦。 |
| Code-review | Reviews changes with a focus on surfacing only genuine issues, minimizing noise. / 审查变更，专注于发现真实问题，减少噪音。 |

You can define custom agents at the user, repository, or organization/enterprise level:

你可以在用户、仓库或组织/企业级别定义自定义 Agent：

| Type / 类型 | Location / 位置 | Scope / 作用域 |
|------|----------|-------|
| User-level custom agent / 用户级自定义 Agent | local `~/.copilot/agents` directory / 本地 `~/.copilot/agents` 目录 | All projects / 所有项目 |
| Repository-level custom agent / 仓库级自定义 Agent | `.github/agents` directory in your local and remote repositories / 本地和远程仓库中的 `.github/agents` 目录 | Current project / 当前项目 |
| Organization and Enterprise-level custom agent / 组织和企业级自定义 Agent | `/agents` directory in the `.github-private` repository / `.github-private` 仓库中的 `/agents` 目录 | All projects under your organization and enterprise account / 组织和企业账户下的所有项目 |

Custom agents can be used in three ways:

自定义 Agent 可以通过三种方式使用：

- Using the slash command: `/agent` / 使用斜杠命令：`/agent`
- Calling out to custom agent directly in a prompt: `Use the refactoring agent to refactor this code block` / 在提示词中直接调用自定义 Agent：`Use the refactoring agent to refactor this code block`
- Specifying the custom agent with the command-line option: / 使用命令行选项指定自定义 Agent：

  ```shell
  copilot --agent=refactor-agent --prompt "Refactor this code block"
  ```

### Use skills / 使用技能

You can create skills to enhance the ability of Copilot to perform specialized tasks with instructions, scripts, and resources.

你可以创建技能，通过指令、脚本和资源增强 Copilot 执行专业任务的能力。

For more information, see [Creating agent skills for GitHub Copilot CLI](../customize-copilot/create-skills.md).

更多信息请参阅[为 GitHub Copilot CLI 创建 Agent 技能](../customize-copilot/create-skills.md)。

### Add an MCP server / 添加 MCP 服务器

Copilot CLI comes with the GitHub MCP server already configured. To add more MCP servers:

Copilot CLI 已预配置 GitHub MCP 服务器。要添加更多 MCP 服务器：

1. Use the following slash command: `/mcp add` / 使用以下斜杠命令：`/mcp add`
2. Fill in the details for the MCP server you want to add, using the **Tab** key to move between fields. / 填写要添加的 MCP 服务器的详细信息，使用 **Tab** 键在字段之间移动。
3. Press **Ctrl+S** to save the details. / 按 **Ctrl+S** 保存详细信息。

Details of your configured MCP servers are stored in the `mcp-config.json` file, located by default in the `~/.copilot` directory.

已配置的 MCP 服务器详细信息存储在 `mcp-config.json` 文件中，默认位于 `~/.copilot` 目录。

### Context management / 上下文管理

Copilot CLI provides several slash commands to help you monitor and manage your context window:

Copilot CLI 提供多个斜杠命令，帮助你监控和管理上下文窗口：

- `/usage`: View session statistics including premium requests, session duration, lines of code edited, and token usage per model. / `/usage`：查看会话统计信息，包括高级请求数、会话时长、编辑的代码行数和每个模型的 token 使用量。
- `/context`: Provides a visual overview of your current token usage. / `/context`：提供当前 token 使用情况的可视化概览。
- `/compact`: Manually compresses your conversation history to free up context space. / `/compact`：手动压缩会话历史以释放上下文空间。

GitHub Copilot CLI automatically compresses your history in the background when your conversation approaches 95% of the token limit.

当会话接近 token 限制的 95% 时，GitHub Copilot CLI 会在后台自动压缩历史记录。

### Enable all permissions / 启用所有权限

For situations where you trust Copilot to run freely, you can use the `--allow-all` or `--yolo` flags to enable all permissions at once.

在信任 Copilot 自由运行的情况下，你可以使用 `--allow-all` 或 `--yolo` 标志一次性启用所有权限。

### Toggle reasoning visibility / 切换推理可见性

Press **Ctrl+T** to show or hide the model's reasoning process while it generates a response.

按 **Ctrl+T** 在模型生成响应时显示或隐藏其推理过程。

## Find out more / 了解更多

For a complete list of the command line options and slash commands:

获取完整的命令行选项和斜杠命令列表：

- Enter `?` in the prompt box in an interactive session. / 在交互会话的提示框中输入 `?`。
- Enter `copilot help` in your terminal. / 在终端中输入 `copilot help`。

For additional information use one of the following commands:

获取更多信息，使用以下命令之一：

- **Configuration settings**: `copilot help config` / **配置设置**：`copilot help config`
- **Environment variables**: `copilot help environment` / **环境变量**：`copilot help environment`
- **Available logging levels**: `copilot help logging` / **可用日志级别**：`copilot help logging`
- **Permissions**: `copilot help permissions` / **权限**：`copilot help permissions`

## Feedback / 反馈

Use the `/feedback` slash command in an interactive session to submit feedback, bug reports, or feature suggestions.

在交互会话中使用 `/feedback` 斜杠命令提交反馈、错误报告或功能建议。

## Next steps / 后续步骤

- **Delegate tasks autonomously**: See [Delegating tasks to GitHub Copilot CLI](delegate-tasks-to-cca.md). / **自主委托任务**：请参阅[将任务委托给 GitHub Copilot CLI](delegate-tasks-to-cca.md)。
- **Invoke custom agents**: See [Invoking custom agents](invoke-custom-agents.md). / **调用自定义 Agent**：请参阅[调用自定义 Agent](invoke-custom-agents.md)。
- **Steer agents**: See [Steering agents in GitHub Copilot CLI](steer-agents.md). / **引导 Agent**：请参阅[在 GitHub Copilot CLI 中引导 Agent](steer-agents.md)。
- **Request a code review**: See [Requesting a code review with GitHub Copilot CLI](agentic-code-review.md). / **请求代码审查**：请参阅[使用 GitHub Copilot CLI 请求代码审查](agentic-code-review.md)。

## Further reading / 延伸阅读

- [Best practices for GitHub Copilot CLI](../cli-best-practices.md) / [GitHub Copilot CLI 最佳实践](../cli-best-practices.md)
- [GitHub Copilot CLI command reference](../reference/cli-command-reference.md) / [GitHub Copilot CLI 命令参考](../reference/cli-command-reference.md)
