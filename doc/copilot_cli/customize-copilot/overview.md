# Overview of Customizing GitHub Copilot CLI / 自定义 GitHub Copilot CLI 概述

Copilot CLI functions optimally with project-specific customization. While it operates immediately after installation without mandatory setup, personalizing it with guidelines, context, and relevant tools significantly enhances response quality.

Copilot CLI 在针对项目进行自定义后表现最佳。虽然安装后无需强制设置即可立即使用，但通过指南、上下文和相关工具进行个性化设置能显著提升响应质量。

## Custom Instructions / 自定义指令

Users can establish directives for Copilot's responses. These instructions integrate into every prompt, enabling developers to communicate coding standards and project details without repetitive explanation during each session.

用户可以为 Copilot 的响应建立指令。这些指令会整合到每条提示词中，使开发者无需在每次会话中重复说明编码标准和项目详情。

For more information, see [Adding custom instructions for GitHub Copilot CLI / 添加自定义指令](add-custom-instructions.md).

## Hooks / Hooks

Hooks execute shell commands at critical junctures in Copilot CLI workflows. They automate operations triggered by specific events—session initiation, prompt submission, task completion, or errors. A practical example: automatically run tests after Copilot makes changes to code files.

Hooks 在 Copilot CLI 工作流的关键节点执行 shell 命令。它们自动化由特定事件触发的操作——会话启动、提示词提交、任务完成或错误。一个实际示例：在 Copilot 修改代码文件后自动运行测试。

For more information, see [Using hooks with GitHub Copilot CLI / 使用 Hooks](use-hooks.md).

## Skills / 技能

Skills represent folders containing instructions, scripts, and resources that enhance Copilot's specialization. Adding them equips Copilot with domain-specific knowledge for particular technologies or workflows.

技能是包含指令、脚本和资源的文件夹，用于增强 Copilot 的专业化能力。添加技能为 Copilot 提供特定技术或工作流的领域知识。

For more information, see [Creating agent skills for GitHub Copilot CLI / 创建 Agent 技能](create-skills.md).

## Custom Agents / 自定义 Agent

Custom agents define specialized expertise and behavior for particular task types. Operating as subagents with independent context windows, they prevent context cluttering in the main agent. Tool access can be restricted—for instance, a reviewer agent typically cannot modify code files.

自定义 Agent 为特定任务类型定义专业知识和行为。作为具有独立上下文窗口的子 Agent 运行，可防止主 Agent 的上下文混乱。工具访问可以受到限制——例如，审查 Agent 通常无法修改代码文件。

For more information, see [Creating and using custom agents for GitHub Copilot CLI / 创建和使用自定义 Agent](create-custom-agents-for-cli.md).

## MCP Servers / MCP 服务器

The Model Context Protocol enables integrating external tools and data sources. This allows functionality including database queries, issue tracking access, CI/CD pipeline integration, diagram generation, documentation searching, ticket booking, and calendar integration.

模型上下文协议支持集成外部工具和数据源。这允许实现数据库查询、问题跟踪访问、CI/CD 管道集成、图表生成、文档搜索、票务预订和日历集成等功能。

For more information, see [Adding MCP servers for GitHub Copilot CLI / 添加 MCP 服务器](add-mcp-servers.md).

## Plugins / 插件

Copilot CLI plugins are distributable packages bundling multiple customization components into single installable units, deployable from repositories, marketplaces, or local paths.

Copilot CLI 插件是可分发的包，将多个自定义组件捆绑成单个可安装单元，可从仓库、市场或本地路径部署。

For more information, see:
- [Finding and installing plugins for GitHub Copilot CLI / 查找和安装插件](plugins-finding-installing.md)
- [Creating a plugin for GitHub Copilot CLI / 创建插件](plugins-creating.md)
- [Creating a plugin marketplace for GitHub Copilot CLI / 创建插件市场](plugins-marketplace.md)
