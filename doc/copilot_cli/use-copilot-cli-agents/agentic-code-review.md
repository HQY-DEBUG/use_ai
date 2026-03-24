# Requesting a Code Review with GitHub Copilot CLI

GitHub Copilot CLI offers an agentic code review feature through the terminal, enabling developers to obtain feedback on code modifications without leaving their command-line environment.

## How Agentic Code Review Works

The process involves three main steps:

### Step 1: Initiate the Review

Enter the `/review` command with optional parameters to focus the analysis. You can specify a custom prompt, file path, or pattern to limit the review's scope, then press Enter to begin.

```shell
/review
```

Or with a focused prompt:
```shell
/review Focus on security vulnerabilities in the authentication module
```

### Step 2: Respond to Proposed Commands

Copilot may suggest running commands to examine diffs or validate files. Use arrow keys to navigate between "Yes" and "No" options. Selecting Yes executes the command; selecting No allows you to redirect Copilot's approach.

### Step 3: Apply Recommendations

Once Copilot completes its analysis, review the feedback provided and implement any suggested enhancements directly in your code editor.

## Related Resources

- [Automating tasks with Copilot CLI and GitHub Actions](../automate-copilot-cli/automate-with-actions.md)
- [Adding custom instructions for GitHub Copilot CLI](../customize-copilot/add-custom-instructions.md)
