# QuickBot-Recipes

[![Plugin Registry](https://img.shields.io/badge/plugins-registry-blue.svg)](https://github.com/levinismynameirl/QuickBot-Recipes)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/levinismynameirl/QuickBot-Recipes/pulls)
[![macOS](https://img.shields.io/badge/platform-macOS-lightgrey.svg)]()

> The official plugin registry for [QuickBot](https://github.com/levinismynameirl/Quick-Bot) - a powerful macOS CLI automation tool.

> **⚠️ Development Build (v0.1.0.dev0)**
> QuickBot is currently in **development beta**. This is the first public release. The plugin API, formula format, and registry structure may change between development releases. Plugin authors should expect breaking changes until a stable v1.0 release.

---

## Overview

**QuickBot-Recipes** is the plugin registry for QuickBot. Similar to Homebrew's `homebrew-core`, this repository contains **formula files** that describe how to install plugins - not the plugins themselves.

### How It Works

```md
┌─────────────────────────────────────────────────────────────────────────┐
│                           Plugin Installation                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. User runs: quick plugins --install my_plugin                        │
│                          │                                              │
│                          ▼                                              │
│  2. QuickBot reads formula from QuickBot-Recipes                        │
│     registry/m/my_plugin.rb                                             │
│                          │                                              │
│                          ▼                                              │
│  3. Downloads plugin from author's repo                                 │
│     https://github.com/author/my-plugin/archive/v1.0.0.tar.gz           │
│                          │                                              │
│                          ▼                                              │
│  4. Installs to QuickBot's plugins directory                            │
│     ~/.config/.quickbot/data/plugins/my_plugin/                         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### What's In This Repository

- **Formula files** (`registry/[a-z]/plugin_name.rb`) - Ruby files describing plugin metadata and installation
- **Not plugin source code** - Actual plugins live in their authors' repositories

---

## Quick Start

### Installing Plugins

```bash
# Install a plugin from the registry
quick plugins --install plugin_name

# Install a specific version
quick plugins --install plugin_name@1.2.0

# List installed plugins
quick plugins --list

# Update a plugin
quick plugins --update plugin_name

# Remove a plugin
quick plugins --remove plugin_name
```

### Searching for Plugins

```bash
# Search the registry
quick plugins --search keyword

# Get plugin info
quick plugins --info plugin_name
```

---

## Repository Structure

```
QuickBot-Recipes/
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md    # PR template for plugin submissions
│   └── workflows/                   # CI/CD validation
├── docs/
│   └── PLUGIN_GUIDE.md             # How to create plugins & formulas
├── registry/                        # Plugin formulas (alphabetical)
│   ├── a/
│   ├── b/
│   │   └── backup_manager.rb
│   ├── e/
│   │   └── example_plugin.rb       # Example formula
│   └── z/
├── abstract/
│   └── formula.rb                  # Base class for formulas
├── aliases/                         # Global alias definitions
├── cmd/                             # Registry management scripts
├── .rubocop.yml
├── .ruby-version
├── CODEOWNERS
├── LICENSE
└── README.md
```

---

## Formula Structure

A formula is a Ruby file that tells QuickBot how to install a plugin. The actual plugin code lives in the plugin author's own repository.

### Example Formula

```ruby
# registry/e/example_plugin.rb

class ExamplePlugin < PluginFormula
  name "example_plugin"
  version "1.0.0"
  desc "A minimal example plugin"
  homepage "https://github.com/author/example-plugin"
  
  # Points to the plugin author's release
  url "https://github.com/author/example-plugin/archive/v1.0.0.tar.gz"
  sha256 "abc123..."
  
  # Optional metadata
  author "Plugin Author"
  license "MIT"
  plugin_type :command
  categories "utility", "example"
  
  # Dependencies
  depends_on_python "requests", "click"
  
  # Aliases
  aliases(
    "ex" => "example_plugin",
    "exh" => "example_plugin --help"
  )
  
  # Post-install message
  caveats <<~EOS
    Plugin installed! Run: quick example_plugin --help
  EOS
end
```

---

## For Plugin Authors

Want to add your plugin to the registry?

### Step 1: Create Your Plugin

Your plugin lives in **your own repository** with this structure:

```
your-plugin-repo/
├── your_plugin/              # Plugin source code
│   ├── __init__.py
│   └── commands/
│       └── main.py           # Command with run(args) function
├── README.md
├── LICENSE
└── setup.py                  # Optional
```

### Step 2: Create a Release

Tag a release on GitHub:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Generate the SHA256 checksum:

```bash
curl -L -o plugin.tar.gz https://github.com/you/your-plugin/archive/v1.0.0.tar.gz
shasum -a 256 plugin.tar.gz
```

### Step 3: Submit a Formula

1. Fork this repository
2. Create `registry/[first-letter]/your_plugin.rb`
3. Submit a Pull Request

See the [Plugin Development Guide](docs/PLUGIN_GUIDE.md) for complete instructions.

---

## Important Warnings

### Community Plugin Disclaimer

> **NOTICE**: Plugins in this registry are contributed by the community. While we review formulas, **installing community plugins may**:
>
> - Execute code on your system
> - Modify your QuickBot configuration
> - Install additional dependencies
>
> **Always review plugin source code before installation.** QuickBot and its maintainers are not responsible for issues caused by third-party plugins.

### Safe Practices

- Review the plugin's source repository before installing
- Check the plugin's version history and maintainer activity
- Use `quick plugins --info plugin_name` to view details first
- Never install plugins from untrusted sources

---

## Contributing

### Submitting a Plugin Formula

1. Fork this repository
2. Create your formula in `registry/[first-letter]/your_plugin.rb`
3. Submit a Pull Request using our [template](.github/PULL_REQUEST_TEMPLATE.md)

### Formula Requirements

- Valid Ruby syntax
- All required fields (`name`, `version`, `desc`, `homepage`, `url`, `sha256`)
- Accessible download URL
- Correct SHA256 checksum
- No alias conflicts

See [PLUGIN_GUIDE.md](docs/PLUGIN_GUIDE.md) for details.

---

## CLI Reference

| Command | Description |
|---------|-------------|
| `quick plugins --install <name>` | Install a plugin |
| `quick plugins --remove <name>` | Remove a plugin |
| `quick plugins --update <name>` | Update a plugin |
| `quick plugins --list` | List installed plugins |
| `quick plugins --search <query>` | Search registry |
| `quick plugins --info <name>` | Show plugin details |

---

## Links

- [QuickBot Main Repository](https://github.com/levinismynameirl/Quick-Bot)
- [Plugin Development Guide](docs/PLUGIN_GUIDE.md)
- [Submit a Plugin](https://github.com/levinismynameirl/QuickBot-Recipes/pulls)
- [Report an Issue](https://github.com/levinismynameirl/QuickBot-Recipes/issues)

---

## License

This repository is licensed under the [MIT License](LICENSE).

Individual plugins have their own licenses - check each plugin's source repository.

---

## Disclaimer

QuickBot v0.1.0.dev0 is a **development beta** — the first public build. The plugin API, formula format, hooks system, and registry structure may change between development releases. Plugin authors should pin to specific QuickBot versions and expect breaking changes until a stable v1.0 release.

---

<p align="center">
  Made by the QuickBot Community
</p>
