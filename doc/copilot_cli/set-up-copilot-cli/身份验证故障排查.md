# GitHub Copilot CLI Authentication Troubleshooting / GitHub Copilot CLI 身份验证故障排查

This guide helps diagnose and resolve authentication failures when signing into Copilot CLI.

本指南帮助诊断和解决登录 Copilot CLI 时的身份验证失败问题。

## Common Authentication Issues / 常见身份验证问题

The documentation outlines six primary authentication problems:

以下是六种主要的身份验证问题：

1. **Missing credentials / 缺少凭据** — Resolved by running `copilot login` / 运行 `copilot login` 解决
2. **Expired or revoked tokens / 令牌过期或被撤销** — Requires regenerating a token with proper permissions / 需要重新生成具有适当权限的令牌
3. **Classic token rejection / 经典令牌被拒绝** — Classic tokens (starting with `ghp_`) aren't supported; use fine-grained alternatives / 不支持经典令牌（以 `ghp_` 开头），请使用细粒度替代方案
4. **Access restrictions / 访问限制** — Caused by licensing or organizational policy / 由许可证或组织策略导致
5. **Keychain problems / 密钥链问题** — System credential storage unavailable / 系统凭据存储不可用
6. **Wrong account / 账号错误** — Multiple accounts or environment variable conflicts / 多账号或环境变量冲突

## Key Diagnostic Steps / 关键诊断步骤

To troubleshoot, start by checking authentication status with `gh auth status`. Next, verify whether environment variables like `COPILOT_GITHUB_TOKEN`, `GH_TOKEN`, or `GITHUB_TOKEN` are configured. On macOS, examine the keychain using `security find-generic-password -s copilot-cli`.

排查时，首先使用 `gh auth status` 检查身份验证状态，然后验证是否配置了 `COPILOT_GITHUB_TOKEN`、`GH_TOKEN` 或 `GITHUB_TOKEN` 等环境变量。在 macOS 上，使用 `security find-generic-password -s copilot-cli` 检查密钥链。

## Required Token Permissions / 所需令牌权限

Any token must possess the **Copilot Requests** permission. Classic personal access tokens are not supported by Copilot CLI.

任何令牌都必须具有 **Copilot Requests** 权限。Copilot CLI 不支持经典个人访问令牌。

## Resolution Paths / 解决方案

- Regenerate tokens if expired or lacking permissions / 如果令牌过期或缺少权限，重新生成令牌
- Enable Copilot CLI through organizational policy settings / 通过组织策略设置启用 Copilot CLI
- Install `libsecret` on Linux systems for secure credential storage / 在 Linux 系统上安装 `libsecret` 以安全存储凭据
- Use `/user switch` to change authenticated accounts / 使用 `/user switch` 切换已验证的账号
