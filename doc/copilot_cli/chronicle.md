# GitHub Copilot CLI Session Data Management / GitHub Copilot CLI 会话数据管理

## Overview / 概述

GitHub Copilot CLI maintains local session data enabling users to resume previous work, access session history insights, and ask questions about their CLI usage patterns.

GitHub Copilot CLI 在本地维护会话数据，使用户能够恢复之前的工作、访问会话历史洞察，并对 CLI 使用模式提出问题。

## Key Capabilities / 核心功能

The session data feature allows developers to:

会话数据功能允许开发者：

- **Resume interrupted work** from previous CLI sessions / **恢复中断的工作**：继续之前的 CLI 会话
- **Generate insights** using the `/chronicle` command for standup reports and personalized recommendations / **生成洞察**：使用 `/chronicle` 命令生成站会报告和个性化建议
- **Query session history** through natural language questions about past interactions / **查询会话历史**：通过自然语言问题了解过去的交互记录

## Resuming Sessions / 恢复会话

Three methods exist for returning to previous work:

恢复之前工作有三种方式：

1. Command line: Use `copilot --continue` for the most recent session, or `copilot --resume` to choose from a list / 命令行：使用 `copilot --continue` 恢复最近会话，或使用 `copilot --resume` 从列表中选择
2. Direct resumption: Run `copilot --resume SESSION-ID` with a known session identifier / 直接恢复：使用已知会话 ID 运行 `copilot --resume SESSION-ID`
3. Active session: Type `/resume` to switch sessions mid-workflow / 活动会话中：输入 `/resume` 在工作流中途切换会话

## Session Management / 会话管理

**Renaming sessions** helps with organization. Use `/rename NEW_NAME` to label sessions for easier identification in picker lists.

**重命名会话**有助于组织管理。使用 `/rename 新名称` 为会话添加标签，便于在选择列表中识别。

**Sharing sessions** preserves work records through:

**共享会话**通过以下方式保留工作记录：

- `/share gist` — exports to a private GitHub gist / 导出为私有 GitHub gist
- `/share file [PATH]` — saves as Markdown (defaults to current directory) / 保存为 Markdown 文件（默认为当前目录）

## Chronicle Command Features / Chronicle 命令功能

The `/chronicle` slash command (requiring experimental mode) offers targeted insights:

`/chronicle` 斜杠命令（需要实验模式）提供针对性洞察：

| Function / 功能 | Purpose / 用途 |
|----------|---------|
| `standup` | Generate a short report based on your Copilot CLI sessions / 根据 Copilot CLI 会话生成简短报告 |
| `tips` | Analyzes usage patterns for 3–5 personalized recommendations / 分析使用模式，提供 3–5 条个性化建议 |
| `improve` | Examines friction points to suggest `.github/copilot-instructions.md` updates / 检查摩擦点，建议更新 `.github/copilot-instructions.md` |
| `reindex` | Rebuilds the session store index / 重建会话存储索引 |

Example usage / 示例用法：
```shell
/chronicle standup
/chronicle tips
```

## Natural Language Queries / 自然语言查询

Users can ask freeform questions about their session history, such as:

用户可以对会话历史提出自由格式的问题，例如：

- Productivity patterns / 生产力模式
- Cost optimization strategies / 成本优化策略
- Task success rates / 任务成功率
- Previous work on specific topics / 特定主题的历史工作记录
