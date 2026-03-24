# 高级设置

> 文件：`setup.md`  版本：v1.0  日期：2026-03-24

> Claude Code 的系统要求、特定平台安装、版本管理和卸载。

本页面涵盖系统要求、特定平台安装详情、更新和卸载。有关首次会话的引导式演练，请参阅快速入门。

---

## 系统要求

Claude Code 在以下平台和配置上运行：

**操作系统：**
- macOS 13.0+
- Windows 10 1809+ 或 Windows Server 2019+
- Ubuntu 20.04+
- Debian 10+
- Alpine Linux 3.19+

**硬件：** 4 GB+ RAM

**网络：** 需要互联网连接。

**Shell：** Bash、Zsh、PowerShell 或 CMD。在 Windows 上，需要 [Git for Windows](https://git-scm.com/downloads/win)。

**位置：** Anthropic 支持的国家/地区

### 其他依赖项

- **ripgrep**：通常包含在 Claude Code 中。如果搜索失败，请参阅搜索故障排除。

---

## 安装 Claude Code

**macOS / Linux / WSL：**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows PowerShell：**

```powershell
irm https://claude.ai/install.ps1 | iex
```

**Windows CMD：**

```batch
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

Windows 需要先安装 [Git for Windows](https://git-scm.com/downloads/win)。

> 原生安装会在后台自动更新，保持最新版本。

**Homebrew：**

```bash
brew install --cask claude-code
```

> Homebrew 安装不会自动更新，请定期运行 `brew upgrade claude-code`。

**WinGet：**

```powershell
winget install Anthropic.ClaudeCode
```

> WinGet 安装不会自动更新，请定期运行 `winget upgrade Anthropic.ClaudeCode`。

安装完成后，在您要使用的项目中打开终端并启动 Claude Code：

```bash
claude
```

---

## 在 Windows 上设置

Windows 上的 Claude Code 需要 [Git for Windows](https://git-scm.com/downloads/win) 或 WSL。您可以从 PowerShell、CMD 或 Git Bash 启动 `claude`。Claude Code 在内部使用 Git Bash 来运行命令。您无需以管理员身份运行 PowerShell。

**选项 1：使用 Git Bash 的原生 Windows**

安装 [Git for Windows](https://git-scm.com/downloads/win)，然后从 PowerShell 或 CMD 运行安装命令。

如果 Claude Code 找不到您的 Git Bash 安装，请在您的 settings.json 文件中设置路径：

```json
{
  "env": {
    "CLAUDE_CODE_GIT_BASH_PATH": "C:\\Program Files\\Git\\bin\\bash.exe"
  }
}
```

**选项 2：WSL**

支持 WSL 1 和 WSL 2。WSL 2 支持沙箱以增强安全性。WSL 1 不支持沙箱。

---

## Alpine Linux 和基于 musl 的发行版

Alpine 和其他基于 musl/uClibc 的发行版上的原生安装程序需要 `libgcc`、`libstdc++` 和 `ripgrep`。使用您的发行版的包管理器安装这些，然后设置 `USE_BUILTIN_RIPGREP=0`。

在 Alpine 上安装所需的包：

```bash
apk add libgcc libstdc++ ripgrep
```

然后在您的 `settings.json` 文件中将 `USE_BUILTIN_RIPGREP` 设置为 `0`：

```json
{
  "env": {
    "USE_BUILTIN_RIPGREP": "0"
  }
}
```

---

## 验证您的安装

安装后，确认 Claude Code 正常工作：

```bash
claude --version
```

要更详细地检查您的安装和配置，请运行：

```bash
claude doctor
```

---

## 身份验证

Claude Code 需要 Pro、Max、Teams、Enterprise 或 Console 账户。免费的 Claude.ai 计划不包括 Claude Code 访问权限。您也可以通过第三方 API 提供商（如 Amazon Bedrock、Google Vertex AI 或 Microsoft Foundry）使用 Claude Code。

安装后，通过运行 `claude` 并按照浏览器提示登录。

---

## 更新 Claude Code

原生安装会在后台自动更新。您可以配置发布渠道来控制您是立即接收更新还是按延迟的稳定计划接收更新，或者完全禁用自动更新。Homebrew 和 WinGet 安装需要手动更新。

### 自动更新

Claude Code 在启动时和运行时定期检查更新。更新在后台下载和安装，然后在您下次启动 Claude Code 时生效。

> Homebrew 和 WinGet 安装不会自动更新。使用 `brew upgrade claude-code` 或 `winget upgrade Anthropic.ClaudeCode` 手动更新。
>
> Homebrew 在升级后会在磁盘上保留旧版本。定期运行 `brew cleanup claude-code` 以回收磁盘空间。

### 配置发布渠道

使用 `autoUpdatesChannel` 设置控制 Claude Code 为自动更新和 `claude update` 遵循的发布渠道：

- `"latest"`，默认值：在新功能发布后立即接收
- `"stable"`：使用通常约一周前的版本，跳过有重大回归的发布

通过 `/config` → **自动更新渠道**配置此项，或将其添加到您的 settings.json 文件：

```json
{
  "autoUpdatesChannel": "stable"
}
```

对于企业部署，您可以使用托管设置在整个组织中强制执行一致的发布渠道。

### 禁用自动更新

在您的 `settings.json` 文件的 `env` 键中将 `DISABLE_AUTOUPDATER` 设置为 `"1"`：

```json
{
  "env": {
    "DISABLE_AUTOUPDATER": "1"
  }
}
```

### 手动更新

要立即应用更新而不等待下一次后台检查，请运行：

```bash
claude update
```

---

## 高级安装选项

### 安装特定版本

原生安装程序接受特定版本号或发布渠道（`latest` 或 `stable`）。

安装最新版本（默认）：

```bash
# macOS / Linux / WSL
curl -fsSL https://claude.ai/install.sh | bash

# Windows PowerShell
irm https://claude.ai/install.ps1 | iex
```

安装稳定版本：

```bash
# macOS / Linux / WSL
curl -fsSL https://claude.ai/install.sh | bash -s stable

# Windows PowerShell
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) stable
```

安装特定版本号：

```bash
# macOS / Linux / WSL
curl -fsSL https://claude.ai/install.sh | bash -s 1.0.58

# Windows PowerShell
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) 1.0.58
```

### 已弃用的 npm 安装

npm 安装已弃用。原生安装程序更快，不需要依赖项，并在后台自动更新。尽可能使用原生安装方法。

#### 从 npm 迁移到原生

如果您之前使用 npm 安装了 Claude Code，请切换到原生安装程序：

```bash
# 安装原生二进制文件
curl -fsSL https://claude.ai/install.sh | bash

# 删除旧的 npm 安装
npm uninstall -g @anthropic-ai/claude-code
```

#### 使用 npm 安装（兼容性需要）

如果您因兼容性原因需要 npm 安装，您必须安装 [Node.js 18+](https://nodejs.org/en/download)。全局安装该包：

```bash
npm install -g @anthropic-ai/claude-code
```

> 不要使用 `sudo npm install -g`，因为这可能导致权限问题和安全风险。

### 二进制完整性和代码签名

您可以使用 SHA256 校验和和代码签名来验证 Claude Code 二进制文件的完整性。

- 所有平台的 SHA256 校验和发布在 `https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/{VERSION}/manifest.json` 的发布清单中。将 `{VERSION}` 替换为版本号，例如 `2.0.30`。
- 签名的二进制文件分发用于以下平台：
  - **macOS**：由"Anthropic PBC"签名并由 Apple 公证
  - **Windows**：由"Anthropic, PBC"签名

---

## 卸载 Claude Code

### 原生安装

**macOS / Linux / WSL：**

```bash
rm -f ~/.local/bin/claude
rm -rf ~/.local/share/claude
```

**Windows PowerShell：**

```powershell
Remove-Item -Path "$env:USERPROFILE\.local\bin\claude.exe" -Force
Remove-Item -Path "$env:USERPROFILE\.local\share\claude" -Recurse -Force
```

### Homebrew 安装

```bash
brew uninstall --cask claude-code
```

### WinGet 安装

```powershell
winget uninstall Anthropic.ClaudeCode
```

### npm

```bash
npm uninstall -g @anthropic-ai/claude-code
```

### 删除配置文件

> 警告：删除配置文件将删除您的所有设置、允许的工具、MCP 服务器配置和会话历史记录。

**macOS / Linux / WSL：**

```bash
# 删除用户设置和状态
rm -rf ~/.claude
rm ~/.claude.json

# 删除特定于项目的设置（从您的项目目录运行）
rm -rf .claude
rm -f .mcp.json
```

**Windows PowerShell：**

```powershell
# 删除用户设置和状态
Remove-Item -Path "$env:USERPROFILE\.claude" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\.claude.json" -Force

# 删除特定于项目的设置（从您的项目目录运行）
Remove-Item -Path ".claude" -Recurse -Force
Remove-Item -Path ".mcp.json" -Force
```
