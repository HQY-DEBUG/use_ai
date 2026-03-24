# Steering Agents in GitHub Copilot CLI

## Overview

The GitHub Copilot CLI allows you to guide the AI agent during task execution, ensuring it remains aligned with your intentions and objectives.

## Real-Time Interaction While Processing

You can engage with Copilot while it's actively working. The platform supports sending follow-up messages to redirect the conversation or add additional instructions that Copilot will address once completing its current task.

## Key Benefits of Steering

This feature enables you to:

* Stop an agent moving toward an incorrect solution
* Give immediate feedback when declining tool permission requests
* Modify or clarify the task requirements mid-execution

## How to Steer

- **Press Esc**: Cancel the current operation if you detect Copilot is heading in the wrong direction.
- **Decline tool requests**: When Copilot asks for tool approval, select "No" and provide inline feedback about what you want done differently. Copilot will adapt its approach without stopping entirely.
- **Send follow-up messages**: While Copilot is processing, you can type follow-up instructions that will be addressed after the current step completes.

## Further Reading

- [Requesting a code review with GitHub Copilot CLI](agentic-code-review.md)
- [Delegating tasks to GitHub Copilot CLI](delegate-tasks-to-cca.md)
