# 企业部署概览

> 了解 Claude Code 如何与各种第三方服务和基础设施集成，以满足企业部署需求。

组织可以直接通过 Anthropic 或通过云提供商部署 Claude Code。本页面帮助您选择正确的配置。

## 比较部署选项

对于大多数组织，Claude for Teams 或 Claude for Enterprise 提供最佳体验。团队成员可以通过单一订阅访问 Claude Code 和网页版 Claude，具有集中计费和无需基础设施设置的优势。

**Claude for Teams** 是自助服务，包括协作功能、管理工具和计费管理。最适合需要快速启动的小型团队。

**Claude for Enterprise** 增加了 SSO 和域名捕获、基于角色的权限、合规性 API 访问以及用于部署组织范围内 Claude Code 配置的托管策略设置。最适合具有安全和合规性要求的大型组织。

了解更多关于 [Team 计划](https://support.claude.com/en/articles/9266767-what-is-the-team-plan) 和 [Enterprise 计划](https://support.claude.com/en/articles/9797531-what-is-the-enterprise-plan)。

如果您的组织有特定的基础设施要求，请比较以下选项：

| 功能               | Claude for Teams/Enterprise      | Anthropic Console | Amazon Bedrock       | Google Vertex AI     | Microsoft Foundry        |
| ------------------ | -------------------------------- | ----------------- | -------------------- | -------------------- | ------------------------ |
| 最适合             | 大多数组织（推荐）               | 个人开发者        | AWS 原生部署         | GCP 原生部署         | Azure 原生部署           |
| 计费               | Teams: $150/座位；Enterprise: 联系销售 | 按使用量付费  | 通过 AWS 按使用量付费 | 通过 GCP 按使用量付费 | 通过 Azure 按使用量付费 |
| prompt caching     | 默认启用                         | 默认启用          | 默认启用             | 默认启用             | 默认启用                 |
| 身份验证           | Claude.ai SSO 或电子邮件         | API 密钥          | API 密钥或 AWS 凭证  | GCP 凭证             | API 密钥或 Microsoft Entra ID |
| 包括网页版 Claude  | 是                               | 否                | 否                   | 否                   | 否                       |

选择部署选项以查看设置说明：

* [Claude for Teams 或 Enterprise](/zh-CN/authentication#claude-for-teams-or-enterprise)
* [Anthropic Console](/zh-CN/authentication#claude-console-authentication)
* [Amazon Bedrock](/zh-CN/amazon-bedrock)
* [Google Vertex AI](/zh-CN/google-vertex-ai)
* [Microsoft Foundry](/zh-CN/microsoft-foundry)

## 配置代理和网关

大多数组织可以直接使用云提供商，无需额外配置。但是，如果您的组织有特定的网络或管理要求，您可能需要配置企业代理或 LLM 网关。这些是可以一起使用的不同配置：

* **企业代理**：通过 HTTP/HTTPS 代理路由流量。如果您的组织要求所有出站流量通过代理服务器以进行安全监控、合规性或网络策略执行，请使用此选项。使用 `HTTPS_PROXY` 或 `HTTP_PROXY` 环境变量进行配置。
* **LLM 网关**：位于 Claude Code 和云提供商之间的服务，用于处理身份验证和路由。如果您需要跨团队的集中使用情况跟踪、自定义速率限制或预算或集中身份验证管理，请使用此选项。使用 `ANTHROPIC_BASE_URL`、`ANTHROPIC_BEDROCK_BASE_URL` 或 `ANTHROPIC_VERTEX_BASE_URL` 环境变量进行配置。

### Amazon Bedrock

**企业代理配置：**

```bash
# 启用 Bedrock
export CLAUDE_CODE_USE_BEDROCK=1
export AWS_REGION=us-east-1

# 配置企业代理
export HTTPS_PROXY='https://proxy.example.com:8080'
```

**LLM 网关配置：**

```bash
# 启用 Bedrock
export CLAUDE_CODE_USE_BEDROCK=1

# 配置 LLM 网关
export ANTHROPIC_BEDROCK_BASE_URL='https://your-llm-gateway.com/bedrock'
export CLAUDE_CODE_SKIP_BEDROCK_AUTH=1  # 如果网关处理 AWS 身份验证
```

### Microsoft Foundry

**企业代理配置：**

```bash
# 启用 Microsoft Foundry
export CLAUDE_CODE_USE_FOUNDRY=1
export ANTHROPIC_FOUNDRY_RESOURCE=your-resource
export ANTHROPIC_FOUNDRY_API_KEY=your-api-key  # 或省略以使用 Entra ID 身份验证

# 配置企业代理
export HTTPS_PROXY='https://proxy.example.com:8080'
```

**LLM 网关配置：**

```bash
# 启用 Microsoft Foundry
export CLAUDE_CODE_USE_FOUNDRY=1

# 配置 LLM 网关
export ANTHROPIC_FOUNDRY_BASE_URL='https://your-llm-gateway.com'
export CLAUDE_CODE_SKIP_FOUNDRY_AUTH=1  # 如果网关处理 Azure 身份验证
```

### Google Vertex AI

**企业代理配置：**

```bash
# 启用 Vertex
export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=us-east5
export ANTHROPIC_VERTEX_PROJECT_ID=your-project-id

# 配置企业代理
export HTTPS_PROXY='https://proxy.example.com:8080'
```

**LLM 网关配置：**

```bash
# 启用 Vertex
export CLAUDE_CODE_USE_VERTEX=1

# 配置 LLM 网关
export ANTHROPIC_VERTEX_BASE_URL='https://your-llm-gateway.com/vertex'
export CLAUDE_CODE_SKIP_VERTEX_AUTH=1  # 如果网关处理 GCP 身份验证
```

> 在 Claude Code 中使用 `/status` 来验证您的代理和网关配置是否正确应用。

## 组织的最佳实践

### 投资文档和内存

我们强烈建议投资文档，以便 Claude Code 理解您的代码库。组织可以在多个级别部署 CLAUDE.md 文件：

* **组织范围**：部署到系统目录，如 `/Library/Application Support/ClaudeCode/CLAUDE.md`（macOS），用于公司范围的标准
* **存储库级别**：在存储库根目录中创建 `CLAUDE.md` 文件，包含项目架构、构建命令和贡献指南。将这些检入源代码控制，以便所有用户受益

### 简化部署

如果您有自定义开发环境，我们发现创建一种"一键"安装 Claude Code 的方式是在组织中增加采用率的关键。

### 从引导式使用开始

鼓励新用户尝试使用 Claude Code 进行代码库问答，或在较小的错误修复或功能请求上使用。要求 Claude Code 制定计划。检查 Claude 的建议，如果偏离轨道，请提供反馈。随着时间的推移，当用户更好地理解这种新范式时，他们将更有效地让 Claude Code 更自主地运行。

### 为云提供商固定模型版本

如果您通过 [Bedrock](/zh-CN/amazon-bedrock)、[Vertex AI](/zh-CN/google-vertex-ai) 或 [Foundry](/zh-CN/microsoft-foundry) 部署，请使用 `ANTHROPIC_DEFAULT_OPUS_MODEL`、`ANTHROPIC_DEFAULT_SONNET_MODEL` 和 `ANTHROPIC_DEFAULT_HAIKU_MODEL` 固定特定模型版本。如果不固定，Claude Code 别名会解析为最新版本，当 Anthropic 发布您的账户中尚未启用的新模型时，可能会破坏用户。

### 配置安全策略

安全团队可以配置托管权限，定义 Claude Code 允许和不允许做什么，这不能被本地配置覆盖。

### 利用 MCP 进行集成

MCP 是为 Claude Code 提供更多信息的好方法，例如连接到票证管理系统或错误日志。我们建议一个中央团队配置 MCP servers 并将 `.mcp.json` 配置检入代码库，以便所有用户受益。

## 后续步骤

选择部署选项并为您的团队配置访问权限后：

1. **向您的团队推出**：分享安装说明，让团队成员[安装 Claude Code](/zh-CN/setup) 并使用其凭证进行身份验证。
2. **设置共享配置**：在您的存储库中创建 [CLAUDE.md 文件](/zh-CN/memory)，以帮助 Claude Code 理解您的代码库和编码标准。
3. **配置权限**：查看[安全设置](/zh-CN/security)以定义 Claude Code 在您的环境中可以和不能做什么。
