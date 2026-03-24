# 快速开始

> 文件：`quickstart.md`  版本：v1.0  日期：2026-03-24

> 欢迎使用 Claude Code！

本快速开始指南将在几分钟内让您使用 AI 驱动的编码辅助。完成本指南后，您将了解如何使用 Claude Code 完成常见的开发任务。

---

## 开始前

确保您拥有：

- 打开的终端或命令提示符
- 一个可以使用的代码项目
- 一个 [Claude 订阅](https://claude.com/pricing)（Pro、Max、Teams 或 Enterprise）、[Claude Console](https://console.anthropic.com/) 账户，或通过支持的云提供商的访问权限

本指南涵盖终端 CLI。Claude Code 也可在网页、桌面应用、VS Code 和 JetBrains IDE、Slack 中使用，以及通过 GitHub Actions 和 GitLab 进行 CI/CD。

---

## 步骤 1：安装 Claude Code

**macOS / Linux / WSL：**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows PowerShell：**

```powershell
irm https://claude.ai/install.ps1 | iex
```

**Windows CMD：**

```batch
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

Windows 需要先安装 [Git for Windows](https://git-scm.com/downloads/win)。

> 原生安装会在后台自动更新，保持最新版本。

**Homebrew：**

```bash
brew install --cask claude-code
```

**WinGet：**

```powershell
winget install Anthropic.ClaudeCode
```

---

## 步骤 2：登录您的账户

Claude Code 需要账户才能使用。当您使用 `claude` 命令启动交互式会话时，您需要登录：

```bash
claude
# 首次使用时系统会提示您登录
```

```bash
/login
# 按照提示使用您的账户登录
```

您可以使用以下任何账户类型登录：

- Claude Pro、Max、Teams 或 Enterprise（推荐）
- Claude Console（具有预付费额度的 API 访问）。首次登录时，Console 中会自动为集中成本跟踪创建一个"Claude Code"工作区。
- Amazon Bedrock、Google Vertex AI 或 Microsoft Foundry（企业云提供商）

登录后，您的凭证将被存储，您无需再次登录。要稍后切换账户，请使用 `/login` 命令。

---

## 步骤 3：启动您的第一个会话

在任何项目目录中打开您的终端并启动 Claude Code：

```bash
cd /path/to/your/project
claude
```

您将看到 Claude Code 欢迎屏幕，其中包含您的会话信息、最近的对话和最新更新。输入 `/help` 查看可用命令，或输入 `/resume` 继续之前的对话。

> 登录后，您的凭证将存储在您的系统上。

---

## 步骤 4：提出您的第一个问题

让我们从理解您的代码库开始。尝试以下命令之一：

```
这个项目做什么？
```

Claude 将分析您的文件并提供摘要。您也可以提出更具体的问题：

```
这个项目使用什么技术？
```

```
主入口点在哪里？
```

```
解释文件夹结构
```

您也可以询问 Claude 关于其自身功能的问题：

```
Claude Code 能做什么？
```

```
我如何在 Claude Code 中创建自定义 skills？
```

```
Claude Code 可以与 Docker 一起工作吗？
```

> Claude Code 根据需要读取您的项目文件，您不必手动添加上下文。

---

## 步骤 5：进行您的第一次代码更改

现在让我们让 Claude Code 进行一些实际的编码。尝试一个简单的任务：

```
在主文件中添加一个 hello world 函数
```

Claude Code 将：

1. 找到适当的文件
2. 向您显示建议的更改
3. 请求您的批准
4. 进行编辑

> Claude Code 在修改文件前始终请求许可。您可以批准单个更改或为会话启用"全部接受"模式。

---

## 步骤 6：在 Claude Code 中使用 Git

Claude Code 使 Git 操作变得对话式：

```
我更改了哪些文件？
```

```
用描述性消息提交我的更改
```

您也可以提示更复杂的 Git 操作：

```
创建一个名为 feature/quickstart 的新分支
```

```
显示我最后的 5 次提交
```

```
帮我解决合并冲突
```

---

## 步骤 7：修复错误或添加功能

Claude 擅长调试和功能实现。

用自然语言描述您想要的内容：

```
向用户注册表单添加输入验证
```

或修复现有问题：

```
有一个错误，用户可以提交空表单 - 修复它
```

Claude Code 将：

- 定位相关代码
- 理解上下文
- 实现解决方案
- 如果可用，运行测试

---

## 步骤 8：尝试其他常见工作流

有多种方式可以与 Claude 一起工作：

**重构代码**

```
重构身份验证模块以使用 async/await 而不是回调
```

**编写测试**

```
为计算器函数编写单元测试
```

**更新文档**

```
使用安装说明更新 README
```

**代码审查**

```
审查我的更改并建议改进
```

> 像与有帮助的同事交谈一样与 Claude 交谈。描述您想要实现的目标，它将帮助您实现。

---

## 基本命令

以下是日常使用中最重要的命令：

| 命令                  | 功能                   | 示例                                  |
| --------------------- | ---------------------- | ------------------------------------- |
| `claude`              | 启动交互模式           | `claude`                              |
| `claude "task"`       | 运行一次性任务         | `claude "fix the build error"`        |
| `claude -p "query"`   | 运行一次性查询，然后退出 | `claude -p "explain this function"` |
| `claude -c`           | 在当前目录中继续最近的对话 | `claude -c`                        |
| `claude -r`           | 恢复之前的对话         | `claude -r`                           |
| `claude commit`       | 创建 Git 提交          | `claude commit`                       |
| `/clear`              | 清除对话历史           | `/clear`                              |
| `/help`               | 显示可用命令           | `/help`                               |
| `exit` 或 `Ctrl+C`    | 退出 Claude Code       | `exit`                                |

有关完整的命令列表，请参阅 CLI 参考。

---

## 初学者专业提示

**对您的请求要具体**

不要说：`修复错误`

尝试：`修复登录错误，用户输入错误凭证后看到空白屏幕`

**使用分步说明**

将复杂任务分解为步骤：

```
1. 为用户配置文件创建新的数据库表
2. 创建 API 端点以获取和更新用户配置文件
3. 构建允许用户查看和编辑其信息的网页
```

**让 Claude 先探索**

在进行更改之前，让 Claude 理解您的代码：

```
分析数据库架构
```

```
构建一个仪表板，显示英国客户最常退货的产品
```

**使用快捷方式节省时间**

- 按 `?` 查看所有可用的快捷键
- 使用 Tab 进行命令补全
- 按 `↑` 查看命令历史
- 输入 `/` 查看所有命令和 skills

---

## 接下来呢？

现在您已经学习了基础知识，探索更多高级功能：

- **Claude Code 如何工作**：了解代理循环、内置工具以及 Claude Code 如何与您的项目交互
- **最佳实践**：通过有效的提示和项目设置获得更好的结果
- **常见工作流**：常见任务的分步指南
- **扩展 Claude Code**：使用 CLAUDE.md、skills、hooks、MCP 等进行自定义

---

## 获取帮助

- **在 Claude Code 中**：输入 `/help` 或询问「我如何...」
- **文档**：浏览其他指南
- **社区**：加入 [Discord](https://www.anthropic.com/discord) 获取提示和支持
