# GitHub Copilot CLI Session Data Management

## Overview

GitHub Copilot CLI maintains local session data enabling users to resume previous work, access session history insights, and ask questions about their CLI usage patterns.

## Key Capabilities

The session data feature allows developers to:

- **Resume interrupted work** from previous CLI sessions
- **Generate insights** using the `/chronicle` command for standup reports and personalized recommendations
- **Query session history** through natural language questions about past interactions

## Resuming Sessions

Three methods exist for returning to previous work:

1. Command line: Use `copilot --continue` for the most recent session, or `copilot --resume` to choose from a list
2. Direct resumption: Run `copilot --resume SESSION-ID` with a known session identifier
3. Active session: Type `/resume` to switch sessions mid-workflow

## Session Management

**Renaming sessions** helps with organization. Use `/rename NEW_NAME` to label sessions for easier identification in picker lists.

**Sharing sessions** preserves work records through:
- `/share gist` — exports to a private GitHub gist
- `/share file [PATH]` — saves as Markdown (defaults to current directory)

## Chronicle Command Features

The `/chronicle` slash command (requiring experimental mode) offers targeted insights:

| Function | Purpose |
|----------|---------|
| `standup` | Generate a short report based on your Copilot CLI sessions |
| `tips` | Analyzes usage patterns for 3–5 personalized recommendations |
| `improve` | Examines friction points to suggest `.github/copilot-instructions.md` updates |
| `reindex` | Rebuilds the session store index |

Example usage:
```shell
/chronicle standup
/chronicle tips
```

## Natural Language Queries

Users can ask freeform questions about their session history, such as:
- Productivity patterns
- Cost optimization strategies
- Task success rates
- Previous work on specific topics
