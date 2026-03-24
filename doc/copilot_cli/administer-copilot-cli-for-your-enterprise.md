# Administering Copilot CLI for Your Enterprise

## Overview

Enterprise owners can manage Copilot CLI usage through policy configuration. The process involves accessing enterprise settings and selecting preferred policies for the tool.

## Enabling or Disabling Copilot CLI

To configure Copilot CLI policies:

1. Navigate to your enterprise on GitHub.com
2. Click the **AI controls** option at the top
3. Select **Copilot** from the sidebar
4. In the "Copilot Clients" section, choose your desired policy for Copilot CLI

## Enterprise Controls That Apply to Copilot CLI

Several enterprise-level policies directly affect Copilot CLI:

- **Enablement**: Control access at enterprise or organization level
- **Model Selection**: Available models reflect enterprise-level choices; users can check options via `/model` command
- **Custom Agents**: Enterprise-configured agents are accessible within Copilot CLI
- **Coding Agent Access**: Both Copilot CLI and coding agent policies must be enabled for `/delegate` command usage
- **Audit Logging**: Policy updates are recorded in enterprise audit logs
- **Seat Assignment**: Users require an active GitHub Copilot seat

## Controls That Don't Apply

All other controls do **not** affect Copilot CLI, including MCP server policies, IDE-specific configurations, and file path-based exclusions.

## Troubleshooting Access Issues

If users lack expected access:

1. Verify they have a valid GitHub Copilot seat assignment
2. Check enterprise-level policy settings
3. If set to "Let organizations decide," ensure at least one granting organization has enabled it

Setting policy to "Enabled everywhere" ensures consistent access across organizations.
