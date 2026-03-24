# GitHub Copilot CLI Command Reference

## Overview

GitHub Copilot CLI is the official command-line interface for GitHub Copilot. This comprehensive reference covers commands, shortcuts, configurations, and advanced features for effective usage.

## Command-Line Commands

| Command | Purpose |
|---------|---------|
| `copilot` | Launch interactive user interface |
| `copilot help [topic]` | Display help on config, commands, environment, logging, permissions |
| `copilot init` | Initialize custom instructions for repository |
| `copilot update` | Download and install latest version |
| `copilot version` | Display version and check for updates |
| `copilot login` | Authenticate via OAuth device flow |
| `copilot logout` | Sign out and remove credentials |
| `copilot plugin` | Manage plugins and marketplaces |

## Global Interactive Shortcuts

| Shortcut | Purpose |
|----------|---------|
| `@ FILENAME` | Include file contents in context |
| `Ctrl+X` then `/` | Run slash command mid-prompt |
| `Esc` | Cancel current operation |
| `! COMMAND` | Execute shell command, bypassing Copilot |
| `Ctrl+C` | Cancel or clear input (press twice to exit) |
| `Ctrl+D` | Shutdown |
| `Ctrl+L` | Clear screen |
| `Shift+Tab` | Cycle through modes (standard, plan, autopilot) |

## Timeline Shortcuts

| Shortcut | Purpose |
|----------|---------|
| `Ctrl+O` | Expand recent items in response timeline |
| `Ctrl+E` | Expand all timeline items |
| `Ctrl+T` | Toggle reasoning display |

## Navigation Shortcuts

| Shortcut | Purpose |
|----------|---------|
| `Ctrl+A` | Move to line beginning |
| `Ctrl+E` | Move to line end |
| `Ctrl+B` | Previous character |
| `Ctrl+F` | Next character |
| `Ctrl+G` | Edit prompt in external editor |
| `Ctrl+H` | Delete previous character |
| `Ctrl+K` | Delete cursor to line end |
| `Ctrl+U` | Delete cursor to line beginning |
| `Ctrl+W` | Delete previous word |
| `Home` / `End` | Line boundaries |
| `Ctrl+Home` / `Ctrl+End` | Text boundaries |
| `Meta+←/→` | Move by word |
| `↑/↓` | Navigate command history |

## Slash Commands

### Context & Session Management

| Command | Purpose |
|---------|---------|
| `/clear`, `/new` | Clear conversation history |
| `/context` | Show token usage and visualization |
| `/cwd`, `/cd [PATH]` | Change or display working directory |
| `/session` | Show session info and workspace summary |
| `/resume [SESSION-ID]` | Switch to different session |
| `/rename NAME` | Rename current session |
| `/share [file\|gist] [PATH]` | Share to Markdown file or gist |

### Code & Review

| Command | Purpose |
|---------|---------|
| `/diff` | Review changes in current directory |
| `/review [PROMPT]` | Run code review agent |
| `/plan [PROMPT]` | Create implementation plan |
| `/delegate [PROMPT]` | Create AI-generated pull request |

### Configuration & Tools

| Command | Purpose |
|---------|---------|
| `/add-dir PATH` | Add directory to allowed file access |
| `/allow-all`, `/yolo` | Enable all permissions |
| `/list-dirs` | Display allowed directories |
| `/reset-allowed-tools` | Reset tool permissions |
| `/model`, `/models [MODEL]` | Select AI model |
| `/agent` | Browse available agents |
| `/init` | Initialize custom instructions |
| `/help` | Show interactive command help |

### Advanced Features

| Command | Purpose |
|---------|---------|
| `/compact` | Summarize history to reduce context |
| `/usage` | Display session metrics |
| `/fleet [PROMPT]` | Enable parallel subagent execution |
| `/tasks` | View background tasks from /fleet |
| `/experimental [on\|off]` | Toggle experimental features |
| `/feedback` | Provide CLI feedback |
| `/ide` | Connect to IDE workspace |
| `/login`, `/logout` | Manage authentication |
| `/exit`, `/quit` | Exit CLI |

### Plugin & Skill Management

| Command | Purpose |
|---------|---------|
| `/plugin [marketplace\|install\|uninstall\|update\|list]` | Manage plugins |
| `/skills [list\|info\|add\|remove\|reload]` | Manage skills |
| `/lsp [show\|test\|reload\|help]` | Manage language server config |
| `/mcp [show\|add\|edit\|delete\|disable\|enable]` | Manage MCP servers |

### Terminal & Theme

| Command | Purpose |
|---------|---------|
| `/terminal-setup` | Configure multiline input support |
| `/theme [show\|set\|list]` | View or configure terminal theme |
| `/user [show\|list\|switch]` | Manage GitHub user |

## Command-Line Options

### Execution Mode

| Option | Purpose |
|--------|---------|
| `-p PROMPT`, `--prompt=PROMPT` | Execute prompt programmatically |
| `-i PROMPT`, `--interactive=PROMPT` | Start interactive session with auto-execute |
| `--continue` | Resume most recent session |
| `--resume=SESSION-ID` | Resume specific session |
| `--autopilot` | Enable autonomous continuation |
| `--acp` | Start Agent Client Protocol server |

### Permissions & Access

| Option | Purpose |
|--------|---------|
| `--allow-all` | Enable all permissions |
| `--allow-all-paths` | Disable file path verification |
| `--allow-all-tools` | Allow all tools without confirmation |
| `--allow-all-urls` | Allow all URLs |
| `--allow-tool=TOOL ...` | Permit specific tools |
| `--allow-url=URL ...` | Permit specific URLs/domains |
| `--deny-tool=TOOL ...` | Block specific tools |
| `--deny-url=URL ...` | Block specific URLs |
| `--add-dir=PATH` | Add directory to allowed list |

### Configuration

| Option | Purpose |
|--------|---------|
| `--model=MODEL` | Set AI model |
| `--config-dir=PATH` | Set configuration directory |
| `--log-dir=DIRECTORY` | Set log file directory |
| `--log-level=LEVEL` | Set logging verbosity |
| `--alt-screen=VALUE` | Use terminal alternate screen |
| `--no-custom-instructions` | Disable custom instructions |
| `--experimental` | Enable experimental features |
| `--no-experimental` | Disable experimental features |

### Tool Configuration

| Option | Purpose |
|--------|---------|
| `--available-tools=TOOL ...` | Limit available tools |
| `--excluded-tools=TOOL ...` | Exclude specific tools |
| `--disable-builtin-mcps` | Disable all built-in MCP servers |
| `--disable-mcp-server=SERVER-NAME` | Disable specific MCP server |
| `--additional-mcp-config=JSON` | Add MCP server for session |
| `--add-github-mcp-tool=TOOL` | Enable GitHub MCP tool |
| `--add-github-mcp-toolset=TOOLSET` | Enable GitHub MCP toolset |
| `--enable-all-github-mcp-tools` | Enable all GitHub tools |
| `--disable-parallel-tools-execution` | Disable parallel tool execution |

### Output & Display

| Option | Purpose |
|--------|---------|
| `-s`, `--silent` | Output only agent response |
| `--output-format=FORMAT` | Text (default) or JSON (JSONL) |
| `--no-color` | Disable color output |
| `--plain-diff` | Disable rich diff rendering |
| `--banner` | Show startup banner |
| `--screen-reader` | Enable screen reader optimizations |
| `--stream=MODE` | Enable or disable streaming |

### Other Options

| Option | Purpose |
|--------|---------|
| `-h`, `--help` | Display help |
| `-v`, `--version` | Show version info |
| `--max-autopilot-continues=COUNT` | Limit autopilot messages |
| `--no-ask-user` | Disable user prompts |
| `--no-auto-update` | Disable automatic updates |
| `--yolo` | Enable all permissions (alias for --allow-all) |
| `--agent=AGENT` | Specify custom agent |
| `--share=PATH` | Share session after completion |
| `--share-gist` | Share to secret GitHub gist |
| `--secret-env-vars=VAR ...` | Redact environment variables |

## Tool Permission Patterns

Use format `Kind(argument)` with optional arguments:

| Kind | Pattern Examples |
|------|------------------|
| `shell` | `shell(git push)`, `shell(git:*)`, `shell` |
| `write` | `write`, `write(src/*.ts)` |
| `read` | `read`, `read(.env)` |
| `SERVER-NAME` | `MyMCP(create_issue)`, `MyMCP` |
| `url` | `url(github.com)`, `url(https://*.api.com)` |
| `memory` | `memory` |

**Note:** The `:*` suffix matches command stem plus space, preventing partial matches. Deny rules always take precedence.

## Environment Variables

| Variable | Description |
|----------|-------------|
| `COPILOT_MODEL` | Set AI model |
| `COPILOT_ALLOW_ALL` | Enable all permissions (set to `true`) |
| `COPILOT_AUTO_UPDATE` | Disable updates (set to `false`) |
| `COPILOT_CUSTOM_INSTRUCTIONS_DIRS` | Additional custom instruction directories |
| `COPILOT_SKILLS_DIRS` | Additional skills directories |
| `COPILOT_EDITOR` | External editor command |
| `COPILOT_GITHUB_TOKEN` | Authentication token (highest priority) |
| `GH_TOKEN` | GitHub token (second priority) |
| `GITHUB_TOKEN` | GitHub token (lowest priority) |
| `COPILOT_HOME` | Override config/state directory |
| `USE_BUILTIN_RIPGREP` | Use system ripgrep (set to `false`) |
| `PLAIN_DIFF` | Disable rich diffs (set to `true`) |

## Configuration Files

### Scope Hierarchy

Settings cascade: Command-line > Environment > Local > Repository > User. More specific scopes override general ones.

### User Configuration (`~/.copilot/config.json`)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `allowed_urls` | string[] | [] | URLs allowed without prompting |
| `alt_screen` | boolean | false | Use terminal alternate screen |
| `auto_update` | boolean | true | Automatic CLI updates |
| `banner` | "always" / "once" / "never" | "once" | Banner display frequency |
| `experimental` | boolean | false | Enable experimental features |
| `log_level` | string | "default" | Logging verbosity |
| `model` | string | varies | AI model (see `/model` command) |
| `reasoning_effort` | "low" / "medium" / "high" / "xhigh" | "medium" | Extended thinking level |
| `render_markdown` | boolean | true | Render Markdown in output |
| `stream` | boolean | true | Enable streaming responses |
| `theme` | "auto" / "dark" / "light" | "auto" | Terminal color theme |
| `trusted_folders` | string[] | [] | Folders with pre-granted access |

### Repository Configuration (`.github/copilot/settings.json`)

Repository-wide settings applying to all users:

| Key | Type | Description |
|-----|------|-------------|
| `companyAnnouncements` | string[] | Startup messages |
| `enabledPlugins` | Record<string, boolean> | Plugin auto-install |
| `extraKnownMarketplaces` | Record<string, {...}> | Plugin marketplaces |

### Local Configuration (`.github/copilot/settings.local.json`)

Personal repository overrides (add to `.gitignore`). Uses same schema as repository settings with higher precedence.

## Hook Events Reference

| Event | Triggers When | Output Processed |
|-------|---------------|------------------|
| `sessionStart` | New or resumed session | No |
| `sessionEnd` | Session terminates | No |
| `userPromptSubmitted` | User submits prompt | No |
| `preToolUse` | Before tool execution | Yes—can allow/deny/modify |
| `postToolUse` | After tool completes | No |
| `agentStop` | Main agent finishes turn | Yes—can block/continue |
| `subagentStop` | Subagent completes | Yes—can block/continue |
| `errorOccurred` | Error during execution | No |

## Permission Approval Responses

When prompted for operation approval:

| Key | Effect |
|-----|--------|
| `y` | Allow this specific request once |
| `n` | Deny this specific request once |
| `!` | Allow all similar requests this session |
| `#` | Deny all similar requests this session |
| `?` | Show detailed request information |

Session approvals reset with `/clear` or new session.

## Feature Flags

| Flag | Description |
|------|-------------|
| `AUTOPILOT_MODE` | Autonomous operation |
| `LSP_TOOLS` | Language Server Protocol tools |
| `PLAN_COMMAND` | Interactive planning mode |
| `AGENTIC_MEMORY` | Persistent cross-session memory |
| `CUSTOM_AGENTS` | Custom agent definitions |

## OpenTelemetry Monitoring

Copilot CLI exports traces and metrics via OpenTelemetry. OTel is off by default and activates with environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `COPILOT_OTEL_ENABLED` | false | Explicitly enable OTel |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | — | OTLP endpoint URL |
| `COPILOT_OTEL_EXPORTER_TYPE` | otlp-http | Exporter type |
| `OTEL_SERVICE_NAME` | github-copilot | Service name in resources |
| `OTEL_INSTRUMENTATION_GENAI_CAPTURE_MESSAGE_CONTENT` | false | Capture full prompts/responses |
| `COPILOT_OTEL_FILE_EXPORTER_PATH` | — | Write signals to JSON-lines file |

> **Warning:** Content capture may include sensitive information such as code and file contents. Only enable in trusted environments.
