# Quickstart for Automating with GitHub Copilot CLI / GitHub Copilot CLI 自动化快速入门

## Overview / 概述

GitHub Copilot CLI enables programmatic execution of Copilot prompts through two primary approaches: direct terminal commands or integrated scripts and automations.

GitHub Copilot CLI 支持通过两种主要方式以编程方式执行 Copilot 提示词：直接终端命令或集成脚本和自动化。

## Running Prompts from the Command Line / 从命令行运行提示词

To execute a prompt without launching an interactive session, use the `-p` flag:

要在不启动交互式会话的情况下执行提示词，请使用 `-p` 标志：

```shell
copilot -p "Summarize what this file does: ./README.md"
```

This method accepts any prompt compatible with interactive mode.

此方式接受任何与交互模式兼容的提示词。

## Scripting with Copilot CLI / 使用 Copilot CLI 编写脚本

Scripts unlock the ability to automate AI-powered workflows. Within scripts, you can dynamically generate prompts, incorporate variable content, and capture or chain outputs.

脚本能够自动化 AI 驱动的工作流。在脚本中，你可以动态生成提示词、合并变量内容，以及捕获或链式处理输出。

### Example: Large File Analysis Automation / 示例：大文件分析自动化

The following bash script demonstrates finding files exceeding 10 MB, generating descriptions via Copilot CLI, and sending an email summary:

以下 bash 脚本演示了查找超过 10 MB 的文件、通过 Copilot CLI 生成描述并发送电子邮件摘要：

```bash
#!/bin/bash
# Find files over 10 MB, use Copilot CLI to describe them, and email a summary
# 查找超过 10 MB 的文件，使用 Copilot CLI 描述它们，并发送电子邮件摘要

EMAIL_TO="user@example.com"
SUBJECT="Large file found"
BODY=""

while IFS= read -r -d '' file; do
    size=$(du -h "$file" | cut -f1)
    description=$(copilot -p "Describe this file briefly: $file" -s 2>/dev/null)
    BODY+="File: $file"$'\n'"Size: $size"$'\n'"Description: $description"$'\n\n'
done < <(find . -type f -size +10M -print0)

if [ -z "$BODY" ]; then
    echo "No files over 10MB found."
    exit 0
fi

echo -e "To: $EMAIL_TO\nSubject: $SUBJECT\n\n$BODY" | sendmail "$EMAIL_TO"
echo "Email sent to $EMAIL_TO with large file details."
```

### Setup Instructions / 设置说明

1. Create `find_large_files.sh` with the script content above / 使用上述脚本内容创建 `find_large_files.sh`
2. Make it executable: `chmod +x find_large_files.sh` / 设为可执行：`chmod +x find_large_files.sh`
3. Run it: `./find_large_files.sh` / 运行：`./find_large_files.sh`

Scripts can be triggered automatically by directory events, scheduled via cron, or integrated into CI/CD pipelines.

脚本可以由目录事件自动触发、通过 cron 定时调度，或集成到 CI/CD 管道中。

## Additional Resources / 其他资源

- [Running GitHub Copilot CLI programmatically / 以编程方式运行](run-cli-programmatically.md)
- [Automating tasks with Copilot CLI and GitHub Actions / 与 GitHub Actions 集成](automate-with-actions.md)
