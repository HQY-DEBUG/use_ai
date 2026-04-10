# 故障排除

> 发现 Claude Code 安装和使用中常见问题的解决方案。

## 故障排除安装问题

> 如果您想完全跳过终端，[Claude Code 桌面应用](/zh-CN/desktop-quickstart)让您可以通过图形界面安装和使用 Claude Code。

找到您看到的错误消息或症状：

| 您看到的内容                                                     | 解决方案                                                              |
| :--------------------------------------------------------- | :---------------------------------------------------------------- |
| `command not found: claude` 或 `'claude' is not recognized` | 修复您的 PATH                                                         |
| `syntax error near unexpected token '<'`                   | 安装脚本返回 HTML                                                       |
| `curl: (56) Failure writing output to destination`         | 先下载脚本，然后运行                                                        |
| Linux 上安装期间 `Killed`                                       | 为低内存服务器添加交换空间                                                     |
| `TLS connect error` 或 `SSL/TLS secure channel`             | 更新 CA 证书                                                          |
| `Failed to fetch version` 或无法访问下载服务器                       | 检查网络和代理设置                                                         |
| `irm is not recognized` 或 `&& is not valid`                | 为您的 shell 使用正确的命令                                                  |
| `Claude Code on Windows requires git-bash`                 | 安装或配置 Git Bash                                                    |
| `Error loading shared library`                             | 您的系统安装了错误的二进制变体                                                   |
| Linux 上的 `Illegal instruction`                             | 架构不匹配                                                             |
| macOS 上的 `dyld: cannot load` 或 `Abort trap`                | 二进制不兼容                                                            |
| `Invoke-Expression: Missing argument in parameter list`    | 安装脚本返回 HTML                                                       |
| `App unavailable in region`                                | Claude Code 在您的国家/地区不可用                                           |
| `unable to get local issuer certificate`                   | 配置企业 CA 证书                                                        |
| `OAuth error` 或 `403 Forbidden`                            | 修复身份验证                                                            |

## 调试安装问题

### 检查网络连接

安装程序从 `storage.googleapis.com` 下载。验证您可以访问它：

```bash
curl -sI https://storage.googleapis.com
```

如果失败，您的网络可能阻止了连接。常见原因：

* 企业防火墙或代理阻止 Google Cloud Storage
* 区域网络限制：尝试使用 VPN 或替代网络
* TLS/SSL 问题：更新您系统的 CA 证书，或检查是否配置了 `HTTPS_PROXY`

如果您在企业代理后面，在安装前设置代理环境变量：

```bash
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
curl -fsSL https://claude.ai/install.sh | bash
```

### 验证您的 PATH

如果安装成功但运行 `claude` 时出现 `command not found` 错误，则安装目录不在您的 PATH 中。安装程序在 macOS/Linux 上将 `claude` 放在 `~/.local/bin/claude`，或在 Windows 上放在 `%USERPROFILE%\.local\bin\claude.exe`。

**macOS/Linux：**

```bash
echo $PATH | tr ':' '\n' | grep local/bin
```

如果没有输出，将其添加到您的 shell 配置：

```bash
# Zsh (macOS 默认)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Bash (Linux 默认)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Windows PowerShell：**

```powershell
$env:PATH -split ';' | Select-String 'local\\bin'
```

如果没有输出，将安装目录添加到您的用户 PATH：

```powershell
$currentPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
[Environment]::SetEnvironmentVariable('PATH', "$currentPath;$env:USERPROFILE\.local\bin", 'User')
```

### 检查冲突的安装

多个 Claude Code 安装可能导致版本不匹配或意外行为。

**macOS/Linux：**

```bash
which -a claude
ls -la ~/.local/bin/claude
ls -la ~/.claude/local/
npm -g ls @anthropic-ai/claude-code 2>/dev/null
```

如果您找到多个安装，只保留一个。建议使用 `~/.local/bin/claude` 处的本机安装。

卸载 npm 全局安装：

```bash
npm uninstall -g @anthropic-ai/claude-code
```

在 macOS 上删除 Homebrew 安装：

```bash
brew uninstall --cask claude-code
```

### 检查目录权限

安装程序需要对 `~/.local/bin/` 和 `~/.claude/` 的写入权限：

```bash
test -w ~/.local/bin && echo "writable" || echo "not writable"
test -w ~/.claude && echo "writable" || echo "not writable"
```

如果任一目录不可写：

```bash
sudo mkdir -p ~/.local/bin
sudo chown -R $(whoami) ~/.local
```

### 验证二进制文件是否有效

确认二进制文件存在且可执行：

```bash
ls -la $(which claude)
```

在 Linux 上，检查缺失的共享库：

```bash
ldd $(which claude) | grep "not found"
```

运行快速健全性检查：

```bash
claude --version
```

## 常见安装问题

### 安装脚本返回 HTML 而不是 shell 脚本

运行安装命令时，您可能会看到以下错误：

```text
bash: line 1: syntax error near unexpected token `<'
bash: line 1: `<!DOCTYPE html>'
```

在 PowerShell 上：

```text
Invoke-Expression: Missing argument in parameter list.
```

如果 HTML 页面显示"App unavailable in region"，Claude Code 在您的国家/地区不可用。

**解决方案：**

在 macOS 或 Linux 上，通过 Homebrew 安装：

```bash
brew install --cask claude-code
```

在 Windows 上，通过 WinGet 安装：

```powershell
winget install Anthropic.ClaudeCode
```

### 安装后 `command not found: claude`

| 平台          | 错误消息                                                                   |
| :---------- | :--------------------------------------------------------------------- |
| macOS       | `zsh: command not found: claude`                                       |
| Linux       | `bash: claude: command not found`                                      |
| Windows CMD | `'claude' is not recognized as an internal or external command`        |
| PowerShell  | `claude : The term 'claude' is not recognized as the name of a cmdlet` |

这意味着安装目录不在您的 shell 搜索路径中。请参阅上方的"验证您的 PATH"。

### `curl: (56) Failure writing output to destination`

下载在完成前中断。

**解决方案：**

测试您是否可以访问下载服务器：

```bash
curl -fsSL https://storage.googleapis.com -o /dev/null
```

如果命令无声地完成，问题可能是间歇性的，直接重试安装命令。否则使用替代安装方法：

```bash
brew install --cask claude-code  # macOS/Linux
winget install Anthropic.ClaudeCode  # Windows
```

### TLS 或 SSL 连接错误

**解决方案：**

1. 更新系统 CA 证书：

   ```bash
   # Ubuntu/Debian
   sudo apt-get update && sudo apt-get install ca-certificates

   # macOS
   brew install ca-certificates
   ```

2. 在 Windows PowerShell 中启用 TLS 1.2：

   ```powershell
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   irm https://claude.ai/install.ps1 | iex
   ```

3. 企业代理 CA 证书问题，设置 `NODE_EXTRA_CA_CERTS`：

   ```bash
   export NODE_EXTRA_CA_CERTS=/path/to/corporate-ca.pem
   ```

### `Failed to fetch version from storage.googleapis.com`

直接测试连接：

```bash
curl -sI https://storage.googleapis.com
```

如果在代理后面，设置 `HTTPS_PROXY`：

```bash
export HTTPS_PROXY=http://proxy.example.com:8080
curl -fsSL https://claude.ai/install.sh | bash
```

### Windows：`irm` 或 `&&` 未被识别

* **`irm` 未被识别**：您在 CMD 中，而不是 PowerShell。在 CMD 中改用：

  ```batch
  curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
  ```

* **`&&` 无效**：您在 PowerShell 中，应使用：

  ```powershell
  irm https://claude.ai/install.ps1 | iex
  ```

### 低内存 Linux 服务器上安装被杀死

Linux OOM 杀手终止了该进程，因为系统内存不足。Claude Code 需要至少 4 GB 的可用 RAM。

**解决方案：**

添加 2 GB 交换空间：

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

然后重试安装：

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

### Docker 中安装挂起

在 Docker 容器中，以 root 身份安装到 `/` 可能导致挂起。在运行安装程序前设置工作目录：

```dockerfile
WORKDIR /tmp
RUN curl -fsSL https://claude.ai/install.sh | bash
```

或增加 Docker 内存限制：

```bash
docker build --memory=4g .
```

### Windows："Claude Code on Windows requires git-bash"

Windows 上的 Claude Code 需要 [Git for Windows](https://git-scm.com/downloads/win)。

**如果未安装 Git**，从 [git-scm.com/downloads/win](https://git-scm.com/downloads/win) 下载并安装。

**如果已安装 Git** 但找不到，在 [settings.json 文件](/zh-CN/settings)中设置路径：

```json
{
  "env": {
    "CLAUDE_CODE_GIT_BASH_PATH": "C:\\Program Files\\Git\\bin\\bash.exe"
  }
}
```

### Linux：安装了错误的二进制变体（musl/glibc 不匹配）

如果看到关于缺失共享库的错误：

```text
Error loading shared library libstdc++.so.6: No such file or directory
```

检查您的系统使用哪个 libc：

```bash
ldd /bin/ls | head -1
```

如果您在 Alpine Linux（musl）上，安装所需的包：

```bash
apk add libgcc libstdc++ ripgrep
```

### Linux 上的 `Illegal instruction`

验证您的架构：

```bash
uname -m
```

`x86_64` 表示 64 位 Intel/AMD，`aarch64` 表示 ARM64。如果二进制文件不匹配，[提交 GitHub 问题](https://github.com/anthropics/claude-code/issues)。

### macOS 上的 `dyld: cannot load`

检查您的 macOS 版本。Claude Code 需要 macOS 13.0 或更高版本。

尝试 Homebrew 作为替代安装方法：

```bash
brew install --cask claude-code
```

### Windows 安装问题：WSL 中的错误

**OS/平台检测问题**：如果在安装期间收到错误：

```bash
npm config set os linux
npm install -g @anthropic-ai/claude-code --force --no-os-check
```

**Node 未找到错误**：如果运行 `claude` 时看到 `exec: node: not found`，您的 WSL 环境可能使用 Windows 安装的 Node.js。使用 `which npm` 和 `which node` 确认。路径应指向以 `/usr/` 开头的 Linux 路径。通过 Linux 发行版的包管理器或 [nvm](https://github.com/nvm-sh/nvm) 安装 Node。

**nvm 版本冲突**：确保 nvm 在您的 shell 中正确加载，将以下内容添加到 `~/.bashrc` 或 `~/.zshrc`：

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

### WSL2 sandbox 设置

如果运行 `/sandbox` 时看到错误，安装依赖项：

```bash
# Ubuntu/Debian
sudo apt-get install bubblewrap socat

# Fedora
sudo dnf install bubblewrap socat
```

WSL1 不支持 sandboxing。

## 权限和身份验证

### 重复的权限提示

如果您发现自己反复批准相同的命令，您可以使用 `/permissions` 命令允许特定工具无需批准即可运行。

### 身份验证问题

如果您遇到身份验证问题：

1. 运行 `/logout` 完全注销
2. 关闭 Claude Code
3. 使用 `claude` 重新启动并再次完成身份验证过程

如果浏览器在登录期间不自动打开，按 `c` 将 OAuth URL 复制到您的剪贴板，然后手动将其粘贴到您的浏览器中。

### OAuth 错误：无效代码

如果您看到 `OAuth error: Invalid code. Please make sure the full code was copied`：

* 按 Enter 重试，并在浏览器打开后快速完成登录
* 如果浏览器不自动打开，输入 `c` 复制完整 URL
* 如果使用远程/SSH 会话，复制终端中显示的 URL 并在您的本地浏览器中打开它

### 登录后 403 Forbidden

如果登录后看到 403 错误：

* **Claude Pro/Max 用户**：在 [claude.ai/settings](https://claude.ai/settings) 验证您的订阅是否有效
* **Console 用户**：确认您的账户已由管理员分配"Claude Code"或"Developer"角色
* **在代理后面**：企业代理可能干扰 API 请求。检查代理设置。

### OAuth 登录在 WSL2 中失败

设置 `BROWSER` 环境变量：

```bash
export BROWSER="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
claude
```

或当登录提示出现时，按 `c` 复制 OAuth URL，然后将其粘贴到您的 Windows 浏览器中。

### "未登录"或令牌已过期

运行 `/login` 重新进行身份验证。如果这种情况经常发生，请检查您的系统时钟是否准确。

## 配置文件位置

Claude Code 在多个位置存储配置：

| 文件                            | 目的                                   |
| :---------------------------- | :----------------------------------- |
| `~/.claude/settings.json`     | 用户设置（权限、hooks、模型覆盖）                  |
| `.claude/settings.json`       | 项目设置（检入源代码控制）                        |
| `.claude/settings.local.json` | 本地项目设置（未提交）                          |
| `~/.claude.json`              | 全局状态（主题、OAuth、MCP 服务器）               |
| `.mcp.json`                   | 项目 MCP 服务器（检入源代码控制）                  |
| `managed-mcp.json`            | 托管 MCP 服务器                           |
| 托管设置                          | 服务器管理、MDM/OS 级别策略或基于文件               |

在 Windows 上，`~` 指您的用户主目录，例如 `C:\Users\YourName`。

### 重置配置

要将 Claude Code 重置为默认设置，可以删除配置文件：

```bash
# 重置所有用户设置和状态
rm ~/.claude.json
rm -rf ~/.claude/

# 重置项目特定设置
rm -rf .claude/
rm .mcp.json
```

> 这将删除您的所有设置、MCP 服务器配置和会话历史记录。

## 性能和稳定性

### 高 CPU 或内存使用

如果您遇到性能问题：

1. 定期使用 `/compact` 以减少上下文大小
2. 在主要任务之间关闭并重启 Claude Code
3. 考虑将大型构建目录添加到您的 `.gitignore` 文件

### 命令挂起或冻结

如果 Claude Code 似乎无响应：

1. 按 Ctrl+C 尝试取消当前操作
2. 如果无响应，您可能需要关闭终端并重新启动

### 搜索和发现问题

如果搜索工具、`@file` 提及、自定义代理和自定义 skills 不起作用，请安装系统 `ripgrep`：

```bash
# macOS (Homebrew)
brew install ripgrep

# Windows (winget)
winget install BurntSushi.ripgrep.MSVC

# Ubuntu/Debian
sudo apt install ripgrep

# Alpine Linux
apk add ripgrep

# Arch Linux
pacman -S ripgrep
```

然后在您的环境中设置 `USE_BUILTIN_RIPGREP=0`。

### WSL 上的搜索速度缓慢或结果不完整

在 WSL 上跨文件系统工作时的磁盘读取性能损失可能导致搜索结果少于预期。

**解决方案：**

1. **提交更具体的搜索**：指定目录或文件类型。
2. **将项目移到 Linux 文件系统**：确保项目位于 `/home/` 而不是 `/mnt/c/`。
3. **改用本机 Windows**：在 Windows 上本机运行 Claude Code 以获得更好的文件系统性能。

## IDE 集成问题

### JetBrains IDE 在 WSL2 上未被检测到

如果收到"No available IDEs detected"错误，这可能是由于 WSL2 的网络配置或 Windows 防火墙阻止连接。

**选项 1：配置 Windows 防火墙**

1. 找到您的 WSL2 IP 地址：
   ```bash
   wsl hostname -I
   # 示例输出：172.21.123.45
   ```

2. 以管理员身份打开 PowerShell 并创建防火墙规则：
   ```powershell
   New-NetFirewallRule -DisplayName "Allow WSL2 Internal Traffic" -Direction Inbound -Protocol TCP -Action Allow -RemoteAddress 172.21.0.0/16 -LocalAddress 172.21.0.0/16
   ```

3. 重启您的 IDE 和 Claude Code

**选项 2：切换到镜像网络**

在您的 Windows 用户目录中添加到 `.wslconfig`：

```ini
[wsl2]
networkingMode=mirrored
```

然后从 PowerShell 使用 `wsl --shutdown` 重启 WSL。

### JetBrains IDE 终端中的 Escape 键不起作用

要修复此问题：

1. 转到设置 → 工具 → 终端
2. 取消选中"Move focus to the editor with Escape"，或删除"Switch focus to Editor"快捷键

## Markdown 格式问题

### 代码块中缺少语言标签

如果在生成的 markdown 中注意到代码块缺少语言标签：

1. **要求 Claude 添加语言标签**：请求"Add appropriate language tags to all code blocks in this markdown file."
2. **使用后处理 hooks**：设置自动格式化 hooks 以检测和添加缺失的语言标签。
3. **手动验证**：生成 markdown 文件后，查看它们以确保正确的代码块格式。

### 减少 markdown 格式问题

* **在请求中明确**：要求"properly formatted markdown with language-tagged code blocks"
* **使用项目约定**：在 `CLAUDE.md` 中记录您首选的 markdown 风格
* **设置验证 hooks**：使用后处理 hooks 自动验证和修复常见格式问题

## 获取更多帮助

如果您遇到此处未涵盖的问题：

1. 在 Claude Code 中使用 `/bug` 命令直接向 Anthropic 报告问题
2. 检查 [GitHub 存储库](https://github.com/anthropics/claude-code) 以了解已知问题
3. 运行 `/doctor` 以诊断问题。它检查：
   * 安装类型、版本和搜索功能
   * 自动更新状态和可用版本
   * 无效的设置文件（格式错误的 JSON、不正确的类型）
   * MCP 服务器配置错误
   * 快捷键配置问题
   * 上下文使用警告
   * 插件和代理加载错误
4. 直接向 Claude 询问其功能和特性
