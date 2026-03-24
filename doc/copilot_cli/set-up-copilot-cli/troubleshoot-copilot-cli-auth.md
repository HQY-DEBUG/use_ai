# GitHub Copilot CLI Authentication Troubleshooting

This guide helps diagnose and resolve authentication failures when signing into Copilot CLI.

## Common Authentication Issues

The documentation outlines six primary authentication problems:

1. **Missing credentials** — Resolved by running `copilot login`
2. **Expired or revoked tokens** — Requires regenerating a token with proper permissions
3. **Classic token rejection** — Classic tokens (starting with `ghp_`) aren't supported; use fine-grained alternatives
4. **Access restrictions** — Caused by licensing or organizational policy
5. **Keychain problems** — System credential storage unavailable
6. **Wrong account** — Multiple accounts or environment variable conflicts

## Key Diagnostic Steps

To troubleshoot, start by checking authentication status with `gh auth status`. Next, verify whether environment variables like `COPILOT_GITHUB_TOKEN`, `GH_TOKEN`, or `GITHUB_TOKEN` are configured. On macOS, examine the keychain using `security find-generic-password -s copilot-cli`.

## Required Token Permissions

Any token must possess the **Copilot Requests** permission. Classic personal access tokens are not supported by Copilot CLI.

## Resolution Paths

- Regenerate tokens if expired or lacking permissions
- Enable Copilot CLI through organizational policy settings
- Install `libsecret` on Linux systems for secure credential storage
- Use `/user switch` to change authenticated accounts
