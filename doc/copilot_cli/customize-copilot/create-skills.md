# Creating Agent Skills for GitHub Copilot CLI / 为 GitHub Copilot CLI 创建 Agent 技能

Agent skills are customizable folders containing instructions, scripts, and resources that enhance Copilot's performance on specialized tasks.

Agent 技能是包含指令、脚本和资源的可自定义文件夹，用于增强 Copilot 在专业任务上的表现。

## Setting Up Skills / 设置技能

To establish a skill, create a `SKILL.md` file along with any supporting resources in designated directories:

要创建技能，在指定目录中创建 `SKILL.md` 文件以及所有支持资源：

**Project skills (repository-specific) / 项目技能（仓库特定）**: `.github/skills` or `.claude/skills`

**Personal skills (multi-project) / 个人技能（多项目）**: `~/.copilot/skills` or `~/.claude/skills`

Each skill requires its own subdirectory with a lowercase, hyphenated name.

每个技能需要自己的子目录，使用小写连字符命名。

## SKILL.md File Structure / SKILL.md 文件结构

The `SKILL.md` file combines YAML frontmatter with Markdown content:

`SKILL.md` 文件将 YAML frontmatter 与 Markdown 内容结合：

**Required frontmatter / 必需 frontmatter：**
- **name**: Lowercase identifier matching the directory name (letters, numbers, hyphens; max 64 chars) / 与目录名匹配的小写标识符（字母、数字、连字符；最多 64 个字符）
- **description**: Explains the skill's purpose and activation triggers (max 1024 chars) / 说明技能的用途和激活触发器（最多 1024 个字符）

**Optional frontmatter / 可选 frontmatter：**
- **allowed-tools**: Auto-allowed tools on activation / 激活时自动允许的工具
- **user-invocable**: Enable `/SKILL-NAME` invocation (default: true) / 启用 `/技能名` 调用（默认：true）
- **disable-model-invocation**: Prevent agent auto-invocation (default: false) / 阻止 Agent 自动调用（默认：false）
- **license**: Licensing information / 许可证信息

**Markdown body / Markdown 正文：** Instructions, examples, and guidelines for Copilot / Copilot 的指令、示例和指南

## Skill Locations (Priority Order) / 技能位置（优先级顺序）

| Location / 位置 | Scope / 作用域 | Description / 说明 |
|----------|-------|-------------|
| `.github/skills/` | Project / 项目 | Project-specific / 项目特定 |
| `.agents/skills/` | Project / 项目 | Alternative project location / 替代项目位置 |
| `.claude/skills/` | Project / 项目 | Claude-compatible / Claude 兼容 |
| Parent `.github/skills/` | Inherited / 继承 | Monorepo support / Monorepo 支持 |
| `~/.copilot/skills/` | Personal / 个人 | All projects / 所有项目 |
| `~/.claude/skills/` | Personal / 个人 | Claude-compatible / Claude 兼容 |
| Plugin directories / 插件目录 | Plugin / 插件 | Plugin skills / 插件技能 |
| `COPILOT_SKILLS_DIRS` | Custom / 自定义 | Custom directories / 自定义目录 |

## Example Implementation / 示例实现

A GitHub Actions debugging skill located in `.github/skills/github-actions-failure-debugging/` with `SKILL.md`:

位于 `.github/skills/github-actions-failure-debugging/` 的 GitHub Actions 调试技能，`SKILL.md` 内容：

```markdown
---
name: github-actions-failure-debugging
description: Debug failing GitHub Actions workflows
allowed-tools: shell(gh:*)
---

Use the `list_workflow_runs` tool to look up recent workflow runs.
Summarize failures before accessing full logs.
```

## Accessing Skills / 访问技能

Copilot automatically selects relevant skills based on your prompt. You can explicitly invoke a skill by prefixing its name with a forward slash (e.g., `/frontend-design`).

Copilot 根据你的提示词自动选择相关技能。你可以通过在技能名前加斜杠来显式调用技能（例如 `/frontend-design`）。

**Available CLI commands / 可用 CLI 命令：**
- `/skills list` – View available skills / 查看可用技能
- `/skills` – Toggle skills on/off / 切换技能开关
- `/skills info` – Get skill details and locations / 获取技能详情和位置
- `/skills add` – Register alternative skill locations / 注册替代技能位置
- `/skills reload` – Refresh skills mid-session / 会话中刷新技能
- `/skills remove SKILL-DIRECTORY` – Delete custom skills / 删除自定义技能

## Skills vs. Custom Instructions / 技能与自定义指令的区别

Use custom instructions for broad coding standards applicable project-wide. Reserve skills for detailed, task-specific guidance that Copilot should access selectively.

对于适用于整个项目的广泛编码标准，使用自定义指令。将技能保留用于 Copilot 应有选择地访问的详细、任务特定指南。

## Alternative: Commands Format / 替代方案：Commands 格式

Commands stored as `.md` files in `.claude/commands/` use simplified format (no `name` field required). Command name derives from filename. Lower priority than skills with same name.

存储在 `.claude/commands/` 中的 `.md` 文件使用简化格式（不需要 `name` 字段）。命令名称源自文件名。优先级低于同名技能。
