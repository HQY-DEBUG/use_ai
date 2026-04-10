# Adding Custom Instructions for GitHub Copilot CLI / 为 GitHub Copilot CLI 添加自定义指令

## Overview / 概述

GitHub Copilot can deliver tailored responses when given contextual information about your project. Rather than repeatedly including this context in prompts, you can create custom instructions that automatically supplement your requests with relevant details.

当提供项目上下文信息时，GitHub Copilot 可以提供量身定制的响应。无需在每条提示词中重复包含此上下文，你可以创建自定义指令，自动用相关详情补充你的请求。

## Four Types of Custom Instructions / 四种自定义指令类型

**Repository-wide instructions / 仓库范围指令** apply to all requests within a repository and are stored in `.github/copilot-instructions.md`. / 适用于仓库内的所有请求，存储在 `.github/copilot-instructions.md` 中。

**Path-specific instructions / 路径特定指令** target files matching specified patterns and are placed in `.github/instructions/NAME.instructions.md` files using glob syntax for file matching. / 针对匹配指定模式的文件，使用 glob 语法放置在 `.github/instructions/NAME.instructions.md` 文件中。

**Agent instructions / Agent 指令** are utilized by AI agents and can be defined in `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md` files. Primary instructions in the repository root have greater impact. / 由 AI Agent 使用，可以在 `AGENTS.md`、`CLAUDE.md` 或 `GEMINI.md` 文件中定义。仓库根目录中的主要指令影响更大。

**Local instructions / 本地指令** apply within your personal environment via `$HOME/.copilot/copilot-instructions.md` or through the `COPILOT_CUSTOM_INSTRUCTIONS_DIRS` environment variable. / 通过 `$HOME/.copilot/copilot-instructions.md` 或 `COPILOT_CUSTOM_INSTRUCTIONS_DIRS` 环境变量应用于个人环境。

## Instruction File Locations / 指令文件位置

| Location / 位置 | Scope / 作用域 |
|----------|-------|
| `~/.copilot/copilot-instructions.md` | All sessions (global) / 所有会话（全局） |
| `.github/copilot-instructions.md` | Repository-wide / 仓库范围 |
| `.github/instructions/**/*.instructions.md` | Repository (path-specific) / 仓库（路径特定） |
| `AGENTS.md` (in Git root or cwd) | Repository (agent instructions) / 仓库（Agent 指令） |

Repository instructions take precedence over global instructions.

仓库级指令优先于全局指令。

## Creating Repository-Wide Instructions / 创建仓库范围指令

1. Create `.github/copilot-instructions.md` at your repository root. / 在仓库根目录创建 `.github/copilot-instructions.md`。
2. Write instructions in natural language Markdown format. / 以自然语言 Markdown 格式编写指令。
3. Formatting (spacing, line breaks) doesn't affect functionality. / 格式（间距、换行）不影响功能。

## Creating Path-Specific Instructions / 创建路径特定指令

1. Create the `.github/instructions` directory. / 创建 `.github/instructions` 目录。
2. Add `NAME.instructions.md` files within it. / 在其中添加 `NAME.instructions.md` 文件。
3. Include frontmatter with glob patterns: / 包含带 glob 模式的 frontmatter：
   ```yaml
   ---
   applyTo: "**/*.ts,**/*.tsx"
   ---
   ```
4. Optionally exclude specific agents using `excludeAgent: "code-review"`. / 可选择使用 `excludeAgent: "code-review"` 排除特定 Agent。
5. Write instructions in Markdown format. / 以 Markdown 格式编写指令。

## Implementation Notes / 实现说明

Instructions become available to Copilot immediately upon saving. Changes made during a session take effect on your next prompt submission. When both repository-wide and path-specific instructions exist, both are used—avoid conflicting directives as Copilot's resolution behavior is unpredictable.

指令在保存后立即对 Copilot 生效。会话期间所做的更改在下次提交提示词时生效。当仓库范围和路径特定指令同时存在时，两者都会被使用——避免冲突指令，因为 Copilot 的解析行为不可预测。
