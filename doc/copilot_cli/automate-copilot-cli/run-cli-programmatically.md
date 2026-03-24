# Running GitHub Copilot CLI Programmatically

## Overview

The GitHub Copilot CLI enables programmatic execution through direct prompts, eliminating the need for interactive sessions. This functionality supports terminal usage, scripting, CI/CD pipelines, and automation workflows.

## Command Syntax

Two methods exist for programmatic invocation:

**Option 1: Direct prompt parameter**
```shell
copilot -p "Explain this file: ./complex.ts"
```

**Option 2: Piped input**
```shell
echo "Explain this file: ./complex.ts" | copilot
```

*Note: Piped input is disregarded when `-p` or `--prompt` is also specified.*

## Best Practices for Programmatic Usage

When implementing Copilot CLI programmatically, follow these guidelines:

- **Precise prompts**: Clear, unambiguous instructions produce better results than vague requests.
- **Quote handling**: Use single quotes to prevent shell interpretation of special characters
- **Minimal permissions**: Restrict access via `--allow-tool` and `--allow-url` flags; avoid overly permissive settings outside sandboxes
- **Silent mode**: Apply `-s` flag to suppress metadata and obtain clean output
- **User interaction control**: Use `--no-ask-user` to prevent clarification requests
- **Model consistency**: Explicitly set models with `--model` for uniform behavior across environments

## GitHub Actions Integration

Copilot CLI integrates into CI/CD workflows. Example workflow step:

```yaml
- name: Generate test coverage report
  env:
    COPILOT_GITHUB_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
  run: |
    copilot -p "Run the test suite and produce a coverage summary" \
      -s --allow-tool='shell(npm:*), write' --no-ask-user
```

## Practical Examples

### Generate Commit Messages
```bash
copilot -p 'Write a commit message in plain text for the staged changes' -s \
  --allow-tool='shell(git:*)'
```

### Summarize Files
```bash
copilot -p 'Summarize what src/auth/login.ts does in no more than 100 words' -s
```

### Write Unit Tests
```bash
copilot -p 'Write unit tests for src/utils/validators.ts' \
  --allow-tool='write, shell(npm:*), shell(npx:*)'
```

### Resolve Linting Issues
```bash
copilot -p 'Fix all ESLint errors in this project' \
  --allow-tool='write, shell(npm:*), shell(npx:*), shell(git:*)'
```

### Analyze Code Changes
```bash
copilot -p 'Explain the changes in the latest commit on this branch and flag any potential issues' -s
```

### Conduct Code Reviews
```bash
copilot -p '/review the changes on this branch compared to main. Focus on bugs and security issues.' \
  -s --allow-tool='shell(git:*)'
```

### Generate Documentation
```bash
copilot -p 'Generate JSDoc comments for all exported functions in src/api/' \
  --allow-tool=write
```

### Export Sessions
Save locally:
```bash
copilot -p "Audit this project's dependencies for vulnerabilities" \
  --allow-tool='shell(npm:*), shell(npx:*)' \
  --share='./audit-report.md'
```

Save to GitHub gist:
```bash
copilot -p 'Summarize the architecture of this project' --share-gist
```

## Shell Scripting Patterns

### Capture Output
```bash
result=$(copilot -p 'What version of Node.js does this project require? \
  Give the number only. No other text.' -s)
echo "Required Node version: $result"
```

### Conditional Logic
```bash
if copilot -p 'Does this project have any TypeScript errors? Reply only YES or NO.' -s \
  | grep -qi "no"; then
  echo "No type errors found."
else
  echo "Type errors detected."
fi
```

### Batch Processing
```bash
for file in src/api/*.ts; do
  echo "--- Reviewing $file ---" | tee -a review-results.md
  copilot -p "Review $file for error handling issues" -s --allow-all-tools | tee -a review-results.md
done
```
