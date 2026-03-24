# Authenticating GitHub Copilot CLI / GitHub Copilot CLI 身份验证

Authenticate Copilot CLI so that you can use Copilot directly from the command line.

对 Copilot CLI 进行身份验证，以便直接从命令行使用 Copilot。

## About authentication / 关于身份验证

GitHub Copilot CLI supports three authentication methods. The method you use depends on whether you are working interactively or in an automated environment.

GitHub Copilot CLI 支持三种身份验证方式，具体选择取决于你是在交互式环境还是自动化环境中工作。

* **OAuth device flow / OAuth 设备流**: The default and recommended method for interactive use. When you run `/login` in Copilot CLI, the CLI generates a one-time code and directs you to authenticate in your browser. / 交互式使用的默认推荐方式。在 Copilot CLI 中运行 `/login` 时，CLI 会生成一次性验证码并引导你在浏览器中完成身份验证。
* **Environment variables / 环境变量**: Recommended for CI/CD pipelines, containers, and non-interactive environments. You set a supported token as an environment variable (`COPILOT_GITHUB_TOKEN`, `GH_TOKEN`, or `GITHUB_TOKEN`), and the CLI uses it automatically without prompting. / 推荐用于 CI/CD 管道、容器和非交互式环境。将支持的令牌设置为环境变量，CLI 会自动使用，无需提示。
* **GitHub CLI fallback / GitHub CLI 回退**: If you have GitHub CLI installed and authenticated, Copilot CLI can use its token automatically. This is the lowest priority method. / 如果已安装并验证 GitHub CLI，Copilot CLI 可自动使用其令牌。这是优先级最低的方式。

Once authenticated, Copilot CLI remembers your login and automatically uses the token for all Copilot API requests.

身份验证完成后，Copilot CLI 会记住你的登录信息，并自动将令牌用于所有 Copilot API 请求。

### Supported token types / 支持的令牌类型

| Token type / 令牌类型 | Prefix / 前缀 | Supported / 支持 | Notes / 说明 |
| --- | --- | --- | --- |
| OAuth token (device flow) / OAuth 令牌（设备流） | `gho_` | Yes / 是 | Default method via `copilot login` / 通过 `copilot login` 的默认方式 |
| Fine-grained PAT / 细粒度 PAT | `github_pat_` | Yes / 是 | Must include **Copilot Requests** permission / 必须包含 **Copilot Requests** 权限 |
| GitHub App user-to-server / GitHub App 用户到服务器 | `ghu_` | Yes / 是 | Via environment variable / 通过环境变量 |
| Classic PAT / 经典 PAT | `ghp_` | No / 否 | Not supported / 不支持 |

### How Copilot CLI stores credentials / 凭据存储方式

By default, the CLI stores your OAuth token in your operating system's keychain under the service name `copilot-cli`:

默认情况下，CLI 将 OAuth 令牌存储在操作系统密钥链中，服务名称为 `copilot-cli`：

| Platform / 平台 | Keychain / 密钥链 |
| --- | --- |
| macOS | Keychain Access |
| Windows | Credential Manager |
| Linux | libsecret (GNOME Keyring, KWallet) |

If the system keychain is unavailable, the CLI prompts you to store the token in a plaintext configuration file at `~/.copilot/config.json`.

如果系统密钥链不可用，CLI 会提示你将令牌存储在 `~/.copilot/config.json` 的纯文本配置文件中。

When you run a command, Copilot CLI checks for credentials in the following order:

运行命令时，Copilot CLI 按以下顺序查找凭据：

1. `COPILOT_GITHUB_TOKEN` environment variable / 环境变量
2. `GH_TOKEN` environment variable / 环境变量
3. `GITHUB_TOKEN` environment variable / 环境变量
4. OAuth token from the system keychain / 系统密钥链中的 OAuth 令牌
5. GitHub CLI (`gh auth token`) fallback / GitHub CLI 回退

> An environment variable silently overrides a stored OAuth token. To avoid unexpected behavior, unset environment variables you do not intend the CLI to use.
>
> 环境变量会静默覆盖存储的 OAuth 令牌。为避免意外行为，请取消设置不希望 CLI 使用的环境变量。

## Authenticating with OAuth / 使用 OAuth 进行身份验证

### Authenticate with `/login`

1. From Copilot CLI, run `/login`. / 在 Copilot CLI 中运行 `/login`。

2. Select the account you want to authenticate with. / 选择要验证的账号。

3. The CLI displays a one-time user code and automatically copies it to your clipboard and opens your browser. / CLI 会显示一次性验证码，并自动复制到剪贴板并打开浏览器。

4. Navigate to `https://github.com/login/device` if your browser did not open automatically. / 如果浏览器未自动打开，请访问 `https://github.com/login/device`。

5. Paste the one-time code in the field on the page. / 在页面字段中粘贴一次性验证码。

6. If your organization uses SAML SSO, click **Authorize** next to each organization. / 如果组织使用 SAML SSO，点击每个组织旁边的 **Authorize**。

7. Review the requested permissions and click **Authorize GitHub Copilot CLI**. / 审查请求的权限并点击 **Authorize GitHub Copilot CLI**。

8. Return to your terminal. The CLI displays a success message when authentication is complete. / 返回终端，身份验证完成后 CLI 会显示成功消息。

### Authenticate with `copilot login`

1. From the terminal, run: / 从终端运行：

   ```bash
   copilot login
   ```

   For GitHub Enterprise Cloud: / 对于 GitHub Enterprise Cloud：

   ```bash
   copilot login --host HOSTNAME
   ```

2. Follow the same steps as the `/login` method above. / 按照上面 `/login` 方式的相同步骤操作。

## Authenticating with environment variables / 使用环境变量进行身份验证

For non-interactive environments, you can authenticate by setting an environment variable with a supported token.

对于非交互式环境，可以通过设置带有支持令牌的环境变量进行身份验证。

1. Visit [Fine-grained personal access tokens](https://github.com/settings/personal-access-tokens/new). / 访问细粒度个人访问令牌页面。
2. Under "Permissions," click **Add permissions** and select **Copilot Requests**. / 在"Permissions"下，点击 **Add permissions** 并选择 **Copilot Requests**。
3. Click **Generate token**. / 点击 **Generate token**。
4. Export the token using the `COPILOT_GITHUB_TOKEN`, `GH_TOKEN`, or `GITHUB_TOKEN` environment variable. / 使用环境变量导出令牌。

## Authenticating with GitHub CLI / 使用 GitHub CLI 进行身份验证

If you have GitHub CLI installed and authenticated, Copilot CLI can use its token as a fallback.

如果已安装并验证 GitHub CLI，Copilot CLI 可将其令牌作为回退方式使用。

1. Verify that GitHub CLI is authenticated: / 验证 GitHub CLI 是否已通过身份验证：

   ```bash
   gh auth status
   ```

2. Run `copilot`. The Copilot CLI uses the GitHub CLI token automatically. / 运行 `copilot`，Copilot CLI 自动使用 GitHub CLI 令牌。

3. Run `/user` to verify your authenticated account in the CLI. / 运行 `/user` 验证 CLI 中已验证的账号。

## Switching between accounts / 切换账号

- To list available accounts: `/user list` / 列出可用账号
- To switch to a different account: `/user switch` / 切换到其他账号
- To add another account: run `copilot login` from a new terminal session. / 添加其他账号：在新终端会话中运行 `copilot login`

## Signing out and removing credentials / 注销和删除凭据

To sign out, type `/logout` at the Copilot CLI prompt. This removes the locally stored token but does not revoke it on GitHub.

要注销，在 Copilot CLI 提示符处输入 `/logout`。这会删除本地存储的令牌，但不会在 GitHub 上撤销它。

To revoke the OAuth app authorization on GitHub / 在 GitHub 上撤销 OAuth 应用授权：

1. In the upper-right corner of any page on GitHub, click your profile picture. / 在 GitHub 任意页面右上角点击头像。
2. Click **Settings**. / 点击 **Settings**。
3. In the left sidebar, click **Applications**. / 在左侧边栏点击 **Applications**。
4. Under **Authorized OAuth Apps**, click the horizontal kebab menu icon next to **GitHub CLI** and select **Revoke**. / 在 **Authorized OAuth Apps** 下，点击 **GitHub CLI** 旁边的菜单图标并选择 **Revoke**。
