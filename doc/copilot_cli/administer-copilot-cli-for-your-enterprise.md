# Administering Copilot CLI for Your Enterprise / 为企业管理 Copilot CLI

## Overview / 概述

Enterprise owners can manage Copilot CLI usage through policy configuration. The process involves accessing enterprise settings and selecting preferred policies for the tool.

企业所有者可以通过策略配置管理 Copilot CLI 的使用。操作流程包括访问企业设置并为该工具选择所需策略。

## Enabling or Disabling Copilot CLI / 启用或禁用 Copilot CLI

To configure Copilot CLI policies:

配置 Copilot CLI 策略的步骤：

1. Navigate to your enterprise on GitHub.com / 在 GitHub.com 进入你的企业页面
2. Click the **AI controls** option at the top / 点击顶部的 **AI controls** 选项
3. Select **Copilot** from the sidebar / 在侧边栏选择 **Copilot**
4. In the "Copilot Clients" section, choose your desired policy for Copilot CLI / 在"Copilot Clients"部分，为 Copilot CLI 选择所需策略

## Enterprise Controls That Apply to Copilot CLI / 适用于 Copilot CLI 的企业控制项

Several enterprise-level policies directly affect Copilot CLI:

以下几项企业级策略直接影响 Copilot CLI：

- **Enablement / 启用控制**: Control access at enterprise or organization level / 在企业或组织级别控制访问权限
- **Model Selection / 模型选择**: Available models reflect enterprise-level choices; users can check options via `/model` command / 可用模型反映企业级选择，用户可通过 `/model` 命令查看选项
- **Custom Agents / 自定义 Agent**: Enterprise-configured agents are accessible within Copilot CLI / 企业配置的 Agent 可在 Copilot CLI 中使用
- **Coding Agent Access / 编码 Agent 访问**: Both Copilot CLI and coding agent policies must be enabled for `/delegate` command usage / 使用 `/delegate` 命令需同时启用 Copilot CLI 和编码 Agent 策略
- **Audit Logging / 审计日志**: Policy updates are recorded in enterprise audit logs / 策略更新记录在企业审计日志中
- **Seat Assignment / 席位分配**: Users require an active GitHub Copilot seat / 用户需要有效的 GitHub Copilot 席位

## Controls That Don't Apply / 不适用的控制项

All other controls do **not** affect Copilot CLI, including MCP server policies, IDE-specific configurations, and file path-based exclusions.

所有其他控制项均**不**影响 Copilot CLI，包括 MCP 服务器策略、IDE 特定配置和基于文件路径的排除规则。

## Troubleshooting Access Issues / 访问问题排查

If users lack expected access:

如果用户缺少预期访问权限：

1. Verify they have a valid GitHub Copilot seat assignment / 验证用户是否拥有有效的 GitHub Copilot 席位
2. Check enterprise-level policy settings / 检查企业级策略设置
3. If set to "Let organizations decide," ensure at least one granting organization has enabled it / 若设置为"由组织决定"，确保至少一个授权组织已启用该功能

Setting policy to "Enabled everywhere" ensures consistent access across organizations.

将策略设置为"所有地方均启用"可确保跨组织的一致访问。
