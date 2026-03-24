# Using GitHub Copilot CLI

Learn how to use GitHub Copilot from the command line.

The command-line interface (CLI) for GitHub Copilot allows you to use Copilot directly from your terminal.

## Prerequisite

Install Copilot CLI. See [Installing GitHub Copilot CLI](../set-up-copilot-cli/install-copilot-cli.md).

## Using Copilot CLI

1. In your terminal, navigate to a folder that contains code you want to work with.

2. Enter `copilot` to start Copilot CLI.

   Copilot will ask you to confirm that you trust the files in this folder.

   > **IMPORTANT**: During this GitHub Copilot CLI session, Copilot may attempt to read, modify, and execute files in and below this folder. You should only proceed if you trust the files in this location.

3. Choose one of the options:

   - **Yes, proceed**: Copilot can work with the files in this location for this session only.
   - **Yes, and remember this folder for future sessions**: You trust the files in this folder for this and future sessions. You won't be asked again when you start Copilot CLI from this folder. Only choose this option if you are sure that it will always be safe for Copilot to work with files in this location.
   - **No, exit (Esc)**: End your Copilot CLI session.

4. If you are not currently logged in to GitHub, you'll be prompted to use the `/login` slash command. Enter this command and follow the on-screen instructions to authenticate.

5. Enter a prompt in the CLI.

   This can be a simple chat question, or a request for Copilot to perform a specific task, such as fixing a bug, adding a feature to an existing application, or creating a new application.

6. When Copilot wants to use a tool that could modify or execute files—for example, `touch`, `chmod`, `node`, or `sed`—it will ask you to approve the use of the tool.

   Choose one of the options:

   - **Yes**: Allow Copilot to use this tool. The next time Copilot wants to use this tool, it will ask you to approve it again.
   - **Yes, and approve TOOL for the rest of the running session**: Allow Copilot to use this tool—with any options—without asking again, for the rest of the currently running session.
   - **No, and tell Copilot what to do differently (Esc)**: Copilot will not run the command. Instead, it ends the current operation and awaits your next prompt.

## Tips

### Stop a currently running operation

If you enter a prompt and then decide you want to stop Copilot from completing the task while it is still "Thinking," press **Esc**.

### Use plan mode

Plan mode lets you collaborate with Copilot on an implementation plan before any code is written. Press **Shift+Tab** to cycle in and out of plan mode.

### Include a specific file in your prompt

To add a specific file to your prompt, use `@` followed by the relative path to the file. For example: `Explain @config/ci/ci-required-checks.yml` or `Fix the bug in @src/app.js`.

When you start typing a file path, the matching paths are displayed below the prompt box. Use the arrow keys to select a path and press **Tab** to complete the path in your prompt.

### Work with files in a different location

You can also add a trusted directory manually at any time by using the slash command:

```shell
/add-dir /path/to/directory
```

If all of the files you want to work with are in a different location, you can switch the current working directory without starting a new Copilot CLI session by using either the `/cwd` or `/cd` slash commands:

```shell
/cwd /path/to/directory
```

### Run shell commands

You can prepend your input with `!` to directly run shell commands, without making a call to the model.

```shell
!git clone https://github.com/github/copilot-cli
```

### Resume an interactive session

You can use the `--resume` command-line option or the `/resume` slash command to select and resume an interactive CLI session.

> **TIP**: To quickly resume the most recently closed local session, enter this in your terminal:
>
> ```shell
> copilot --continue
> ```

### Use custom instructions

You can enhance Copilot's performance by adding custom instructions to the repository you are working in. Copilot CLI supports:

- Repository-wide instructions in the `.github/copilot-instructions.md` file.
- Path-specific instructions files: `.github/instructions/**/*.instructions.md`.
- Agent files such as `AGENTS.md`.

For more information, see [Adding custom instructions for GitHub Copilot CLI](../customize-copilot/add-custom-instructions.md).

### Use custom agents

A custom agent is a specialized version of Copilot. Copilot CLI includes a default group of custom agents for common tasks:

| Agent | Description |
|-------|-------------|
| Explore | Performs quick codebase analysis, allowing you to ask questions about your code without adding to your main context. |
| Task | Executes commands such as tests and builds, providing brief summaries on success and full output on failure. |
| General-purpose | Handles complex, multi-step tasks that require the full toolset and high-quality reasoning, running in a separate context to keep your main conversation clearly focused. |
| Code-review | Reviews changes with a focus on surfacing only genuine issues, minimizing noise. |

You can define custom agents at the user, repository, or organization/enterprise level:

| Type | Location | Scope |
|------|----------|-------|
| User-level custom agent | local `~/.copilot/agents` directory | All projects |
| Repository-level custom agent | `.github/agents` directory in your local and remote repositories | Current project |
| Organization and Enterprise-level custom agent | `/agents` directory in the `.github-private` repository | All projects under your organization and enterprise account |

Custom agents can be used in three ways:

- Using the slash command: `/agent`
- Calling out to custom agent directly in a prompt: `Use the refactoring agent to refactor this code block`
- Specifying the custom agent with the command-line option:

  ```shell
  copilot --agent=refactor-agent --prompt "Refactor this code block"
  ```

### Use skills

You can create skills to enhance the ability of Copilot to perform specialized tasks with instructions, scripts, and resources.

For more information, see [Creating agent skills for GitHub Copilot CLI](../customize-copilot/create-skills.md).

### Add an MCP server

Copilot CLI comes with the GitHub MCP server already configured. To add more MCP servers:

1. Use the following slash command: `/mcp add`
2. Fill in the details for the MCP server you want to add, using the **Tab** key to move between fields.
3. Press **Ctrl+S** to save the details.

Details of your configured MCP servers are stored in the `mcp-config.json` file, located by default in the `~/.copilot` directory.

### Context management

Copilot CLI provides several slash commands to help you monitor and manage your context window:

- `/usage`: View session statistics including premium requests, session duration, lines of code edited, and token usage per model.
- `/context`: Provides a visual overview of your current token usage.
- `/compact`: Manually compresses your conversation history to free up context space.

GitHub Copilot CLI automatically compresses your history in the background when your conversation approaches 95% of the token limit.

### Enable all permissions

For situations where you trust Copilot to run freely, you can use the `--allow-all` or `--yolo` flags to enable all permissions at once.

### Toggle reasoning visibility

Press **Ctrl+T** to show or hide the model's reasoning process while it generates a response.

## Find out more

For a complete list of the command line options and slash commands:

- Enter `?` in the prompt box in an interactive session.
- Enter `copilot help` in your terminal.

For additional information use one of the following commands:

- **Configuration settings**: `copilot help config`
- **Environment variables**: `copilot help environment`
- **Available logging levels**: `copilot help logging`
- **Permissions**: `copilot help permissions`

## Feedback

Use the `/feedback` slash command in an interactive session to submit feedback, bug reports, or feature suggestions.

## Next steps

- **Delegate tasks autonomously**: See [Delegating tasks to GitHub Copilot CLI](delegate-tasks-to-cca.md).
- **Invoke custom agents**: See [Invoking custom agents](invoke-custom-agents.md).
- **Steer agents**: See [Steering agents in GitHub Copilot CLI](steer-agents.md).
- **Request a code review**: See [Requesting a code review with GitHub Copilot CLI](agentic-code-review.md).

## Further reading

- [Best practices for GitHub Copilot CLI](../cli-best-practices.md)
- [GitHub Copilot CLI command reference](../reference/cli-command-reference.md)
