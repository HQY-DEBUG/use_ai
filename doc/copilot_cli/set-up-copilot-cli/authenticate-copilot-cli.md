# Authenticating GitHub Copilot CLI

Authenticate Copilot CLI so that you can use Copilot directly from the command line.

## About authentication

GitHub Copilot CLI supports three authentication methods. The method you use depends on whether you are working interactively or in an automated environment.

* **OAuth device flow**: The default and recommended method for interactive use. When you run `/login` in Copilot CLI, the CLI generates a one-time code and directs you to authenticate in your browser.
* **Environment variables**: Recommended for CI/CD pipelines, containers, and non-interactive environments. You set a supported token as an environment variable (`COPILOT_GITHUB_TOKEN`, `GH_TOKEN`, or `GITHUB_TOKEN`), and the CLI uses it automatically without prompting.
* **GitHub CLI fallback**: If you have GitHub CLI installed and authenticated, Copilot CLI can use its token automatically. This is the lowest priority method and activates only when no other credentials are found.

Once authenticated, Copilot CLI remembers your login and automatically uses the token for all Copilot API requests. You can log in with multiple accounts, and the CLI will remember the last-used account.

### Supported token types

| Token type                | Prefix        | Supported | Notes                                                  |
| ------------------------- | ------------- | --------- | ------------------------------------------------------ |
| OAuth token (device flow) | `gho_`        | Yes       | Default method via `copilot login`                     |
| Fine-grained PAT          | `github_pat_` | Yes       | Must include required permissions **Copilot Requests** |
| GitHub App user-to-server | `ghu_`        | Yes       | Via environment variable                               |
| Classic PAT               | `ghp_`        | No        | Not supported by Copilot CLI                           |

### How Copilot CLI stores credentials

By default, the CLI stores your OAuth token in your operating system's keychain under the service name `copilot-cli`:

| Platform | Keychain                           |
| -------- | ---------------------------------- |
| macOS    | Keychain Access                    |
| Windows  | Credential Manager                 |
| Linux    | libsecret (GNOME Keyring, KWallet) |

If the system keychain is unavailable, the CLI prompts you to store the token in a plaintext configuration file at `~/.copilot/config.json`.

When you run a command, Copilot CLI checks for credentials in the following order:

1. `COPILOT_GITHUB_TOKEN` environment variable
2. `GH_TOKEN` environment variable
3. `GITHUB_TOKEN` environment variable
4. OAuth token from the system keychain
5. GitHub CLI (`gh auth token`) fallback

> An environment variable silently overrides a stored OAuth token. If you set `GH_TOKEN` for another tool, the CLI uses that token instead of the OAuth token from `copilot login`. To avoid unexpected behavior, unset environment variables you do not intend the CLI to use.

## Authenticating with OAuth

### Authenticate with `/login`

1. From Copilot CLI, run `/login`.

2. Select the account you want to authenticate with. For GitHub Enterprise Cloud with data residency, enter the hostname of your instance:

   ```text
   What account do you want to log into?
    1. GitHub.com
    2. GitHub Enterprise Cloud with data residency (*.ghe.com)
   ```

3. The CLI displays a one-time user code and automatically copies it to your clipboard and opens your browser.

4. Navigate to the verification URL at `https://github.com/login/device` if your browser did not open automatically.

5. Paste the one-time code in the field on the page.

6. If your organization uses SAML SSO, click **Authorize** next to each organization you want to grant access to.

7. Review the requested permissions and click **Authorize GitHub Copilot CLI**.

8. Return to your terminal. The CLI displays a success message when authentication is complete.

### Authenticate with `copilot login`

1. From the terminal, run:

   ```bash
   copilot login
   ```

   For GitHub Enterprise Cloud:

   ```bash
   copilot login --host HOSTNAME
   ```

2. Navigate to the verification URL at `https://github.com/login/device` if your browser did not open automatically.

3. Paste the one-time code in the field on the page.

4. If your organization uses SAML SSO, click **Authorize** next to each organization you want to grant access to.

5. Review the requested permissions and click **Authorize GitHub Copilot CLI**.

6. Return to your terminal. The CLI displays a success message when authentication is complete.

## Authenticating with environment variables

For non-interactive environments, you can authenticate by setting an environment variable with a supported token. This is ideal for CI/CD pipelines, containers, or headless servers.

1. Visit [Fine-grained personal access tokens](https://github.com/settings/personal-access-tokens/new).
2. Under "Permissions," click **Add permissions** and select **Copilot Requests**.
3. Click **Generate token**.
4. Export the token in your terminal or environment configuration. Use the `COPILOT_GITHUB_TOKEN`, `GH_TOKEN`, or `GITHUB_TOKEN` environment variable (in order of precedence).

## Authenticating with GitHub CLI

If you have GitHub CLI installed and authenticated, Copilot CLI can use its token as a fallback. This method has the lowest priority and activates only when no environment variables are set and no stored token is found.

1. Verify that GitHub CLI is authenticated:

   ```bash
   gh auth status
   ```

2. Run `copilot`. The Copilot CLI uses the GitHub CLI token automatically.

3. Run `/user` to verify your authenticated account in the CLI.

## Switching between accounts

Copilot CLI supports multiple accounts.

- To list available accounts: `/user list`
- To switch to a different account: `/user switch`
- To add another account: run `copilot login` from a new terminal session, or run the login command from within the CLI.

## Signing out and removing credentials

To sign out, type `/logout` at the Copilot CLI prompt. This removes the locally stored token but does not revoke it on GitHub.

To revoke the OAuth app authorization on GitHub:

1. In the upper-right corner of any page on GitHub, click your profile picture.
2. Click **Settings**.
3. In the left sidebar, click **Applications**.
4. Under **Authorized OAuth Apps**, click the horizontal kebab menu icon next to **GitHub CLI** and select **Revoke**.
