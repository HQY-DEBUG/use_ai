# Getting Started with GitHub Copilot CLI

## Overview

GitHub Copilot CLI is a powerful terminal-native AI coding assistant that brings agentic capabilities directly to your command line.

## Installation Options

The setup process offers multiple installation methods depending on your operating system:

- **npm (cross-platform)**: Requires Node.js 22 or later
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

## Initial Setup Steps

1. Navigate to your project directory.
2. Run `copilot` to start an interactive session.
3. Authenticate by entering `/login` and following the GitHub account verification prompts.
4. Confirm that the project files are appropriate for AI processing.

Copilot won't make changes to your files without your explicit approval.

## Essential Keyboard Shortcuts

| Key | Purpose |
|-----|---------|
| `Esc` | Cancel current operation |
| `Ctrl+C` | Clear input (press twice to exit) |
| `Ctrl+L` | Clear the screen |
| `@` | Include specific files in context |
| `/` | Display available slash commands |
| `?` | Open help documentation |
| `Shift+Tab` | Cycle through modes (standard, plan, autopilot) |

Access the complete list via `/help` or see the [CLI command reference](reference/cli-command-reference.md).

## Non-Interactive Usage

For scripted workflows, use the `-p` flag to submit prompts directly:

```shell
copilot -p "Explain what this function does"
```

Adding `-s` outputs only the response, omitting supplementary information, enabling programmatic integration:

```shell
copilot -p "Summarize this file" -s
```

## Next Steps

- [Installing GitHub Copilot CLI](set-up-copilot-cli/install-copilot-cli.md)
- [Authenticating GitHub Copilot CLI](set-up-copilot-cli/authenticate-copilot-cli.md)
- [Using GitHub Copilot CLI](use-copilot-cli-agents/overview.md)
- [Best practices for GitHub Copilot CLI](cli-best-practices.md)
