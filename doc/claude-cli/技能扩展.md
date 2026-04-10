# 使用 skills 扩展 Claude

> 创建、管理和共享 skills 以在 Claude Code 中扩展 Claude 的功能。包括自定义命令和捆绑 skills。

Skills 扩展了 Claude 能做的事情。创建一个 `SKILL.md` 文件，其中包含说明，Claude 会将其添加到其工具包中。Claude 在相关时使用 skills，或者你可以使用 `/skill-name` 直接调用一个。

> **注意**：自定义命令已合并到 skills 中。`.claude/commands/deploy.md` 中的文件和 `.claude/skills/deploy/SKILL.md` 中的 skill 都会创建 `/deploy` 并以相同的方式工作。现有的 `.claude/commands/` 文件继续工作。

## 捆绑 skills

随 Claude Code 提供的内置 skills：

| Skill | 目的 |
|-------|------|
| `/batch <instruction>` | 在代码库中并行编排大规模更改，在隔离的 git worktree 中生成后台代理 |
| `/claude-api` | 加载 Claude API 参考资料（Python、TypeScript 等） |
| `/debug [description]` | 通过读取会话调试日志排查当前会话故障 |
| `/loop [interval] <prompt>` | 按间隔重复运行提示，适用于轮询部署等场景 |
| `/simplify [focus]` | 查看最近更改的文件，并行生成三个审查代理修复问题 |

## 入门

### 创建第一个 skill

```bash
mkdir -p ~/.claude/skills/explain-code
```

创建 `~/.claude/skills/explain-code/SKILL.md`：

```yaml
---
name: explain-code
description: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?"
---

When explaining code, always include:

1. **Start with an analogy**: Compare the code to something from everyday life
2. **Draw a diagram**: Use ASCII art to show the flow, structure, or relationships
3. **Walk through the code**: Explain step-by-step what happens
4. **Highlight a gotcha**: What's a common mistake or misconception?
```

调用方式：

```
How does this code work?          # Claude 自动调用
/explain-code src/auth/login.ts   # 直接调用
```

### Skills 的位置

| 位置 | 路径 | 适用于 |
|------|------|--------|
| 企业 | 托管设置 | 组织中的所有用户 |
| 个人 | `~/.claude/skills/<skill-name>/SKILL.md` | 你的所有项目 |
| 项目 | `.claude/skills/<skill-name>/SKILL.md` | 仅此项目 |
| 插件 | `<plugin>/skills/<skill-name>/SKILL.md` | 启用插件的位置 |

优先级：企业 > 个人 > 项目。

### Skill 目录结构

```
my-skill/
├── SKILL.md           # 主要说明（必需）
├── template.md        # Claude 要填写的模板
├── examples/
│   └── sample.md      # 示例输出
└── scripts/
    └── validate.sh    # Claude 可以执行的脚本
```

## 配置 skills

### Frontmatter 参考

```yaml
---
name: my-skill
description: What this skill does
disable-model-invocation: true
allowed-tools: Read, Grep
---
```

| 字段 | 必需 | 描述 |
|------|------|------|
| `name` | 否 | 显示名称（目录名为默认） |
| `description` | 推荐 | 功能描述，Claude 用于决定何时使用 |
| `argument-hint` | 否 | 自动完成期间显示的提示 |
| `disable-model-invocation` | 否 | `true` 防止 Claude 自动加载，只能手动调用 |
| `user-invocable` | 否 | `false` 从 `/` 菜单中隐藏 |
| `allowed-tools` | 否 | skill 处于活动状态时可使用的工具 |
| `model` | 否 | 活动时使用的模型 |
| `context` | 否 | `fork` 则在分叉的 subagent 上下文中运行 |
| `agent` | 否 | `context: fork` 时使用的 subagent 类型 |
| `hooks` | 否 | 限定于此 skill 生命周期的 hooks |

### 字符串替换

| 变量 | 描述 |
|------|------|
| `$ARGUMENTS` | 调用时传递的所有参数 |
| `$ARGUMENTS[N]` | 按 0 基索引访问特定参数 |
| `$N` | `$ARGUMENTS[N]` 简写 |
| `${CLAUDE_SESSION_ID}` | 当前会话 ID |
| `${CLAUDE_SKILL_DIR}` | 包含 SKILL.md 的目录路径 |

### 控制谁调用 skill

| Frontmatter | 你可以调用 | Claude 可以调用 |
|-------------|-----------|----------------|
| （默认） | 是 | 是 |
| `disable-model-invocation: true` | 是 | 否 |
| `user-invocable: false` | 否 | 是 |

**部署示例**（只有你能触发）：

```yaml
---
name: deploy
description: Deploy the application to production
disable-model-invocation: true
---

Deploy $ARGUMENTS to production:
1. Run the test suite
2. Build the application
3. Push to the deployment target
```

### 传递参数

```yaml
---
name: fix-issue
description: Fix a GitHub issue
---

Fix GitHub issue $ARGUMENTS following our coding standards.
```

运行 `/fix-issue 123` → Claude 收到 "Fix GitHub issue 123..."

多参数：

```yaml
---
name: migrate-component
description: Migrate a component from one framework to another
---

Migrate the $0 component from $1 to $2.
```

运行 `/migrate-component SearchBar React Vue`

### 限制工具访问

```yaml
---
name: safe-reader
description: Read files without making changes
allowed-tools: Read, Grep, Glob
---
```

### 添加支持文件

从 `SKILL.md` 中引用支持文件：

```markdown
## Additional resources

- For complete API details, see [reference.md](reference.md)
- For usage examples, see [examples.md](examples.md)
```

> 将 `SKILL.md` 保持在 500 行以下，将详细参考移到单独文件。

## 高级模式

### 注入动态上下文

`!`command`` 语法在发送给 Claude 之前运行 shell 命令：

```yaml
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

## Pull request context
- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

## Your task
Summarize this pull request...
```

### 在 subagent 中运行 skills

添加 `context: fork` 使 skill 在隔离 subagent 中运行：

```yaml
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:

1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
```

`agent` 字段选项：`Explore`、`Plan`、`general-purpose` 或自定义 subagent。

| 方法 | 系统提示 | 任务 |
|------|---------|------|
| 带 `context: fork` 的 Skill | 来自代理类型 | SKILL.md 内容 |
| 带 `skills` 字段的 Subagent | Subagent 的 markdown 正文 | Claude 的委派消息 |

> 使用 `context: fork` 时，skill 内容变成驱动 subagent 的提示，无法访问对话历史。

### 限制 Claude 的 skill 访问

禁用所有 skills（在 `/permissions` 中拒绝 Skill 工具）：

```
Skill
```

允许或拒绝特定 skills：

```
# 允许
Skill(commit)
Skill(review-pr *)

# 拒绝
Skill(deploy *)
```

## 共享 skills

* **项目 skills**：将 `.claude/skills/` 提交到版本控制
* **插件**：在插件中创建 `skills/` 目录
* **托管**：通过托管设置部署组织范围

## 故障排除

**Skill 未触发**：
1. 检查描述是否包含用户会自然说的关键字
2. 验证 skill 是否出现在 `What skills are available?` 中
3. 使用 `/skill-name` 直接调用测试

**Skill 触发过于频繁**：
1. 使描述更具体
2. 添加 `disable-model-invocation: true`

**Claude 看不到所有 skills**：
Skill 描述有字符预算（上下文窗口的 2%，回退为 16,000 个字符）。运行 `/context` 检查排除警告。设置 `SLASH_COMMAND_TOOL_CHAR_BUDGET` 环境变量覆盖限制。

## 相关资源

* [Subagents](/zh-CN/sub-agents)：将任务委托给专门的代理
* [Plugins](/zh-CN/plugins)：打包和分发 skills
* [Hooks](/zh-CN/hooks)：围绕工具事件自动化工作流
* [Memory](/zh-CN/memory)：管理 CLAUDE.md 文件
* [Permissions](/zh-CN/permissions)：控制工具和 skill 访问
