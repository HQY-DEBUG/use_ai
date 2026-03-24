# Best Practices for GitHub Copilot CLI

## Overview

GitHub Copilot CLI is a terminal-based AI assistant bringing autonomous capabilities directly to your command line. Rather than functioning solely as a chatbot, its primary strength lies in operating as an independent coding partner that can handle delegated tasks while you maintain oversight.

## 1. Customize Your Environment

### Custom Instructions Files

Copilot CLI automatically reads instructions from multiple locations, enabling organization-wide standards and repository-specific conventions:

| Location | Scope |
|----------|-------|
| `~/.copilot/copilot-instructions.md` | All sessions (global) |
| `.github/copilot-instructions.md` | Repository |
| `.github/instructions/**/*.instructions.md` | Repository (modular) |
| `AGENTS.md` (in Git root or cwd) | Repository |
| `Copilot.md`, `GEMINI.md`, `CODEX.md` | Repository |

**Best Practice:** "Keep instructions concise and actionable. Lengthy instructions can dilute effectiveness."

Repository instructions take precedence over global instructions, allowing teams to enforce specific conventions.

### Configure Allowed Tools

Control which tools Copilot can execute without requesting permission:

```bash
copilot --allow-tool='shell(git:*)' --deny-tool='shell(git push)'
```

Reset previously approved tools with `/reset-allowed-tools`.

Common patterns include:
- `shell(git:*)` — All Git commands
- `shell(npm run:*)` — All npm scripts
- `shell(npm run test:*)` — npm test commands
- `write` — File writes

### Select Your Preferred Model

| Model | Best For | Tradeoffs |
|-------|----------|-----------|
| **Claude Opus 4.5** (default) | Complex architecture, difficult debugging, nuanced refactoring | Most capable; uses more premium requests |
| **Claude Sonnet 4.5** | Day-to-day coding, routine tasks | Fast, cost-effective |
| **GPT-5.2 Codex** | Code generation, code review, straightforward implementations | Excellent for reviewing other models' code |

Use `/model` to switch models during your session.

## 2. Plan Before You Code

### Plan Mode

"Models achieve higher success rates when given a concrete plan to follow." In plan mode, Copilot creates a structured implementation plan before writing code.

Toggle plan mode with **Shift+Tab**, or use `/plan` from normal mode:

```
/plan Add OAuth2 authentication with Google and GitHub providers
```

The system will:
- Analyze your request and codebase
- Ask clarifying questions
- Create a structured implementation plan with checkboxes
- Save the plan to `plan.md` in your session folder
- Await your approval before implementing

Edit the plan with **Ctrl+y**.

### When to Use Plan Mode

| Scenario | Recommended |
|----------|-------------|
| Complex multi-file changes | ✓ Yes |
| Refactoring with many touch points | ✓ Yes |
| New feature implementation | ✓ Yes |
| Quick bug fixes | ✗ No |
| Single file changes | ✗ No |

### Recommended Workflow

For complex tasks, follow this pattern:
1. **Explore**: Read relevant files without writing code
2. **Plan**: Use `/plan` to outline the approach
3. **Review**: Check and suggest modifications to the plan
4. **Implement**: Proceed with implementation
5. **Verify**: Run tests and fix failures
6. **Commit**: Use descriptive commit messages

## 3. Leverage Infinite Sessions

### Automatic Context Window Management

Copilot CLI features infinite sessions with automatic context management through intelligent compaction that summarizes conversation history while maintaining essential information.

Session storage location:
```
~/.copilot/session-state/{session-id}/
├── events.jsonl      # Full session history
├── workspace.yaml    # Metadata
├── plan.md           # Implementation plan (if created)
├── checkpoints/      # Compaction history
└── files/            # Persistent artifacts
```

Manually trigger compaction with `/compact` if needed (rarely necessary).

### Session Management Commands

- `/session` — View current CLI session information
- `/session checkpoints` — View list of session checkpoints
- `/session checkpoints NUMBER` — View details of a specific checkpoint
- `/session files` — View temporary files created during session
- `/session plan` — View the current plan if generated

### Best Practice: Keep Sessions Focused

"While infinite sessions allow long-running work, focused sessions produce better results." Use `/clear` or `/new` between unrelated tasks to reset context and improve response quality.

Visualize context usage with `/context`, which shows:
- System/tools tokens
- Message history tokens
- Available free space
- Buffer allocation

## 4. Delegate Work Effectively

### The `/delegate` Command

Offload work to the cloud using Copilot coding agent for:
- Asynchronous tasks
- Changes to other repositories
- Long-running operations

```
/delegate Add dark mode support to the settings page
```

The agent creates a pull request with changes while you continue local work.

### When to Use `/delegate`

| Use `/delegate` | Work Locally |
|-----------------|-------------|
| Tangential tasks | Core feature work |
| Documentation updates | Debugging |
| Refactoring separate modules | Interactive exploration |

## 5. Common Workflows

### Codebase Onboarding

Use Copilot as a pair programming partner when joining new projects:
- "How is logging configured in this project?"
- "What's the pattern for adding a new API endpoint?"
- "Explain the authentication flow"
- "Where are the database migrations?"

### Test-Driven Development

Partner with Copilot to develop tests:
1. Request failing tests for a specific flow
2. Review and approve the tests
3. Ask Copilot to implement code making tests pass
4. Review the implementation
5. Commit with conventional commit message

### Code Review Assistance

```
/review Use Opus 4.5 and Codex 5.2 to review changes in my current branch
against `main`. Focus on potential bugs and security issues.
```

### Git Operations

Copilot excels at Git workflows:
- "What changes went into version `2.3.0`?"
- "Create a PR for this branch with a detailed description"
- "Rebase this branch against `main`"
- "Resolve the merge conflicts in `package.json`"

### Bug Investigation

```
The `/api/users` endpoint returns 500 errors intermittently. Search
the codebase and logs to identify the root cause.
```

### Refactoring

```
/plan Migrate all class components to functional components with hooks
```

## 6. Advanced Patterns

### Work Across Multiple Repositories

#### Option 1: Run from Parent Directory

```bash
cd ~/projects
copilot
```

Copilot accesses all child repositories simultaneously—ideal for microservices and coordinated changes.

#### Option 2: Use `/add-dir` to Expand Access

```
/add-dir /Users/me/projects/backend-service
/add-dir /Users/me/projects/shared-libs
/add-dir /Users/me/projects/documentation
```

View allowed directories with `/list-dirs`.

Example multi-repository prompt:
```
I need to update the user authentication API spanning:
- @/Users/me/projects/api-gateway (routing changes)
- @/Users/me/projects/auth-service (core logic)
- @/Users/me/projects/frontend (client updates)

Start by showing the current auth flow across all three repos.
```

### Using Images for UI Work

Drag and drop images directly into CLI input or reference files:
```
Implement this design: @mockup.png
Match the layout and spacing exactly
```

### Checklists for Complex Migrations

```
Run the linter and write all errors to `migration-checklist.md`
as a checklist. Then fix each issue one by one, checking them off.
```

### Autonomous Task Completion

Switch into autopilot mode for long-running tasks not requiring constant supervision. Use `/fleet` at the start of your prompt to break tasks into parallel subtasks run by subagents.

## 7. Team Guidelines

### Recommended Repository Setup

Create `.github/copilot-instructions.md` containing:
- Build and test commands
- Code style guidelines
- Required checks before commits
- Architecture decisions

Establish conventions for:
- When to use `/plan` (complex features, refactoring)
- When to use `/delegate` (tangential work)
- Code review processes with AI assistance

### Security Considerations

- Copilot CLI requires explicit approval for destructive operations
- Review all proposed changes before accepting
- Use permission allowlists judiciously
- Verify commits never contain secrets

### Measuring Productivity

Track metrics including:
- Time from issue to pull request
- Number of iterations before merge
- Code review feedback cycles
- Test coverage improvements

## Getting Help

Display help from the command line:
```bash
copilot -h
copilot help TOPIC
```

Where `TOPIC` can be: `config`, `commands`, `environment`, `logging`, or `permissions`.

Within the CLI:
- `/help` — Display help
- `/usage` — View usage statistics
- `/feedback` — Submit feedback, bug reports, or feature requests

## Further Resources

- [Using GitHub Copilot CLI](use-copilot-cli-agents/overview.md)
- [GitHub Copilot CLI command reference](reference/cli-command-reference.md)
