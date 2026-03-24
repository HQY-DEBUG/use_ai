# Installing GitHub Copilot CLI

Learn how to set up Copilot CLI for command-line usage.

## Prerequisites

To install Copilot CLI, you'll need:

* An active GitHub Copilot subscription
* PowerShell v6 or higher (Windows only)

Organization or enterprise users should verify that their administrator hasn't disabled Copilot CLI in settings.

## Installation Methods

You have four options for installing Copilot CLI:

**npm (all platforms)** — Requires Node.js 22+
```shell
npm install -g @github/copilot
```

If your `~/.npmrc` file contains `ignore-scripts=true`, use:
```shell
npm_config_ignore_scripts=false npm install -g @github/copilot
```

**WinGet (Windows)**
```powershell
winget install GitHub.Copilot
```

**Homebrew (macOS and Linux)**
```shell
brew install copilot-cli
```

**Install script (macOS and Linux)**
```shell
curl -fsSL https://gh.io/copilot-install | bash
```

You can also specify custom installation parameters with environment variables (`PREFIX` and `VERSION`).

Alternatively, download executables directly from the GitHub repository releases page.

## Authentication

On first launch, use the `/login` slash command to authenticate via GitHub. You can also authenticate using a fine-grained personal access token with "Copilot Requests" permission by exporting it as `COPILOT_GITHUB_TOKEN`, `GH_TOKEN`, or `GITHUB_TOKEN`.

## Getting Started

After installation and authentication, you're ready to use Copilot from your terminal.
