# Adding MCP Servers for GitHub Copilot CLI

Extend Copilot's capabilities by connecting Model Context Protocol (MCP) servers to provide additional tools and context.

The Model Context Protocol (MCP) is an open standard that defines how applications share context with large language models (LLMs). You can connect MCP servers to GitHub Copilot CLI to give Copilot access to external tools, data sources, and services.

## Adding an MCP Server

> **Note:** The GitHub MCP server is built into Copilot CLI and is already available without any additional configuration. The steps below are for adding other MCP servers.

You can add MCP servers using the interactive `/mcp add` command within the CLI, or by editing the configuration file directly.

### Using the `/mcp add` command

1. In interactive mode, enter `/mcp add`. A configuration form is displayed. Use **Tab** to navigate between fields.

2. Next to **Server Name**, enter a unique name for the MCP server.

3. Next to **Server Type**, select a type by pressing the corresponding number:

   * **Local** or **STDIO**: starts a local process and communicates over standard input/output (`stdin`/`stdout`). Both options work the same way. **STDIO** is the standard MCP protocol type name, compatible with VS Code, the Copilot coding agent, and other MCP clients.
   * **HTTP** or **SSE**: connects to a remote MCP server. **HTTP** uses the Streamable HTTP transport. **SSE** uses the legacy HTTP with Server-Sent Events transport.

4. Fill in the remaining fields based on the server type:

   * If you chose **Local** or **STDIO**:
     * **Command**: the command to start the server, including any arguments. For example, `npx @playwright/mcp@latest`.
     * **Environment Variables**: optionally specify environment variables as JSON key-value pairs. For example, `{"API_KEY": "YOUR-API-KEY"}`.

   * If you chose **HTTP** or **SSE**:
     * **URL**: paste the remote server URL. For example, `https://mcp.context7.com/mcp`.
     * **HTTP Headers**: optionally specify HTTP headers as JSON.

5. Next to **Tools**, specify which tools from the server should be available. Enter `*` to include all tools, or provide a comma-separated list of tool names.

6. Press **Ctrl+S** to save the configuration. The MCP server is added and available immediately without restarting the CLI.

### Editing the Configuration File

You can also add MCP servers by editing the configuration file at `~/.copilot/mcp-config.json`.

Example configuration with a local server and a remote HTTP server:

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

## Managing MCP Servers

Use the following `/mcp` commands in Copilot CLI:

* `/mcp show` — List all configured MCP servers and their current status.
* `/mcp show SERVER-NAME` — Display the status of a specific server and its tools.
* `/mcp edit SERVER-NAME` — Edit a server's configuration.
* `/mcp delete SERVER-NAME` — Delete a server.
* `/mcp disable SERVER-NAME` — Disable a server for the current session.
* `/mcp enable SERVER-NAME` — Enable a previously disabled server.

## Built-in MCP Servers

| Server | Description |
|--------|-------------|
| `github-mcp-server` | GitHub API: issues, PRs, commits, code search, Actions |
| `playwright` | Browser automation |
| `fetch` | HTTP requests |
| `time` | Time utilities |

Disable with `--disable-builtin-mcps` or `--disable-mcp-server SERVER-NAME`.

## MCP Server Trust Levels

| Source | Trust Level |
|--------|------------|
| Built-in | High |
| Repository (`.github/mcp.json`) | Medium |
| Workspace (`.mcp.json`, `.vscode/mcp.json`) | Medium |
| User config (`~/.copilot/mcp-config.json`) | User-defined |
| Remote servers | Low |

All MCP tool invocations require explicit permission, including read-only operations.

## Using MCP Servers

Once you have added an MCP server, Copilot can automatically use the tools it provides when relevant to your prompt. You can also directly reference an MCP server and specific tools in a prompt to ensure they are used.
