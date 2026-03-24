# Creating a Plugin Marketplace for GitHub Copilot CLI

## Overview

A plugin marketplace serves as a registry where Copilot CLI plugins can be discovered and installed. These marketplaces can be hosted on GitHub.com, alternative Git services, or local file systems.

## Key Requirements

Before establishing a marketplace, you must have created one or more plugins that you want to share.

## Setup Steps

### 1. Create marketplace.json

The core component is a `marketplace.json` file containing marketplace metadata and plugin listings. This file enables Copilot CLI to recognize your repository as a marketplace.

Structure includes:
- Marketplace name and owner information
- Metadata with description and version
- A `plugins` array listing available plugins with names, descriptions, versions, and source paths

### 2. File Placement

Place `marketplace.json` in the `.github/plugin` directory (alternatively: `.claude-plugin/`).

### 3. Directory Organization

Store plugin directories at locations specified in the `source` field. Paths are relative to the repository root and don't require `./` prefix.

### 4. User Access

Share your repository and provide installation instructions. Users add the marketplace using:

```shell
copilot plugin marketplace add OWNER/REPO
```

## Reference Materials

For implementation guidance, refer to the working examples in the `github/copilot-plugins` and `github/awesome-copilot` repositories.
