# Adding Custom Instructions for GitHub Copilot CLI

## Overview

GitHub Copilot can deliver tailored responses when given contextual information about your project. Rather than repeatedly including this context in prompts, you can create custom instructions that automatically supplement your requests with relevant details.

## Four Types of Custom Instructions

**Repository-wide instructions** apply to all requests within a repository and are stored in `.github/copilot-instructions.md`.

**Path-specific instructions** target files matching specified patterns and are placed in `.github/instructions/NAME.instructions.md` files using glob syntax for file matching.

**Agent instructions** are utilized by AI agents and can be defined in `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md` files. Primary instructions in the repository root have greater impact than additional instructions found elsewhere.

**Local instructions** apply within your personal environment via `$HOME/.copilot/copilot-instructions.md` or through the `COPILOT_CUSTOM_INSTRUCTIONS_DIRS` environment variable.

## Instruction File Locations

| Location | Scope |
|----------|-------|
| `~/.copilot/copilot-instructions.md` | All sessions (global) |
| `.github/copilot-instructions.md` | Repository-wide |
| `.github/instructions/**/*.instructions.md` | Repository (path-specific) |
| `AGENTS.md` (in Git root or cwd) | Repository (agent instructions) |

Repository instructions take precedence over global instructions.

## Creating Repository-Wide Instructions

1. Create `.github/copilot-instructions.md` at your repository root
2. Write instructions in natural language Markdown format
3. Formatting (spacing, line breaks) doesn't affect functionality

## Creating Path-Specific Instructions

1. Create the `.github/instructions` directory
2. Add `NAME.instructions.md` files within it
3. Include frontmatter with glob patterns:
   ```yaml
   ---
   applyTo: "**/*.ts,**/*.tsx"
   ---
   ```
4. Optionally exclude specific agents using `excludeAgent: "code-review"`
5. Write instructions in Markdown format

## Implementation Notes

Instructions become available to Copilot immediately upon saving. Changes made during a session take effect on your next prompt submission. When both repository-wide and path-specific instructions exist, both are used—avoid conflicting directives as Copilot's resolution behavior is unpredictable.
