# Best Practices for GitHub Copilot CLI / GitHub Copilot CLI 最佳实践

## Overview / 概述

GitHub Copilot CLI is a terminal-based AI assistant bringing autonomous capabilities directly to your command line. Rather than functioning solely as a chatbot, its primary strength lies in operating as an independent coding partner that can handle delegated tasks while you maintain oversight.

GitHub Copilot CLI 是一款基于终端的 AI 助手，将自主代理能力直接带到命令行。它的主要优势不仅在于聊天对话，更在于作为独立编程伙伴，在你保持监督的同时处理委托任务。

## 1. Customize Your Environment / 自定义你的环境

### Custom Instructions Files / 自定义指令文件

Copilot CLI automatically reads instructions from multiple locations, enabling organization-wide standards and repository-specific conventions:

Copilot CLI 自动从多个位置读取指令，支持组织级标准和仓库特定规范：

| Location / 位置 | Scope / 作用域 |
|----------|-------|
| `~/.copilot/copilot-instructions.md` | All sessions (global) / 所有会话（全局） |
| `.github/copilot-instructions.md` | Repository / 仓库级 |
| `.github/instructions/**/*.instructions.md` | Repository (modular) / 仓库级（模块化） |
| `AGENTS.md` (in Git root or cwd) | Repository / 仓库级 |
| `Copilot.md`, `GEMINI.md`, `CODEX.md` | Repository / 仓库级 |

**Best Practice / 最佳实践：** "Keep instructions concise and actionable. Lengthy instructions can dilute effectiveness." / "保持指令简洁且可操作。冗长的指令会降低效果。"

Repository instructions take precedence over global instructions, allowing teams to enforce specific conventions.

仓库级指令优先于全局指令，允许团队强制执行特定规范。

### Configure Allowed Tools / 配置允许的工具

Control which tools Copilot can execute without requesting permission:

控制 Copilot 无需请求许可即可执行的工具：

```bash
copilot --allow-tool='shell(git:*)' --deny-tool='shell(git push)'
```

Reset previously approved tools with `/reset-allowed-tools`.

使用 `/reset-allowed-tools` 重置之前批准的工具。

Common patterns include / 常用模式：
- `shell(git:*)` — All Git commands / 所有 Git 命令
- `shell(npm run:*)` — All npm scripts / 所有 npm 脚本
- `shell(npm run test:*)` — npm test commands / npm 测试命令
- `write` — File writes / 文件写入

### Select Your Preferred Model / 选择偏好模型

| Model / 模型 | Best For / 最适用于 | Tradeoffs / 权衡 |
|-------|----------|-----------|
| **Claude Opus 4.5** (default) | Complex architecture, difficult debugging, nuanced refactoring / 复杂架构、困难调试、精细重构 | Most capable; uses more premium requests / 能力最强；消耗更多高级请求 |
| **Claude Sonnet 4.5** | Day-to-day coding, routine tasks / 日常编码、常规任务 | Fast, cost-effective / 快速、高性价比 |
| **GPT-5.2 Codex** | Code generation, code review, straightforward implementations / 代码生成、代码审查、简单实现 | Excellent for reviewing other models' code / 擅长审查其他模型的代码 |

Use `/model` to switch models during your session. / 使用 `/model` 在会话中切换模型。

## 2. Plan Before You Code / 编码前先规划

### Plan Mode / 计划模式

"Models achieve higher success rates when given a concrete plan to follow." In plan mode, Copilot creates a structured implementation plan before writing code.

"当模型有具体计划可遵循时，成功率更高。" 在计划模式下，Copilot 在编写代码前会创建结构化的实现计划。

Toggle plan mode with **Shift+Tab**, or use `/plan` from normal mode:

使用 **Shift+Tab** 切换计划模式，或在普通模式下使用 `/plan`：

```
/plan Add OAuth2 authentication with Google and GitHub providers
```

The system will / 系统将会：
- Analyze your request and codebase / 分析你的请求和代码库
- Ask clarifying questions / 提出澄清性问题
- Create a structured implementation plan with checkboxes / 创建带复选框的结构化实现计划
- Save the plan to `plan.md` in your session folder / 将计划保存到会话文件夹的 `plan.md`
- Await your approval before implementing / 在实现前等待你的批准

Edit the plan with **Ctrl+y**. / 使用 **Ctrl+y** 编辑计划。

### When to Use Plan Mode / 何时使用计划模式

| Scenario / 场景 | Recommended / 推荐 |
|----------|-------------|
| Complex multi-file changes / 复杂的多文件变更 | ✓ Yes / 是 |
| Refactoring with many touch points / 涉及大量接触点的重构 | ✓ Yes / 是 |
| New feature implementation / 新功能实现 | ✓ Yes / 是 |
| Quick bug fixes / 快速修复 bug | ✗ No / 否 |
| Single file changes / 单文件变更 | ✗ No / 否 |

### Recommended Workflow / 推荐工作流

For complex tasks, follow this pattern / 对于复杂任务，遵循以下模式：
1. **Explore / 探索**: Read relevant files without writing code / 阅读相关文件，不编写代码
2. **Plan / 规划**: Use `/plan` to outline the approach / 使用 `/plan` 概述方案
3. **Review / 审查**: Check and suggest modifications to the plan / 检查并建议修改计划
4. **Implement / 实现**: Proceed with implementation / 进行实现
5. **Verify / 验证**: Run tests and fix failures / 运行测试并修复失败
6. **Commit / 提交**: Use descriptive commit messages / 使用描述性提交信息

## 3. Leverage Infinite Sessions / 善用无限会话

### Automatic Context Window Management / 自动上下文窗口管理

Copilot CLI features infinite sessions with automatic context management through intelligent compaction that summarizes conversation history while maintaining essential information.

Copilot CLI 提供无限会话功能，通过智能压缩自动管理上下文，在保留关键信息的同时汇总对话历史。

Session storage location / 会话存储位置：
```
~/.copilot/session-state/{session-id}/
├── events.jsonl      # Full session history / 完整会话历史
├── workspace.yaml    # Metadata / 元数据
├── plan.md           # Implementation plan (if created) / 实现计划（如已创建）
├── checkpoints/      # Compaction history / 压缩历史
└── files/            # Persistent artifacts / 持久化产物
```

Manually trigger compaction with `/compact` if needed (rarely necessary).

如需要可使用 `/compact` 手动触发压缩（通常不必要）。

### Session Management Commands / 会话管理命令

- `/session` — View current CLI session information / 查看当前 CLI 会话信息
- `/session checkpoints` — View list of session checkpoints / 查看会话检查点列表
- `/session checkpoints NUMBER` — View details of a specific checkpoint / 查看特定检查点详情
- `/session files` — View temporary files created during session / 查看会话期间创建的临时文件
- `/session plan` — View the current plan if generated / 查看当前已生成的计划

### Best Practice: Keep Sessions Focused / 最佳实践：保持会话专注

"While infinite sessions allow long-running work, focused sessions produce better results." Use `/clear` or `/new` between unrelated tasks to reset context and improve response quality.

"虽然无限会话允许长期运行，但专注的会话能产生更好的结果。" 在不相关任务之间使用 `/clear` 或 `/new` 重置上下文，提高响应质量。

Visualize context usage with `/context`, which shows / 使用 `/context` 可视化上下文使用情况，显示：
- System/tools tokens / 系统/工具令牌
- Message history tokens / 消息历史令牌
- Available free space / 可用剩余空间
- Buffer allocation / 缓冲区分配

## 4. Delegate Work Effectively / 有效委托工作

### The `/delegate` Command / `/delegate` 命令

Offload work to the cloud using Copilot coding agent for / 使用 Copilot 编码 Agent 将工作转移到云端，适用于：
- Asynchronous tasks / 异步任务
- Changes to other repositories / 其他仓库的变更
- Long-running operations / 长时间运行的操作

```
/delegate Add dark mode support to the settings page
```

The agent creates a pull request with changes while you continue local work.

Agent 创建包含变更的 Pull Request，同时你可以继续本地工作。

### When to Use `/delegate` / 何时使用 `/delegate`

| Use `/delegate` / 使用 `/delegate` | Work Locally / 本地工作 |
|-----------------|-------------|
| Tangential tasks / 旁支任务 | Core feature work / 核心功能工作 |
| Documentation updates / 文档更新 | Debugging / 调试 |
| Refactoring separate modules / 重构独立模块 | Interactive exploration / 交互式探索 |

## 5. Common Workflows / 常见工作流

### Codebase Onboarding / 代码库入门

Use Copilot as a pair programming partner when joining new projects / 加入新项目时将 Copilot 作为结对编程伙伴：
- "How is logging configured in this project?" / "这个项目的日志是如何配置的？"
- "What's the pattern for adding a new API endpoint?" / "添加新 API 端点的模式是什么？"
- "Explain the authentication flow" / "解释身份验证流程"
- "Where are the database migrations?" / "数据库迁移在哪里？"

### Test-Driven Development / 测试驱动开发

Partner with Copilot to develop tests / 与 Copilot 协作开发测试：
1. Request failing tests for a specific flow / 请求为特定流程创建失败测试
2. Review and approve the tests / 审查并批准测试
3. Ask Copilot to implement code making tests pass / 请 Copilot 实现让测试通过的代码
4. Review the implementation / 审查实现
5. Commit with conventional commit message / 使用规范提交信息提交

### Code Review Assistance / 代码审查辅助

```
/review Use Opus 4.5 and Codex 5.2 to review changes in my current branch
against `main`. Focus on potential bugs and security issues.
```

### Git Operations / Git 操作

Copilot excels at Git workflows / Copilot 擅长 Git 工作流：
- "What changes went into version `2.3.0`?" / "`2.3.0` 版本包含了哪些变更？"
- "Create a PR for this branch with a detailed description" / "为这个分支创建带详细描述的 PR"
- "Rebase this branch against `main`" / "将此分支 rebase 到 `main`"
- "Resolve the merge conflicts in `package.json`" / "解决 `package.json` 中的合并冲突"

### Bug Investigation / Bug 排查

```
The `/api/users` endpoint returns 500 errors intermittently. Search
the codebase and logs to identify the root cause.
```

### Refactoring / 重构

```
/plan Migrate all class components to functional components with hooks
```

## 6. Advanced Patterns / 高级模式

### Work Across Multiple Repositories / 跨多个仓库工作

#### Option 1: Run from Parent Directory / 方案一：从父目录运行

```bash
cd ~/projects
copilot
```

Copilot accesses all child repositories simultaneously—ideal for microservices and coordinated changes.

Copilot 同时访问所有子仓库——非常适合微服务和协调变更。

#### Option 2: Use `/add-dir` to Expand Access / 方案二：使用 `/add-dir` 扩展访问范围

```
/add-dir /Users/me/projects/backend-service
/add-dir /Users/me/projects/shared-libs
/add-dir /Users/me/projects/documentation
```

View allowed directories with `/list-dirs`. / 使用 `/list-dirs` 查看允许的目录。

### Using Images for UI Work / 使用图片进行 UI 工作

Drag and drop images directly into CLI input or reference files / 将图片直接拖放到 CLI 输入中或引用文件：
```
Implement this design: @mockup.png
Match the layout and spacing exactly
```

### Checklists for Complex Migrations / 复杂迁移的检查清单

```
Run the linter and write all errors to `migration-checklist.md`
as a checklist. Then fix each issue one by one, checking them off.
```

### Autonomous Task Completion / 自主任务完成

Switch into autopilot mode for long-running tasks not requiring constant supervision. Use `/fleet` at the start of your prompt to break tasks into parallel subtasks run by subagents.

切换到自动驾驶模式处理无需持续监督的长期任务。在提示词开头使用 `/fleet` 将任务分解为由子 Agent 并行运行的子任务。

## 7. Team Guidelines / 团队规范

### Recommended Repository Setup / 推荐的仓库设置

Create `.github/copilot-instructions.md` containing / 创建 `.github/copilot-instructions.md`，包含：
- Build and test commands / 构建和测试命令
- Code style guidelines / 代码风格指南
- Required checks before commits / 提交前的必要检查
- Architecture decisions / 架构决策

Establish conventions for / 建立以下规范：
- When to use `/plan` (complex features, refactoring) / 何时使用 `/plan`（复杂功能、重构）
- When to use `/delegate` (tangential work) / 何时使用 `/delegate`（旁支工作）
- Code review processes with AI assistance / AI 辅助的代码审查流程

### Security Considerations / 安全注意事项

- Copilot CLI requires explicit approval for destructive operations / Copilot CLI 对破坏性操作需要明确批准
- Review all proposed changes before accepting / 接受前审查所有建议的变更
- Use permission allowlists judiciously / 谨慎使用权限允许列表
- Verify commits never contain secrets / 确保提交不包含机密信息

### Measuring Productivity / 衡量生产力

Track metrics including / 追踪以下指标：
- Time from issue to pull request / 从 issue 到 PR 的时间
- Number of iterations before merge / 合并前的迭代次数
- Code review feedback cycles / 代码审查反馈周期
- Test coverage improvements / 测试覆盖率提升

## Getting Help / 获取帮助

Display help from the command line / 在命令行显示帮助：
```bash
copilot -h
copilot help TOPIC
```

Where `TOPIC` can be / `TOPIC` 可以是：`config`, `commands`, `environment`, `logging`, or `permissions`.

Within the CLI / 在 CLI 内：
- `/help` — Display help / 显示帮助
- `/usage` — View usage statistics / 查看使用统计
- `/feedback` — Submit feedback, bug reports, or feature requests / 提交反馈、bug 报告或功能请求

## Further Resources / 延伸资源

- [Using GitHub Copilot CLI / 使用指南](use-copilot-cli-agents/overview.md)
- [GitHub Copilot CLI command reference / 命令参考](reference/cli-command-reference.md)
