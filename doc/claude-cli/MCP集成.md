# 通过 MCP 将 Claude Code 连接到工具

> 了解如何使用 Model Context Protocol 将 Claude Code 连接到您的工具。

Claude Code 可以通过 [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction)（一个用于 AI 工具集成的开源标准）连接到数百个外部工具和数据源。

## 使用 MCP 可以做什么

连接 MCP 服务器后，您可以要求 Claude Code：

* **从问题跟踪器实现功能**："添加 JIRA 问题 ENG-4521 中描述的功能，并在 GitHub 上创建 PR。"
* **分析监控数据**："检查 Sentry 和 Statsig 以检查功能的使用情况。"
* **查询数据库**："查找使用功能的 10 个随机用户的电子邮件。"
* **集成设计**："根据 Slack 中发布的新 Figma 设计更新我们的标准电子邮件模板"
* **自动化工作流**："创建 Gmail 草稿，邀请用户参加关于新功能的反馈会议。"

## 安装 MCP 服务器

### 选项 1：添加远程 HTTP 服务器

```bash
# 基本语法
claude mcp add --transport http <name> <url>

# 真实示例：连接到 Notion
claude mcp add --transport http notion https://mcp.notion.com/mcp

# 带有 Bearer 令牌的示例
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"
```

### 选项 2：添加远程 SSE 服务器

> **警告：** SSE (Server-Sent Events) 传输已弃用。请在可用的地方使用 HTTP 服务器。

```bash
claude mcp add --transport sse <name> <url>
```

### 选项 3：添加本地 stdio 服务器

```bash
# 基本语法
claude mcp add [options] <name> -- <command> [args...]

# 示例：添加 Airtable 服务器
claude mcp add --transport stdio --env AIRTABLE_API_KEY=YOUR_KEY airtable \
  -- npx -y airtable-mcp-server
```

### 管理您的服务器

```bash
claude mcp list              # 列出所有配置的服务器
claude mcp get github        # 获取特定服务器的详细信息
claude mcp remove github     # 删除服务器
/mcp                         # 在 Claude Code 中检查服务器状态
```

## MCP 安装范围

| 范围 | 命令 | 说明 |
|------|------|------|
| 本地（默认） | `claude mcp add --scope local` | 仅当前项目，个人私密 |
| 项目 | `claude mcp add --scope project` | 通过 `.mcp.json` 与团队共享 |
| 用户 | `claude mcp add --scope user` | 所有项目中可用，个人私密 |

## 使用远程 MCP 服务器进行身份验证

许多基于云的 MCP 服务器需要身份验证。Claude Code 支持 OAuth 2.0。

1. 添加服务器：`claude mcp add --transport http sentry https://mcp.sentry.dev/mcp`
2. 在 Claude Code 中使用 `/mcp` 命令
3. 按照浏览器中的步骤登录

## 实际示例

### 使用 Sentry 监控错误

```bash
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
```

```text
过去 24 小时内最常见的错误是什么？
显示我错误 ID abc123 的堆栈跟踪
```

### 连接到 GitHub 进行代码审查

```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
```

```text
审查 PR #456 并建议改进
为我们刚发现的错误创建新问题
```

### 查询您的 PostgreSQL 数据库

```bash
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://readonly:pass@prod.db.com:5432/analytics"
```

```text
本月我们的总收入是多少？
显示订单表的架构
```

## 将 Claude Code 用作 MCP 服务器

```bash
claude mcp serve
```

在 Claude Desktop 配置中使用：

```json
{
  "mcpServers": {
    "claude-code": {
      "type": "stdio",
      "command": "claude",
      "args": ["mcp", "serve"],
      "env": {}
    }
  }
}
```

## 使用 MCP 资源

键入 `@` 后跟服务器名称和资源路径来引用 MCP 资源：

```text
Can you analyze @github:issue://123 and suggest a fix?
Compare @postgres:schema://users with @docs:file://database/user-model
```

## 环境变量

| 变量 | 描述 |
|------|------|
| `MCP_TIMEOUT` | MCP 服务器启动超时（毫秒） |
| `MAX_MCP_OUTPUT_TOKENS` | 最大 MCP 输出令牌数（默认 25,000） |
| `ENABLE_TOOL_SEARCH` | 控制工具搜索行为（`true`/`false`/`auto`/`auto:<N>`） |
| `ENABLE_CLAUDEAI_MCP_SERVERS` | 是否使用 Claude.ai 的 MCP 服务器 |
