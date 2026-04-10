# Claude Code 设置

> 文件：`settings.md`  版本：v1.0  日期：2026-03-24

> 使用全局和项目级设置以及环境变量配置 Claude Code。

Claude Code 提供多种设置来配置其行为以满足您的需求。您可以在使用交互式 REPL 时运行 `/config` 命令来配置 Claude Code，这会打开一个选项卡式设置界面，您可以在其中查看状态信息并修改配置选项。

---

## 配置作用域

Claude Code 使用**作用域系统**来确定配置应用的位置以及与谁共享。

### 可用作用域

| 作用域      | 位置                                                   | 影响范围              | 与团队共享？         |
| ----------- | ------------------------------------------------------ | --------------------- | -------------------- |
| **Managed** | 服务器管理的设置、plist / 注册表或系统级 managed-settings.json | 机器上的所有用户      | 是（由 IT 部署）     |
| **User**    | `~/.claude/` 目录                                      | 您，跨所有项目        | 否                   |
| **Project** | 存储库中的 `.claude/`                                  | 此存储库上的所有协作者 | 是（提交到 git）     |
| **Local**   | `.claude/settings.local.json`                          | 您，仅在此存储库中    | 否（gitignored）     |

### 何时使用每个作用域

**Managed 作用域**用于：
- 必须在整个组织范围内强制执行的安全策略
- 无法被覆盖的合规要求
- 由 IT/DevOps 部署的标准化配置

**User 作用域**最适合：
- 您想在任何地方使用的个人偏好设置（主题、编辑器设置）
- 您在所有项目中使用的工具和插件
- API 密钥和身份验证（安全存储）

**Project 作用域**最适合：
- 团队共享的设置（权限、hooks、MCP servers）
- 整个团队应该拥有的插件
- 跨协作者标准化工具

**Local 作用域**最适合：
- 特定项目的个人覆盖
- 在与团队共享之前测试配置
- 对其他人不适用的特定于机器的设置

### 作用域如何相互作用

当在多个作用域中配置相同的设置时，更具体的作用域优先：

1. **Managed**（最高）- 无法被任何内容覆盖
2. **命令行参数** - 临时会话覆盖
3. **Local** - 覆盖项目和用户设置
4. **Project** - 覆盖用户设置
5. **User**（最低）- 当没有其他内容指定设置时应用

### 哪些功能使用作用域

| 功能            | User 位置                    | Project 位置                        | Local 位置                       |
| --------------- | ---------------------------- | ----------------------------------- | -------------------------------- |
| **Settings**    | `~/.claude/settings.json`    | `.claude/settings.json`             | `.claude/settings.local.json`    |
| **Subagents**   | `~/.claude/agents/`          | `.claude/agents/`                   | 无                               |
| **MCP servers** | `~/.claude.json`             | `.mcp.json`                         | `~/.claude.json`（每个项目）     |
| **Plugins**     | `~/.claude/settings.json`    | `.claude/settings.json`             | `.claude/settings.local.json`    |
| **CLAUDE.md**   | `~/.claude/CLAUDE.md`        | `CLAUDE.md` 或 `.claude/CLAUDE.md` | 无                               |

---

## 设置文件

`settings.json` 文件是通过分层设置配置 Claude Code 的官方机制：

- **用户设置**在 `~/.claude/settings.json` 中定义，适用于所有项目。
- **项目设置**保存在您的项目目录中：
  - `.claude/settings.json` 用于检入源代码管理并与您的团队共享的设置
  - `.claude/settings.local.json` 用于未检入的设置，适用于个人偏好和实验
- **Managed 设置**：对于需要集中控制的组织，Claude Code 支持多种 managed 设置的交付机制：
  - **服务器管理的设置**：通过 Claude.ai 管理员控制台从 Anthropic 的服务器交付
  - **MDM/OS 级别策略**：
    - macOS：`com.anthropic.claudecode` managed preferences 域
    - Windows：`HKLM\SOFTWARE\Policies\ClaudeCode` 注册表项
    - Windows（用户级）：`HKCU\SOFTWARE\Policies\ClaudeCode`
  - **基于文件**：`managed-settings.json` 和 `managed-mcp.json` 部署到系统目录：
    - macOS：`/Library/Application Support/ClaudeCode/`
    - Linux 和 WSL：`/etc/claude-code/`
    - Windows：`C:\Program Files\ClaudeCode\`

示例 `settings.json`：

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test *)",
      "Read(~/.zshrc)"
    ],
    "deny": [
      "Bash(curl *)",
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)"
    ]
  },
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp"
  },
  "companyAnnouncements": [
    "Welcome to Acme Corp! Review our code guidelines at docs.acme.com"
  ]
}
```

`$schema` 行指向 Claude Code 设置的官方 JSON 架构，可在 VS Code、Cursor 和任何其他支持 JSON 架构验证的编辑器中启用自动完成和内联验证。

---

## 可用设置

| 键                            | 描述                                                                             | 示例                                                  |
| ----------------------------- | -------------------------------------------------------------------------------- | ----------------------------------------------------- |
| `apiKeyHelper`                | 自定义脚本，在 `/bin/sh` 中执行，以生成身份验证值                               | `/bin/generate_temp_api_key.sh`                       |
| `autoMemoryDirectory`         | 自动内存存储的自定义目录                                                         | `"~/my-memory-dir"`                                   |
| `cleanupPeriodDays`           | 非活跃时间超过此期间的会话在启动时被删除（默认：30 天）                          | `20`                                                  |
| `companyAnnouncements`        | 在启动时显示给用户的公告                                                         | `["Welcome to Acme Corp!"]`                           |
| `env`                         | 将应用于每个会话的环境变量                                                       | `{"FOO": "bar"}`                                      |
| `attribution`                 | 自定义 git 提交和拉取请求的归属                                                  | `{"commit": "🤖 Generated with Claude Code", "pr": ""}` |
| `includeCoAuthoredBy`         | **已弃用**：改用 `attribution`。是否在 git 提交中包含 co-authored-by 署名       | `false`                                               |
| `includeGitInstructions`      | 在 Claude 的系统提示中包含内置提交和 PR 工作流说明（默认：`true`）               | `false`                                               |
| `permissions`                 | 权限规则（见下表）                                                               |                                                       |
| `hooks`                       | 配置自定义命令以在生命周期事件处运行                                             |                                                       |
| `disableAllHooks`             | 禁用所有 hooks 和任何自定义状态行                                               | `true`                                                |
| `model`                       | 覆盖用于 Claude Code 的默认模型                                                  | `"claude-sonnet-4-6"`                                 |
| `availableModels`             | 限制用户可以选择的模型                                                           | `["sonnet", "haiku"]`                                 |
| `effortLevel`                 | 跨会话持久化努力级别。接受 `"low"`、`"medium"` 或 `"high"`                      | `"medium"`                                            |
| `language`                    | 配置 Claude 的首选响应语言                                                       | `"japanese"`                                          |
| `autoUpdatesChannel`          | 遵循更新的发布渠道（`"stable"` 或 `"latest"`）                                   | `"stable"`                                            |
| `forceLoginMethod`            | 使用 `claudeai` 限制登录到 Claude.ai 账户，`console` 限制登录到 Claude Console  | `claudeai`                                            |
| `enableAllProjectMcpServers`  | 自动批准项目 `.mcp.json` 文件中定义的所有 MCP servers                           | `true`                                                |
| `showTurnDuration`            | 在响应后显示轮次持续时间消息                                                     | `true`                                                |
| `spinnerTipsEnabled`          | 在 Claude 工作时在微调器中显示提示（默认：`true`）                               | `false`                                               |
| `prefersReducedMotion`        | 减少或禁用 UI 动画以实现可访问性                                                 | `true`                                                |
| `alwaysThinkingEnabled`       | 为所有会话默认启用扩展思考                                                       | `true`                                                |
| `plansDirectory`              | 自定义计划文件的存储位置                                                         | `"./plans"`                                           |

---

## 权限设置

| 键                       | 描述                                         | 示例                                          |
| ------------------------ | -------------------------------------------- | --------------------------------------------- |
| `allow`                  | 允许工具使用的权限规则数组                   | `[ "Bash(git diff *)" ]`                      |
| `ask`                    | 在工具使用时要求确认的权限规则数组           | `[ "Bash(git push *)" ]`                      |
| `deny`                   | 拒绝工具使用的权限规则数组                   | `[ "WebFetch", "Bash(curl *)", "Read(./.env)" ]` |
| `additionalDirectories`  | Claude 有权访问的额外工作目录                | `[ "../docs/" ]`                              |
| `defaultMode`            | 打开 Claude Code 时的默认权限模式            | `"acceptEdits"`                               |

### 权限规则语法

权限规则遵循 `Tool` 或 `Tool(specifier)` 的格式。规则按顺序评估：首先是拒绝规则，然后是询问，最后是允许。第一个匹配的规则获胜。

| 规则                              | 效果                      |
| --------------------------------- | ------------------------- |
| `Bash`                            | 匹配所有 Bash 命令        |
| `Bash(npm run *)`                 | 匹配以 `npm run` 开头的命令 |
| `Read(./.env)`                    | 匹配读取 `.env` 文件      |
| `WebFetch(domain:example.com)`    | 匹配对 example.com 的获取请求 |

---

## Sandbox 设置

配置高级 sandboxing 行为。Sandboxing 将 bash 命令与您的文件系统和网络隔离。

| 键                            | 描述                                                   | 示例                              |
| ----------------------------- | ------------------------------------------------------ | --------------------------------- |
| `enabled`                     | 启用 bash sandboxing（macOS、Linux 和 WSL2）。默认：false | `true`                          |
| `autoAllowBashIfSandboxed`    | 当 sandboxed 时自动批准 bash 命令。默认：true          | `true`                            |
| `excludedCommands`            | 应在 sandbox 外运行的命令                              | `["git", "docker"]`               |
| `filesystem.allowWrite`       | sandboxed 命令可以写入的额外路径                       | `["//tmp/build", "~/.kube"]`      |
| `filesystem.denyWrite`        | sandboxed 命令无法写入的路径                           | `["//etc", "//usr/local/bin"]`    |
| `filesystem.denyRead`         | sandboxed 命令无法读取的路径                           | `["~/.aws/credentials"]`          |
| `network.allowedDomains`      | 允许出站网络流量的域数组。支持通配符                   | `["github.com", "*.npmjs.org"]`   |
| `network.allowLocalBinding`   | 允许绑定到 localhost 端口（仅 macOS）。默认：false     | `true`                            |
| `network.allowUnixSockets`    | sandbox 中可访问的 Unix socket 路径                    | `["~/.ssh/agent-socket"]`         |

配置示例：

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker"],
    "filesystem": {
      "allowWrite": ["//tmp/build", "~/.kube"],
      "denyRead": ["~/.aws/credentials"]
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org", "registry.yarnpkg.com"],
      "allowUnixSockets": ["/var/run/docker.sock"],
      "allowLocalBinding": true
    }
  }
}
```

### Sandbox 路径前缀

| 前缀         | 含义                      | 示例                                  |
| ------------ | ------------------------- | ------------------------------------- |
| `//`         | 从文件系统根目录的绝对路径 | `//tmp/build` 变为 `/tmp/build`       |
| `~/`         | 相对于主目录              | `~/.kube` 变为 `$HOME/.kube`          |
| `/`          | 相对于设置文件的目录      | `/build` 变为 `$SETTINGS_DIR/build`   |
| `./` 或无前缀 | 相对路径                  | `./output`                            |

---

## 归属设置

Claude Code 为 git 提交和拉取请求添加归属。这些分别配置：

- 提交默认使用 git trailers（如 `Co-Authored-By`），可以自定义或禁用
- 拉取请求描述是纯文本

| 键       | 描述                                              |
| -------- | ------------------------------------------------- |
| `commit` | git 提交的归属，包括任何 trailers。空字符串隐藏提交归属 |
| `pr`     | 拉取请求描述的归属。空字符串隐藏拉取请求归属      |

默认提交归属：

```
🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```

示例 - 自定义归属：

```json
{
  "attribution": {
    "commit": "Generated with AI\n\nCo-Authored-By: AI <ai@example.com>",
    "pr": ""
  }
}
```

---

## 设置优先级

设置按优先级顺序应用。从最高到最低：

1. **Managed 设置**（服务器管理、MDM/OS 级别策略或 managed 设置文件）
   - 由 IT 部署的策略，无法被任何其他级别覆盖
2. **命令行参数** - 特定会话的临时覆盖
3. **本地项目设置**（`.claude/settings.local.json`）
4. **共享项目设置**（`.claude/settings.json`）
5. **用户设置**（`~/.claude/settings.json`）

> 数组设置跨作用域合并。当相同的数组值设置出现在多个作用域中时，数组被连接和去重，而不是替换。

### 验证活跃设置

在 Claude Code 中运行 `/status` 以查看哪些设置源处于活跃状态以及它们来自何处。

---

## 排除敏感文件

要防止 Claude Code 访问包含敏感信息的文件，请在您的 `.claude/settings.json` 文件中使用 `permissions.deny` 设置：

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./config/credentials.json)",
      "Read(./build)"
    ]
  }
}
```

---

## Subagent 配置

Claude Code 支持可在用户和项目级别配置的自定义 AI subagents。这些 subagents 存储为带有 YAML frontmatter 的 Markdown 文件：

- **用户 subagents**：`~/.claude/agents/` - 在所有项目中可用
- **项目 subagents**：`.claude/agents/` - 特定于您的项目，可与您的团队共享

---

## 插件配置

Claude Code 支持一个插件系统，让您可以使用 skills、agents、hooks 和 MCP servers 扩展功能。

### 插件设置

`settings.json` 中的插件相关设置：

```json
{
  "enabledPlugins": {
    "formatter@acme-tools": true,
    "deployer@acme-tools": true,
    "analyzer@security-plugins": false
  },
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": {
        "source": "github",
        "repo": "acme-corp/claude-plugins"
      }
    }
  }
}
```

#### `enabledPlugins`

控制启用哪些插件。格式：`"plugin-name@marketplace-name": true/false`

作用域：
- **用户设置**（`~/.claude/settings.json`）：个人插件偏好
- **项目设置**（`.claude/settings.json`）：与团队共享的项目特定插件
- **本地设置**（`.claude/settings.local.json`）：每台机器的覆盖（未提交）

#### `extraKnownMarketplaces`

定义应为存储库提供的额外市场。通常在存储库级别设置中使用，以确保团队成员有权访问所需的插件源。

```json
{
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": {
        "source": "github",
        "repo": "acme-corp/claude-plugins"
      }
    },
    "security-plugins": {
      "source": {
        "source": "git",
        "url": "https://git.example.com/security/plugins.git"
      }
    }
  }
}
```

市场源类型：
- `github`：GitHub 存储库（使用 `repo`）
- `git`：任何 git URL（使用 `url`）
- `directory`：本地文件系统路径（使用 `path`，仅用于开发）
- `hostPattern`：正则表达式模式以匹配市场主机

### 管理插件

使用 `/plugin` 命令以交互方式管理插件：

- 浏览市场中的可用插件
- 安装/卸载插件
- 启用/禁用插件
- 查看插件详情（提供的命令、agents、hooks）
- 添加/删除市场

---

## 环境变量

环境变量让您可以控制 Claude Code 行为而无需编辑设置文件。任何变量也可以在 `settings.json` 中的 `env` 键下配置，以将其应用于每个会话或将其推出到您的团队。

---

## 另请参阅

- **权限**：权限系统、规则语法、工具特定模式和 managed 策略
- **身份验证**：设置用户对 Claude Code 的访问
- **故障排除**：常见配置问题的解决方案
