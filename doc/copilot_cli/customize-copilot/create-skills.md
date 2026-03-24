# Creating Agent Skills for GitHub Copilot CLI

Agent skills are customizable folders containing instructions, scripts, and resources that enhance Copilot's performance on specialized tasks.

## Setting Up Skills

To establish a skill, create a `SKILL.md` file along with any supporting resources in designated directories:

**Project skills** (repository-specific): `.github/skills` or `.claude/skills`

**Personal skills** (multi-project): `~/.copilot/skills` or `~/.claude/skills`

Each skill requires its own subdirectory with a lowercase, hyphenated name.

## SKILL.md File Structure

The `SKILL.md` file combines YAML frontmatter with Markdown content:

**Required frontmatter:**
- **name**: Lowercase identifier matching the directory name (letters, numbers, hyphens; max 64 chars)
- **description**: Explains the skill's purpose and activation triggers (max 1024 chars)

**Optional frontmatter:**
- **allowed-tools**: Auto-allowed tools on activation
- **user-invocable**: Enable `/SKILL-NAME` invocation (default: true)
- **disable-model-invocation**: Prevent agent auto-invocation (default: false)
- **license**: Licensing information

**Markdown body:** Instructions, examples, and guidelines for Copilot

## Skill Locations (Priority Order)

| Location | Scope | Description |
|----------|-------|-------------|
| `.github/skills/` | Project | Project-specific |
| `.agents/skills/` | Project | Alternative project location |
| `.claude/skills/` | Project | Claude-compatible |
| Parent `.github/skills/` | Inherited | Monorepo support |
| `~/.copilot/skills/` | Personal | All projects |
| `~/.claude/skills/` | Personal | Claude-compatible |
| Plugin directories | Plugin | Plugin skills |
| `COPILOT_SKILLS_DIRS` | Custom | Custom directories |

## Example Implementation

A GitHub Actions debugging skill located in `.github/skills/github-actions-failure-debugging/` with `SKILL.md`:

```markdown
---
name: github-actions-failure-debugging
description: Debug failing GitHub Actions workflows
allowed-tools: shell(gh:*)
---

Use the `list_workflow_runs` tool to look up recent workflow runs.
Summarize failures before accessing full logs.
```

## Accessing Skills

Copilot automatically selects relevant skills based on your prompt. You can explicitly invoke a skill by prefixing its name with a forward slash (e.g., `/frontend-design`).

**Available CLI commands:**
- `/skills list` – View available skills
- `/skills` – Toggle skills on/off
- `/skills info` – Get skill details and locations
- `/skills add` – Register alternative skill locations
- `/skills reload` – Refresh skills mid-session
- `/skills remove SKILL-DIRECTORY` – Delete custom skills

## Skills vs. Custom Instructions

Use custom instructions for broad coding standards applicable project-wide. Reserve skills for detailed, task-specific guidance that Copilot should access selectively.

## Alternative: Commands Format

Commands stored as `.md` files in `.claude/commands/` use simplified format (no `name` field required). Command name derives from filename. Lower priority than skills with same name. Support `description`, `allowed-tools`, and `disable-model-invocation` fields.
