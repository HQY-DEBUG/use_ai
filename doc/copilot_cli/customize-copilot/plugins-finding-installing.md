# Finding and Installing Plugins for GitHub Copilot CLI

## Overview

Plugins are packages that extend the functionality of Copilot CLI. You can obtain them from registered marketplaces, Git repositories, or local directories. Copilot comes with two default marketplaces: `copilot-plugins` and `awesome-copilot`.

## Discovering Plugins

### List Registered Marketplaces

Check available marketplaces using:
```shell
copilot plugin marketplace list
```

Or in an interactive session:
```
/plugin marketplace list
```

### Browse Marketplace Contents

To explore plugins in a specific marketplace:
```shell
copilot plugin marketplace browse MARKETPLACE-NAME
```

## Installation Methods

### From a Registered Marketplace

```shell
copilot plugin install PLUGIN-NAME@MARKETPLACE-NAME
```

Example: `copilot plugin install database-data-management@awesome-copilot`

### From GitHub Repositories

For GitHub.com repos:
```shell
copilot plugin install OWNER/REPO
```

For any Git repository:
```shell
copilot plugin install URL-OF-GIT-REPO
```

**Important:** The repository must contain a `plugin.json` file in a `.github/plugin` or `.claude-plugin` directory, or at the root.

For plugins with `plugin.json` elsewhere:
```shell
copilot plugin install OWNER/REPO:PATH/TO/PLUGIN
```

### From Local Paths

```shell
copilot plugin install ./PATH/TO/PLUGIN
```

## Plugin Management Commands

```bash
copilot plugin list                    # View installed plugins
copilot plugin update PLUGIN-NAME      # Update plugin
copilot plugin uninstall PLUGIN-NAME   # Remove plugin
```

## Plugin Storage Location

- Marketplace plugins: `~/.copilot/state/installed-plugins/MARKETPLACE/PLUGIN-NAME/`
- Direct installations: `~/.copilot/state/installed-plugins/PLUGIN-NAME/`

## Managing Marketplaces

### Adding Marketplaces

For GitHub repositories:
```shell
copilot plugin marketplace add OWNER/REPO
```

For local directories:
```shell
copilot plugin marketplace add /PATH/TO/MARKETPLACE-DIRECTORY
```

For non-GitHub repositories:
```shell
copilot plugin marketplace add https://gitlab.com/OWNER/REPO.git
```

### Removing Marketplaces

```shell
copilot plugin marketplace remove MARKETPLACE-NAME
```

**Note:** Removing a marketplace with installed plugins requires the `--force` flag to proceed.
