# Quickstart for Automating with GitHub Copilot CLI

## Overview

GitHub Copilot CLI enables programmatic execution of Copilot prompts through two primary approaches: direct terminal commands or integrated scripts and automations.

## Running Prompts from the Command Line

To execute a prompt without launching an interactive session, use the `-p` flag:

```shell
copilot -p "Summarize what this file does: ./README.md"
```

This method accepts any prompt compatible with interactive mode.

## Scripting with Copilot CLI

Scripts unlock the ability to automate AI-powered workflows. Within scripts, you can dynamically generate prompts, incorporate variable content, and capture or chain outputs.

### Example: Large File Analysis Automation

The following bash script demonstrates finding files exceeding 10 MB, generating descriptions via Copilot CLI, and sending an email summary:

```bash
#!/bin/bash
# Find files over 10 MB, use Copilot CLI to describe them, and email a summary

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

### Setup Instructions

1. Create `find_large_files.sh` with the script content above
2. Make it executable: `chmod +x find_large_files.sh`
3. Run it: `./find_large_files.sh`

Scripts can be triggered automatically by directory events, scheduled via cron, or integrated into CI/CD pipelines.

## Additional Resources

- [Running GitHub Copilot CLI programmatically](run-cli-programmatically.md)
- [Automating tasks with Copilot CLI and GitHub Actions](automate-with-actions.md)
