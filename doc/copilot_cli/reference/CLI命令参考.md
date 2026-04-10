# GitHub Copilot CLI Command Reference / GitHub Copilot CLI 命令参考

## Overview / 概述

GitHub Copilot CLI is the official command-line interface for GitHub Copilot. This comprehensive reference covers commands, shortcuts, configurations, and advanced features for effective usage.

GitHub Copilot CLI 是 GitHub Copilot 的官方命令行界面。本全面参考涵盖命令、快捷键、配置和高级功能，以便有效使用。

## Command-Line Commands / 命令行命令

| Command / 命令 | Purpose / 用途 |
|---------|---------|
| `copilot` | Launch interactive user interface / 启动交互式用户界面 |
| `copilot help [topic]` | Display help on config, commands, environment, logging, permissions / 显示配置、命令、环境、日志、权限的帮助 |
| `copilot init` | Initialize custom instructions for repository / 为仓库初始化自定义指令 |
| `copilot update` | Download and install latest version / 下载并安装最新版本 |
| `copilot version` | Display version and check for updates / 显示版本并检查更新 |
| `copilot login` | Authenticate via OAuth device flow / 通过 OAuth 设备流进行身份验证 |
| `copilot logout` | Sign out and remove credentials / 登出并移除凭据 |
| `copilot plugin` | Manage plugins and marketplaces / 管理插件和市场 |

## Global Interactive Shortcuts / 全局交互快捷键

| Shortcut / 快捷键 | Purpose / 用途 |
|----------|---------|
| `@ FILENAME` | Include file contents in context / 在上下文中包含文件内容 |
| `Ctrl+X` then `/` | Run slash command mid-prompt / 在提示词中间运行斜杠命令 |
| `Esc` | Cancel current operation / 取消当前操作 |
| `! COMMAND` | Execute shell command, bypassing Copilot / 执行 Shell 命令，绕过 Copilot |
| `Ctrl+C` | Cancel or clear input (press twice to exit) / 取消或清除输入（按两次退出） |
| `Ctrl+D` | Shutdown / 关闭 |
| `Ctrl+L` | Clear screen / 清屏 |
| `Shift+Tab` | Cycle through modes (standard, plan, autopilot) / 循环切换模式（标准、计划、自动驾驶） |

## Timeline Shortcuts / 时间轴快捷键

| Shortcut / 快捷键 | Purpose / 用途 |
|----------|---------|
| `Ctrl+O` | Expand recent items in response timeline / 展开响应时间轴中的最近项 |
| `Ctrl+E` | Expand all timeline items / 展开所有时间轴项 |
| `Ctrl+T` | Toggle reasoning display / 切换推理显示 |

## Navigation Shortcuts / 导航快捷键

| Shortcut / 快捷键 | Purpose / 用途 |
|----------|---------|
| `Ctrl+A` | Move to line beginning / 移至行首 |
| `Ctrl+E` | Move to line end / 移至行尾 |
| `Ctrl+B` | Previous character / 前一个字符 |
| `Ctrl+F` | Next character / 后一个字符 |
| `Ctrl+G` | Edit prompt in external editor / 在外部编辑器中编辑提示词 |
| `Ctrl+H` | Delete previous character / 删除前一个字符 |
| `Ctrl+K` | Delete cursor to line end / 从光标删除至行尾 |
| `Ctrl+U` | Delete cursor to line beginning / 从光标删除至行首 |
| `Ctrl+W` | Delete previous word / 删除前一个单词 |
| `Home` / `End` | Line boundaries / 行边界 |
| `Ctrl+Home` / `Ctrl+End` | Text boundaries / 文本边界 |
| `Meta+←/→` | Move by word / 按单词移动 |
| `↑/↓` | Navigate command history / 导航命令历史 |

## Slash Commands / 斜杠命令

### Context & Session Management / 上下文和会话管理

| Command / 命令 | Purpose / 用途 |
|---------|---------|
| `/clear`, `/new` | Clear conversation history / 清除会话历史 |
| `/context` | Show token usage and visualization / 显示 token 使用量和可视化 |
| `/cwd`, `/cd [PATH]` | Change or display working directory / 更改或显示工作目录 |
| `/session` | Show session info and workspace summary / 显示会话信息和工作区摘要 |
| `/resume [SESSION-ID]` | Switch to different session / 切换到不同会话 |
| `/rename NAME` | Rename current session / 重命名当前会话 |
| `/share [file\|gist] [PATH]` | Share to Markdown file or gist / 共享到 Markdown 文件或 gist |

### Code & Review / 代码和审查

| Command / 命令 | Purpose / 用途 |
|---------|---------|
| `/diff` | Review changes in current directory / 审查当前目录中的更改 |
| `/review [PROMPT]` | Run code review agent / 运行代码审查 Agent |
| `/plan [PROMPT]` | Create implementation plan / 创建实施计划 |
| `/delegate [PROMPT]` | Create AI-generated pull request / 创建 AI 生成的 Pull Request |

### Configuration & Tools / 配置和工具

| Command / 命令 | Purpose / 用途 |
|---------|---------|
| `/add-dir PATH` | Add directory to allowed file access / 将目录添加到允许的文件访问列表 |
| `/allow-all`, `/yolo` | Enable all permissions / 启用所有权限 |
| `/list-dirs` | Display allowed directories / 显示允许的目录 |
| `/reset-allowed-tools` | Reset tool permissions / 重置工具权限 |
| `/model`, `/models [MODEL]` | Select AI model / 选择 AI 模型 |
| `/agent` | Browse available agents / 浏览可用 Agent |
| `/init` | Initialize custom instructions / 初始化自定义指令 |
| `/help` | Show interactive command help / 显示交互式命令帮助 |

### Advanced Features / 高级功能

| Command / 命令 | Purpose / 用途 |
|---------|---------|
| `/compact` | Summarize history to reduce context / 摘要历史以减少上下文 |
| `/usage` | Display session metrics / 显示会话指标 |
| `/fleet [PROMPT]` | Enable parallel subagent execution / 启用并行子 Agent 执行 |
| `/tasks` | View background tasks from /fleet / 查看 /fleet 的后台任务 |
| `/experimental [on\|off]` | Toggle experimental features / 切换实验性功能 |
| `/feedback` | Provide CLI feedback / 提供 CLI 反馈 |
| `/ide` | Connect to IDE workspace / 连接到 IDE 工作区 |
| `/login`, `/logout` | Manage authentication / 管理身份验证 |
| `/exit`, `/quit` | Exit CLI / 退出 CLI |

### Plugin & Skill Management / 插件和技能管理

| Command / 命令 | Purpose / 用途 |
|---------|---------|
| `/plugin [marketplace\|install\|uninstall\|update\|list]` | Manage plugins / 管理插件 |
| `/skills [list\|info\|add\|remove\|reload]` | Manage skills / 管理技能 |
| `/lsp [show\|test\|reload\|help]` | Manage language server config / 管理语言服务器配置 |
| `/mcp [show\|add\|edit\|delete\|disable\|enable]` | Manage MCP servers / 管理 MCP 服务器 |

### Terminal & Theme / 终端和主题

| Command / 命令 | Purpose / 用途 |
|---------|---------|
| `/terminal-setup` | Configure multiline input support / 配置多行输入支持 |
| `/theme [show\|set\|list]` | View or configure terminal theme / 查看或配置终端主题 |
| `/user [show\|list\|switch]` | Manage GitHub user / 管理 GitHub 用户 |

## Command-Line Options / 命令行选项

### Execution Mode / 执行模式

| Option / 选项 | Purpose / 用途 |
|--------|---------|
| `-p PROMPT`, `--prompt=PROMPT` | Execute prompt programmatically / 以编程方式执行提示词 |
| `-i PROMPT`, `--interactive=PROMPT` | Start interactive session with auto-execute / 启动带自动执行的交互会话 |
| `--continue` | Resume most recent session / 恢复最近的会话 |
| `--resume=SESSION-ID` | Resume specific session / 恢复特定会话 |
| `--autopilot` | Enable autonomous continuation / 启用自主继续 |
| `--acp` | Start Agent Client Protocol server / 启动 Agent 客户端协议服务器 |

### Permissions & Access / 权限和访问

| Option / 选项 | Purpose / 用途 |
|--------|---------|
| `--allow-all` | Enable all permissions / 启用所有权限 |
| `--allow-all-paths` | Disable file path verification / 禁用文件路径验证 |
| `--allow-all-tools` | Allow all tools without confirmation / 允许所有工具无需确认 |
| `--allow-all-urls` | Allow all URLs / 允许所有 URL |
| `--allow-tool=TOOL ...` | Permit specific tools / 允许特定工具 |
| `--allow-url=URL ...` | Permit specific URLs/domains / 允许特定 URL/域名 |
| `--deny-tool=TOOL ...` | Block specific tools / 阻止特定工具 |
| `--deny-url=URL ...` | Block specific URLs / 阻止特定 URL |
| `--add-dir=PATH` | Add directory to allowed list / 将目录添加到允许列表 |

### Configuration / 配置

| Option / 选项 | Purpose / 用途 |
|--------|---------|
| `--model=MODEL` | Set AI model / 设置 AI 模型 |
| `--config-dir=PATH` | Set configuration directory / 设置配置目录 |
| `--log-dir=DIRECTORY` | Set log file directory / 设置日志文件目录 |
| `--log-level=LEVEL` | Set logging verbosity / 设置日志详细程度 |
| `--alt-screen=VALUE` | Use terminal alternate screen / 使用终端备用屏幕 |
| `--no-custom-instructions` | Disable custom instructions / 禁用自定义指令 |
| `--experimental` | Enable experimental features / 启用实验性功能 |
| `--no-experimental` | Disable experimental features / 禁用实验性功能 |

### Tool Configuration / 工具配置

| Option / 选项 | Purpose / 用途 |
|--------|---------|
| `--available-tools=TOOL ...` | Limit available tools / 限制可用工具 |
| `--excluded-tools=TOOL ...` | Exclude specific tools / 排除特定工具 |
| `--disable-builtin-mcps` | Disable all built-in MCP servers / 禁用所有内置 MCP 服务器 |
| `--disable-mcp-server=SERVER-NAME` | Disable specific MCP server / 禁用特定 MCP 服务器 |
| `--additional-mcp-config=JSON` | Add MCP server for session / 为会话添加 MCP 服务器 |
| `--add-github-mcp-tool=TOOL` | Enable GitHub MCP tool / 启用 GitHub MCP 工具 |
| `--add-github-mcp-toolset=TOOLSET` | Enable GitHub MCP toolset / 启用 GitHub MCP 工具集 |
| `--enable-all-github-mcp-tools` | Enable all GitHub tools / 启用所有 GitHub 工具 |
| `--disable-parallel-tools-execution` | Disable parallel tool execution / 禁用并行工具执行 |

### Output & Display / 输出和显示

| Option / 选项 | Purpose / 用途 |
|--------|---------|
| `-s`, `--silent` | Output only agent response / 仅输出 Agent 响应 |
| `--output-format=FORMAT` | Text (default) or JSON (JSONL) / 文本（默认）或 JSON（JSONL） |
| `--no-color` | Disable color output / 禁用彩色输出 |
| `--plain-diff` | Disable rich diff rendering / 禁用富文本差异渲染 |
| `--banner` | Show startup banner / 显示启动横幅 |
| `--screen-reader` | Enable screen reader optimizations / 启用屏幕阅读器优化 |
| `--stream=MODE` | Enable or disable streaming / 启用或禁用流式传输 |

### Other Options / 其他选项

| Option / 选项 | Purpose / 用途 |
|--------|---------|
| `-h`, `--help` | Display help / 显示帮助 |
| `-v`, `--version` | Show version info / 显示版本信息 |
| `--max-autopilot-continues=COUNT` | Limit autopilot messages / 限制自动驾驶消息数 |
| `--no-ask-user` | Disable user prompts / 禁用用户提示 |
| `--no-auto-update` | Disable automatic updates / 禁用自动更新 |
| `--yolo` | Enable all permissions (alias for --allow-all) / 启用所有权限（--allow-all 的别名） |
| `--agent=AGENT` | Specify custom agent / 指定自定义 Agent |
| `--share=PATH` | Share session after completion / 完成后共享会话 |
| `--share-gist` | Share to secret GitHub gist / 共享到私密 GitHub gist |
| `--secret-env-vars=VAR ...` | Redact environment variables / 脱敏环境变量 |

## Tool Permission Patterns / 工具权限模式

Use format `Kind(argument)` with optional arguments:

使用 `Kind(argument)` 格式，参数可选：

| Kind / 类型 | Pattern Examples / 模式示例 |
|------|------------------|
| `shell` | `shell(git push)`, `shell(git:*)`, `shell` |
| `write` | `write`, `write(src/*.ts)` |
| `read` | `read`, `read(.env)` |
| `SERVER-NAME` | `MyMCP(create_issue)`, `MyMCP` |
| `url` | `url(github.com)`, `url(https://*.api.com)` |
| `memory` | `memory` |

**Note:** The `:*` suffix matches command stem plus space, preventing partial matches. Deny rules always take precedence.

**注意：** `:*` 后缀匹配命令词干加空格，防止部分匹配。拒绝规则始终优先。

## Environment Variables / 环境变量

| Variable / 变量 | Description / 说明 |
|----------|-------------|
| `COPILOT_MODEL` | Set AI model / 设置 AI 模型 |
| `COPILOT_ALLOW_ALL` | Enable all permissions (set to `true`) / 启用所有权限（设为 `true`） |
| `COPILOT_AUTO_UPDATE` | Disable updates (set to `false`) / 禁用更新（设为 `false`） |
| `COPILOT_CUSTOM_INSTRUCTIONS_DIRS` | Additional custom instruction directories / 额外的自定义指令目录 |
| `COPILOT_SKILLS_DIRS` | Additional skills directories / 额外的技能目录 |
| `COPILOT_EDITOR` | External editor command / 外部编辑器命令 |
| `COPILOT_GITHUB_TOKEN` | Authentication token (highest priority) / 身份验证令牌（最高优先级） |
| `GH_TOKEN` | GitHub token (second priority) / GitHub 令牌（第二优先级） |
| `GITHUB_TOKEN` | GitHub token (lowest priority) / GitHub 令牌（最低优先级） |
| `COPILOT_HOME` | Override config/state directory / 覆盖配置/状态目录 |
| `USE_BUILTIN_RIPGREP` | Use system ripgrep (set to `false`) / 使用系统 ripgrep（设为 `false`） |
| `PLAIN_DIFF` | Disable rich diffs (set to `true`) / 禁用富文本差异（设为 `true`） |

## Configuration Files / 配置文件

### Scope Hierarchy / 作用域层次

Settings cascade: Command-line > Environment > Local > Repository > User. More specific scopes override general ones.

设置级联：命令行 > 环境 > 本地 > 仓库 > 用户。更具体的作用域覆盖更通用的作用域。

### User Configuration (`~/.copilot/config.json`) / 用户配置

| Key / 键 | Type / 类型 | Default / 默认值 | Description / 说明 |
|-----|------|---------|-------------|
| `allowed_urls` | string[] | [] | URLs allowed without prompting / 无需提示即允许的 URL |
| `alt_screen` | boolean | false | Use terminal alternate screen / 使用终端备用屏幕 |
| `auto_update` | boolean | true | Automatic CLI updates / CLI 自动更新 |
| `banner` | "always" / "once" / "never" | "once" | Banner display frequency / 横幅显示频率 |
| `experimental` | boolean | false | Enable experimental features / 启用实验性功能 |
| `log_level` | string | "default" | Logging verbosity / 日志详细程度 |
| `model` | string | varies | AI model (see `/model` command) / AI 模型（见 `/model` 命令） |
| `reasoning_effort` | "low" / "medium" / "high" / "xhigh" | "medium" | Extended thinking level / 扩展思考级别 |
| `render_markdown` | boolean | true | Render Markdown in output / 在输出中渲染 Markdown |
| `stream` | boolean | true | Enable streaming responses / 启用流式响应 |
| `theme` | "auto" / "dark" / "light" | "auto" | Terminal color theme / 终端颜色主题 |
| `trusted_folders` | string[] | [] | Folders with pre-granted access / 预先授权访问的文件夹 |

### Repository Configuration (`.github/copilot/settings.json`) / 仓库配置

Repository-wide settings applying to all users:

适用于所有用户的仓库范围设置：

| Key / 键 | Type / 类型 | Description / 说明 |
|-----|------|-------------|
| `companyAnnouncements` | string[] | Startup messages / 启动消息 |
| `enabledPlugins` | Record<string, boolean> | Plugin auto-install / 插件自动安装 |
| `extraKnownMarketplaces` | Record<string, {...}> | Plugin marketplaces / 插件市场 |

### Local Configuration (`.github/copilot/settings.local.json`) / 本地配置

Personal repository overrides (add to `.gitignore`). Uses same schema as repository settings with higher precedence.

个人仓库覆盖（添加到 `.gitignore`）。使用与仓库设置相同的架构，但优先级更高。

## Hook Events Reference / Hook 事件参考

| Event / 事件 | Triggers When / 触发时机 | Output Processed / 处理输出 |
|-------|---------------|------------------|
| `sessionStart` | New or resumed session / 新建或恢复会话 | No / 否 |
| `sessionEnd` | Session terminates / 会话终止 | No / 否 |
| `userPromptSubmitted` | User submits prompt / 用户提交提示词 | No / 否 |
| `preToolUse` | Before tool execution / 工具执行前 | Yes—can allow/deny/modify / 是—可允许/拒绝/修改 |
| `postToolUse` | After tool completes / 工具完成后 | No / 否 |
| `agentStop` | Main agent finishes turn / 主 Agent 完成轮次 | Yes—can block/continue / 是—可阻止/继续 |
| `subagentStop` | Subagent completes / 子 Agent 完成 | Yes—can block/continue / 是—可阻止/继续 |
| `errorOccurred` | Error during execution / 执行期间出错 | No / 否 |

## Permission Approval Responses / 权限批准响应

When prompted for operation approval:

当提示操作批准时：

| Key / 键 | Effect / 效果 |
|-----|--------|
| `y` | Allow this specific request once / 允许本次特定请求 |
| `n` | Deny this specific request once / 拒绝本次特定请求 |
| `!` | Allow all similar requests this session / 允许本次会话中所有类似请求 |
| `#` | Deny all similar requests this session / 拒绝本次会话中所有类似请求 |
| `?` | Show detailed request information / 显示详细请求信息 |

Session approvals reset with `/clear` or new session.

会话批准随 `/clear` 或新会话重置。

## Feature Flags / 功能标志

| Flag / 标志 | Description / 说明 |
|------|-------------|
| `AUTOPILOT_MODE` | Autonomous operation / 自主操作 |
| `LSP_TOOLS` | Language Server Protocol tools / 语言服务器协议工具 |
| `PLAN_COMMAND` | Interactive planning mode / 交互式计划模式 |
| `AGENTIC_MEMORY` | Persistent cross-session memory / 持久跨会话记忆 |
| `CUSTOM_AGENTS` | Custom agent definitions / 自定义 Agent 定义 |

## OpenTelemetry Monitoring / OpenTelemetry 监控

Copilot CLI exports traces and metrics via OpenTelemetry. OTel is off by default and activates with environment variables:

Copilot CLI 通过 OpenTelemetry 导出追踪和指标。OTel 默认关闭，通过环境变量激活：

| Variable / 变量 | Default / 默认值 | Description / 说明 |
|----------|---------|-------------|
| `COPILOT_OTEL_ENABLED` | false | Explicitly enable OTel / 显式启用 OTel |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | — | OTLP endpoint URL / OTLP 端点 URL |
| `COPILOT_OTEL_EXPORTER_TYPE` | otlp-http | Exporter type / 导出器类型 |
| `OTEL_SERVICE_NAME` | github-copilot | Service name in resources / 资源中的服务名称 |
| `OTEL_INSTRUMENTATION_GENAI_CAPTURE_MESSAGE_CONTENT` | false | Capture full prompts/responses / 捕获完整提示词/响应 |
| `COPILOT_OTEL_FILE_EXPORTER_PATH` | — | Write signals to JSON-lines file / 将信号写入 JSON-lines 文件 |

> **Warning:** Content capture may include sensitive information such as code and file contents. Only enable in trusted environments.

> **警告：** 内容捕获可能包含代码和文件内容等敏感信息。仅在受信任的环境中启用。
