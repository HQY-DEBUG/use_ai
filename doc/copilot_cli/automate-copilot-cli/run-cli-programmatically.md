# Running GitHub Copilot CLI Programmatically / 以编程方式运行 GitHub Copilot CLI

## Overview / 概述

The GitHub Copilot CLI enables programmatic execution through direct prompts, eliminating the need for interactive sessions. This functionality supports terminal usage, scripting, CI/CD pipelines, and automation workflows.

GitHub Copilot CLI 支持通过直接提示词以编程方式执行，无需交互式会话。此功能支持终端使用、脚本编写、CI/CD 管道和自动化工作流。

## Command Syntax / 命令语法

Two methods exist for programmatic invocation:

以编程方式调用有两种方式：

**Option 1: Direct prompt parameter / 方式一：直接提示词参数**
```shell
copilot -p "Explain this file: ./complex.ts"
```

**Option 2: Piped input / 方式二：管道输入**
```shell
echo "Explain this file: ./complex.ts" | copilot
```

*Note: Piped input is disregarded when `-p` or `--prompt` is also specified. / 注意：同时指定 `-p` 或 `--prompt` 时，管道输入将被忽略。*

## Best Practices for Programmatic Usage / 编程使用最佳实践

When implementing Copilot CLI programmatically, follow these guidelines:

以编程方式使用 Copilot CLI 时，遵循以下准则：

- **Precise prompts / 精确提示词**: Clear, unambiguous instructions produce better results. / 清晰、无歧义的指令能产生更好的结果。
- **Quote handling / 引号处理**: Use single quotes to prevent shell interpretation of special characters. / 使用单引号防止 shell 解释特殊字符。
- **Minimal permissions / 最小权限**: Restrict access via `--allow-tool` and `--allow-url` flags. / 通过 `--allow-tool` 和 `--allow-url` 标志限制访问。
- **Silent mode / 静默模式**: Apply `-s` flag to suppress metadata and obtain clean output. / 使用 `-s` 标志抑制元数据，获取纯净输出。
- **User interaction control / 用户交互控制**: Use `--no-ask-user` to prevent clarification requests. / 使用 `--no-ask-user` 阻止澄清请求。
- **Model consistency / 模型一致性**: Explicitly set models with `--model` for uniform behavior. / 使用 `--model` 明确设置模型以确保一致性。

## GitHub Actions Integration / GitHub Actions 集成

```yaml
- name: Generate test coverage report
  env:
    COPILOT_GITHUB_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
  run: |
    copilot -p "Run the test suite and produce a coverage summary" \
      -s --allow-tool='shell(npm:*), write' --no-ask-user
```

## Practical Examples / 实际示例

### Generate Commit Messages / 生成提交信息
```bash
copilot -p 'Write a commit message in plain text for the staged changes' -s \
  --allow-tool='shell(git:*)'
```

### Summarize Files / 汇总文件
```bash
copilot -p 'Summarize what src/auth/login.ts does in no more than 100 words' -s
```

### Write Unit Tests / 编写单元测试
```bash
copilot -p 'Write unit tests for src/utils/validators.ts' \
  --allow-tool='write, shell(npm:*), shell(npx:*)'
```

### Resolve Linting Issues / 解决代码规范问题
```bash
copilot -p 'Fix all ESLint errors in this project' \
  --allow-tool='write, shell(npm:*), shell(npx:*), shell(git:*)'
```

### Analyze Code Changes / 分析代码变更
```bash
copilot -p 'Explain the changes in the latest commit on this branch and flag any potential issues' -s
```

### Conduct Code Reviews / 进行代码审查
```bash
copilot -p '/review the changes on this branch compared to main. Focus on bugs and security issues.' \
  -s --allow-tool='shell(git:*)'
```

### Generate Documentation / 生成文档
```bash
copilot -p 'Generate JSDoc comments for all exported functions in src/api/' \
  --allow-tool=write
```

### Export Sessions / 导出会话
Save locally / 本地保存：
```bash
copilot -p "Audit this project's dependencies for vulnerabilities" \
  --allow-tool='shell(npm:*), shell(npx:*)' \
  --share='./audit-report.md'
```

Save to GitHub gist / 保存到 GitHub gist：
```bash
copilot -p 'Summarize the architecture of this project' --share-gist
```

## Shell Scripting Patterns / Shell 脚本模式

### Capture Output / 捕获输出
```bash
result=$(copilot -p 'What version of Node.js does this project require? \
  Give the number only. No other text.' -s)
echo "Required Node version: $result"
```

### Conditional Logic / 条件逻辑
```bash
if copilot -p 'Does this project have any TypeScript errors? Reply only YES or NO.' -s \
  | grep -qi "no"; then
  echo "No type errors found."
else
  echo "Type errors detected."
fi
```

### Batch Processing / 批量处理
```bash
for file in src/api/*.ts; do
  echo "--- Reviewing $file ---" | tee -a review-results.md
  copilot -p "Review $file for error handling issues" -s --allow-all-tools | tee -a review-results.md
done
```
