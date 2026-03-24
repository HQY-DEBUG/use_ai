# Overview of Customizing GitHub Copilot CLI

Copilot CLI functions optimally with project-specific customization. While it operates immediately after installation without mandatory setup, personalizing it with guidelines, context, and relevant tools significantly enhances response quality.

## Custom Instructions

Users can establish directives for Copilot's responses. These instructions integrate into every prompt, enabling developers to communicate coding standards and project details without repetitive explanation during each session.

For more information, see [Adding custom instructions for GitHub Copilot CLI](add-custom-instructions.md).

## Hooks

Hooks execute shell commands at critical junctures in Copilot CLI workflows. They automate operations triggered by specific events—session initiation, prompt submission, task completion, or errors. A practical example: automatically run tests after Copilot makes changes to code files.

For more information, see [Using hooks with GitHub Copilot CLI](use-hooks.md).

## Skills

Skills represent folders containing instructions, scripts, and resources that enhance Copilot's specialization. Adding them equips Copilot with domain-specific knowledge for particular technologies or workflows.

For more information, see [Creating agent skills for GitHub Copilot CLI](create-skills.md).

## Custom Agents

Custom agents define specialized expertise and behavior for particular task types. Operating as subagents with independent context windows, they prevent context cluttering in the main agent. Tool access can be restricted—for instance, a reviewer agent typically cannot modify code files.

For more information, see [Creating and using custom agents for GitHub Copilot CLI](create-custom-agents-for-cli.md).

## MCP Servers

The Model Context Protocol enables integrating external tools and data sources. This allows functionality including database queries, issue tracking access, CI/CD pipeline integration, diagram generation, documentation searching, ticket booking, and calendar integration.

For more information, see [Adding MCP servers for GitHub Copilot CLI](add-mcp-servers.md).

## Plugins

Copilot CLI plugins are distributable packages bundling multiple customization components into single installable units, deployable from repositories, marketplaces, or local paths.

For more information, see:
- [Finding and installing plugins for GitHub Copilot CLI](plugins-finding-installing.md)
- [Creating a plugin for GitHub Copilot CLI](plugins-creating.md)
- [Creating a plugin marketplace for GitHub Copilot CLI](plugins-marketplace.md)
