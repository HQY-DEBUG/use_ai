# Adding MCP Servers for GitHub Copilot CLI / 为 GitHub Copilot CLI 添加 MCP 服务器

Extend Copilot's capabilities by connecting Model Context Protocol (MCP) servers to provide additional tools and context.

通过连接模型上下文协议（MCP）服务器来扩展 Copilot 的功能，为其提供额外的工具和上下文。

The Model Context Protocol (MCP) is an open standard that defines how applications share context with large language models (LLMs). You can connect MCP servers to GitHub Copilot CLI to give Copilot access to external tools, data sources, and services.

模型上下文协议（MCP）是一个开放标准，定义了应用程序如何与大语言模型（LLM）共享上下文。你可以将 MCP 服务器连接到 GitHub Copilot CLI，使 Copilot 能够访问外部工具、数据源和服务。

## Adding an MCP Server / 添加 MCP 服务器

> **Note:** The GitHub MCP server is built into Copilot CLI and is already available without any additional configuration. The steps below are for adding other MCP servers.

> **注意：** GitHub MCP 服务器已内置于 Copilot CLI 中，无需任何额外配置即可使用。以下步骤适用于添加其他 MCP 服务器。

You can add MCP servers using the interactive `/mcp add` command within the CLI, or by editing the configuration file directly.

你可以在 CLI 中使用交互式 `/mcp add` 命令添加 MCP 服务器，也可以直接编辑配置文件。

### Using the `/mcp add` command / 使用 `/mcp add` 命令

1. In interactive mode, enter `/mcp add`. A configuration form is displayed. Use **Tab** to navigate between fields.

1. 在交互模式下，输入 `/mcp add`。将显示配置表单。使用 **Tab** 在字段之间导航。

2. Next to **Server Name**, enter a unique name for the MCP server.

2. 在 **Server Name** 旁边，输入 MCP 服务器的唯一名称。

3. Next to **Server Type**, select a type by pressing the corresponding number:

3. 在 **Server Type** 旁边，按对应数字选择类型：

   * **Local** or **STDIO**: starts a local process and communicates over standard input/output (`stdin`/`stdout`). Both options work the same way. **STDIO** is the standard MCP protocol type name, compatible with VS Code, the Copilot coding agent, and other MCP clients.
   * **HTTP** or **SSE**: connects to a remote MCP server. **HTTP** uses the Streamable HTTP transport. **SSE** uses the legacy HTTP with Server-Sent Events transport.

   * **Local** 或 **STDIO**：启动本地进程并通过标准输入/输出（`stdin`/`stdout`）通信。两个选项工作方式相同。**STDIO** 是标准 MCP 协议类型名称，与 VS Code、Copilot 编码 Agent 和其他 MCP 客户端兼容。
   * **HTTP** 或 **SSE**：连接到远程 MCP 服务器。**HTTP** 使用可流式传输的 HTTP 传输协议。**SSE** 使用基于服务器发送事件的旧版 HTTP 传输协议。

4. Fill in the remaining fields based on the server type:

4. 根据服务器类型填写其余字段：

   * If you chose **Local** or **STDIO**:
     * **Command**: the command to start the server, including any arguments. For example, `npx @playwright/mcp@latest`.
     * **Environment Variables**: optionally specify environment variables as JSON key-value pairs. For example, `{"API_KEY": "YOUR-API-KEY"}`.

   * 如果选择了 **Local** 或 **STDIO**：
     * **Command**：启动服务器的命令，包括任何参数。例如 `npx @playwright/mcp@latest`。
     * **Environment Variables**：可选，以 JSON 键值对形式指定环境变量。例如 `{"API_KEY": "YOUR-API-KEY"}`。

   * If you chose **HTTP** or **SSE**:
     * **URL**: paste the remote server URL. For example, `https://mcp.context7.com/mcp`.
     * **HTTP Headers**: optionally specify HTTP headers as JSON.

   * 如果选择了 **HTTP** 或 **SSE**：
     * **URL**：粘贴远程服务器 URL。例如 `https://mcp.context7.com/mcp`。
     * **HTTP Headers**：可选，以 JSON 形式指定 HTTP 请求头。

5. Next to **Tools**, specify which tools from the server should be available. Enter `*` to include all tools, or provide a comma-separated list of tool names.

5. 在 **Tools** 旁边，指定服务器中哪些工具应可用。输入 `*` 包含所有工具，或提供以逗号分隔的工具名称列表。

6. Press **Ctrl+S** to save the configuration. The MCP server is added and available immediately without restarting the CLI.

6. 按 **Ctrl+S** 保存配置。MCP 服务器立即添加并可用，无需重启 CLI。

### Editing the Configuration File / 编辑配置文件

You can also add MCP servers by editing the configuration file at `~/.copilot/mcp-config.json`.

你也可以通过编辑 `~/.copilot/mcp-config.json` 配置文件来添加 MCP 服务器。

Example configuration with a local server and a remote HTTP server:

包含本地服务器和远程 HTTP 服务器的配置示例：

```json
{
  "mcpServers": {
    "playwright": {
      "type": "local",
      "command": "npx",
      "args": ["@playwright/mcp@latest"],
      "env": {},
      "tools": ["*"]
    },
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "YOUR-API-KEY"
      },
      "tools": ["*"]
    }
  }
}
```

## Managing MCP Servers / 管理 MCP 服务器

Use the following `/mcp` commands in Copilot CLI:

在 Copilot CLI 中使用以下 `/mcp` 命令：

* `/mcp show` — List all configured MCP servers and their current status. / 列出所有已配置的 MCP 服务器及其当前状态。
* `/mcp show SERVER-NAME` — Display the status of a specific server and its tools. / 显示特定服务器及其工具的状态。
* `/mcp edit SERVER-NAME` — Edit a server's configuration. / 编辑服务器配置。
* `/mcp delete SERVER-NAME` — Delete a server. / 删除服务器。
* `/mcp disable SERVER-NAME` — Disable a server for the current session. / 在当前会话中禁用服务器。
* `/mcp enable SERVER-NAME` — Enable a previously disabled server. / 启用之前禁用的服务器。

## Built-in MCP Servers / 内置 MCP 服务器

| Server / 服务器 | Description / 说明 |
|--------|-------------|
| `github-mcp-server` | GitHub API: issues, PRs, commits, code search, Actions / GitHub API：问题、PR、提交、代码搜索、Actions |
| `playwright` | Browser automation / 浏览器自动化 |
| `fetch` | HTTP requests / HTTP 请求 |
| `time` | Time utilities / 时间工具 |

Disable with `--disable-builtin-mcps` or `--disable-mcp-server SERVER-NAME`.

使用 `--disable-builtin-mcps` 或 `--disable-mcp-server SERVER-NAME` 禁用。

## MCP Server Trust Levels / MCP 服务器信任级别

| Source / 来源 | Trust Level / 信任级别 |
|--------|------------|
| Built-in / 内置 | High / 高 |
| Repository (`.github/mcp.json`) / 仓库 | Medium / 中 |
| Workspace (`.mcp.json`, `.vscode/mcp.json`) / 工作区 | Medium / 中 |
| User config (`~/.copilot/mcp-config.json`) / 用户配置 | User-defined / 用户定义 |
| Remote servers / 远程服务器 | Low / 低 |

All MCP tool invocations require explicit permission, including read-only operations.

所有 MCP 工具调用都需要明确授权，包括只读操作。

## Using MCP Servers / 使用 MCP 服务器

Once you have added an MCP server, Copilot can automatically use the tools it provides when relevant to your prompt. You can also directly reference an MCP server and specific tools in a prompt to ensure they are used.

添加 MCP 服务器后，当与你的提示词相关时，Copilot 可以自动使用它提供的工具。你也可以在提示词中直接引用 MCP 服务器和特定工具，以确保它们被使用。
