# QuickBot Plugin Development Guide 📚

> A complete guide to creating plugins for QuickBot and submitting them to the registry.

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Creating a Plugin](#creating-a-plugin)
4. [Plugin Structure](#plugin-structure)
5. [Command Plugins](#command-plugins)
6. [Complex Extensions](#complex-extensions)
7. [Creating a Formula](#creating-a-formula)
8. [Formula Reference](#formula-reference)
9. [Aliases](#aliases)
10. [Hooks](#hooks)
11. [Publishing to the Registry](#publishing-to-the-registry)
12. [Best Practices](#best-practices)

---

## Overview

The QuickBot plugin ecosystem consists of three parts:

| Component | Repository | Purpose |
|-----------|------------|---------|
| **QuickBot** | `quickbot/quickbot` | The main CLI tool |
| **QuickBot-Recipes** | `quickbot/QuickBot-Recipes` | Plugin registry (formulas only) |
| **Your Plugin** | `your-username/your-plugin` | Your actual plugin code |

**Key Concept**: The QuickBot-Recipes repository contains only **formula files** (Ruby) that describe how to install plugins. The actual plugin code lives in each plugin author's own repository.

---

## Architecture

```
┌──────────────────────────────────────────────────────────────────────────┐
│                              User's System                                │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  $ quick plugin --install my_plugin                                      │
│                     │                                                     │
│                     ▼                                                     │
│  ┌─────────────────────────────────────────┐                             │
│  │            QuickBot CLI                  │                             │
│  │         (quickbot/quickbot)              │                             │
│  └─────────────────────────────────────────┘                             │
│                     │                                                     │
│                     │ 1. Fetch formula                                   │
│                     ▼                                                     │
│  ┌─────────────────────────────────────────┐                             │
│  │       QuickBot-Recipes Registry          │                             │
│  │    (quickbot/QuickBot-Recipes)           │                             │
│  │                                          │                             │
│  │  registry/m/my_plugin.rb                │                             │
│  │  ┌────────────────────────────────────┐ │                             │
│  │  │ url "https://github.com/author/    │ │                             │
│  │  │      my-plugin/archive/v1.0.0..."  │ │                             │
│  │  │ sha256 "abc123..."                 │ │                             │
│  │  └────────────────────────────────────┘ │                             │
│  └─────────────────────────────────────────┘                             │
│                     │                                                     │
│                     │ 2. Download from URL                               │
│                     ▼                                                     │
│  ┌─────────────────────────────────────────┐                             │
│  │      Plugin Author's Repository          │                             │
│  │      (author/my-plugin on GitHub)        │                             │
│  │                                          │                             │
│  │  my_plugin/                              │                             │
│  │  ├── commands/                           │                             │
│  │  │   └── main.py  ← run(args)           │                             │
│  │  ├── README.md                           │                             │
│  │  └── LICENSE                             │                             │
│  └─────────────────────────────────────────┘                             │
│                     │                                                     │
│                     │ 3. Install to plugins dir                          │
│                     ▼                                                     │
│  ┌─────────────────────────────────────────┐                             │
│  │    ~/.quickbot/plugins/my_plugin/        │                             │
│  │    (Plugin is now installed!)            │                             │
│  └─────────────────────────────────────────┘                             │
│                                                                           │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Creating a Plugin

### Step 1: Create Your Repository

Create a new GitHub repository for your plugin:

```bash
mkdir my-awesome-plugin
cd my-awesome-plugin
git init
```

### Step 2: Set Up Plugin Structure

```
my-awesome-plugin/
├── my_awesome_plugin/          # Plugin package (matches plugin name)
│   ├── __init__.py
│   └── commands/
│       └── main.py             # Main command entry point
├── README.md                   # Documentation
├── LICENSE                     # License file
└── requirements.txt            # Python dependencies (optional)
```

### Step 3: Implement Your Command

```python
# my_awesome_plugin/commands/main.py
"""
My Awesome Plugin for QuickBot.

Usage:
    quick my_awesome_plugin [options]
"""

def run(args):
    """
    Main entry point for the plugin command.
    
    Args:
        args: List of command-line arguments.
        
    Returns:
        int: Exit code (0 = success, non-zero = error).
    """
    print("Hello from my_awesome_plugin!")
    return 0
```

### Step 4: Create a Release

```bash
git add .
git commit -m "Initial release"
git tag v1.0.0
git push origin main --tags
```

### Step 5: Get SHA256 Checksum

```bash
curl -L -o plugin.tar.gz \
  https://github.com/YOUR_USERNAME/my-awesome-plugin/archive/refs/tags/v1.0.0.tar.gz
shasum -a 256 plugin.tar.gz
```

---

## Plugin Structure

### Minimal Structure

```
my_plugin/
├── my_plugin/
│   └── commands/
│       └── main.py       # Required: must have run(args) function
├── README.md
└── LICENSE
```

### Full Structure

```
my_plugin/
├── my_plugin/
│   ├── __init__.py
│   ├── commands/
│   │   ├── __init__.py
│   │   ├── main.py           # Default command
│   │   ├── subcommand1.py    # Additional subcommands
│   │   └── subcommand2.py
│   ├── hooks/                # Optional: lifecycle hooks
│   │   └── lifecycle.py
│   ├── lib/                  # Optional: shared utilities
│   │   └── helpers.py
│   └── config.py             # Optional: configuration
├── tests/
│   └── test_main.py
├── README.md
├── LICENSE
├── requirements.txt
└── setup.py
```

---

## Command Plugins

Command plugins are the simplest type. They add a new command to QuickBot.

### Basic Command

```python
# my_plugin/commands/main.py
"""A simple greeting plugin."""

def run(args):
    """Greet the user."""
    name = args[0] if args else "World"
    print(f"Hello, {name}!")
    return 0
```

### Command with Argument Parsing

```python
# my_plugin/commands/main.py
"""Plugin with proper argument parsing."""

import argparse
import sys

def run(args):
    """Main command with options."""
    parser = argparse.ArgumentParser(
        prog="quick my_plugin",
        description="My awesome plugin"
    )
    parser.add_argument("name", nargs="?", default="World")
    parser.add_argument("-c", "--count", type=int, default=1)
    parser.add_argument("-s", "--shout", action="store_true")
    
    try:
        parsed = parser.parse_args(args)
    except SystemExit:
        return 1
    
    message = f"Hello, {parsed.name}!"
    if parsed.shout:
        message = message.upper()
    
    for _ in range(parsed.count):
        print(message)
    
    return 0
```

### Command with Dependencies

```python
# my_plugin/commands/main.py
"""Plugin that uses external packages."""

def run(args):
    try:
        import requests
    except ImportError:
        print("Error: requests package required")
        print("This should be auto-installed. Try reinstalling the plugin.")
        return 1
    
    response = requests.get("https://api.example.com/data")
    print(response.json())
    return 0
```

---

## Complex Extensions

Extensions provide multiple commands and/or hooks.

### Multi-Command Plugin

```
my_extension/
├── my_extension/
│   └── commands/
│       ├── main.py           # quick my_extension
│       ├── status.py         # quick my_extension status
│       └── sync.py           # quick my_extension sync
```

Each subcommand file has its own `run(args)` function.

---

## Creating a Formula

A formula is a Ruby file in QuickBot-Recipes that describes how to install your plugin.

### Formula Location

```
QuickBot-Recipes/
└── registry/
    └── [first-letter]/
        └── your_plugin.rb
```

Example: Plugin named `backup_tool` → `registry/b/backup_tool.rb`

### Minimal Formula

```ruby
# registry/b/backup_tool.rb

class BackupTool < PluginFormula
  name "backup_tool"
  version "1.0.0"
  desc "Automated backup management for QuickBot"
  homepage "https://github.com/yourname/backup-tool"
  
  url "https://github.com/yourname/backup-tool/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  
  license "MIT"
end
```

### Complete Formula

```ruby
# registry/b/backup_tool.rb

class BackupTool < PluginFormula
  # ─────────────────────────────────────────────────────────────────
  # Required Fields
  # ─────────────────────────────────────────────────────────────────
  
  name "backup_tool"
  version "1.2.0"
  desc "Automated backup management for QuickBot"
  homepage "https://github.com/yourname/backup-tool"
  
  url "https://github.com/yourname/backup-tool/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "a1b2c3d4e5f6789..."
  
  # Or use git directly:
  # git "https://github.com/yourname/backup-tool.git", tag: "v1.2.0"
  
  # ─────────────────────────────────────────────────────────────────
  # Optional Metadata
  # ─────────────────────────────────────────────────────────────────
  
  author "Your Name"
  license "MIT"
  plugin_type :command          # :command, :extension, or :library
  categories "backup", "utility", "automation"
  
  # ─────────────────────────────────────────────────────────────────
  # Version Requirements
  # ─────────────────────────────────────────────────────────────────
  
  quickbot_version ">= 2.0.0"
  python_version ">= 3.8"
  
  # ─────────────────────────────────────────────────────────────────
  # Dependencies
  # ─────────────────────────────────────────────────────────────────
  
  depends_on_python "requests >= 2.25.0", "click >= 8.0"
  depends_on_plugin "file_utils >= 1.0.0"   # Other QuickBot plugins
  depends_on_system "rsync", "ssh"           # System tools
  
  # ─────────────────────────────────────────────────────────────────
  # Aliases
  # ─────────────────────────────────────────────────────────────────
  
  aliases(
    "bt"  => "backup_tool",
    "bts" => "backup_tool status",
    "btr" => "backup_tool run"
  )
  
  # ─────────────────────────────────────────────────────────────────
  # Hooks (for extensions)
  # ─────────────────────────────────────────────────────────────────
  
  hooks(
    pre_command: "hooks/lifecycle.py:before_command",
    post_command: "hooks/lifecycle.py:after_command"
  )
  
  # ─────────────────────────────────────────────────────────────────
  # Post-Install Message
  # ─────────────────────────────────────────────────────────────────
  
  caveats <<~EOS
    Backup Tool has been installed!
    
    Quick start:
      quick backup_tool init       Set up backup configuration
      quick backup_tool run        Run a backup
      quick backup_tool status     Check backup status
    
    Configuration is stored in ~/.quickbot/backup_tool/config.yaml
    
    For more information:
      https://github.com/yourname/backup-tool
  EOS
end
```

---

## Formula Reference

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | String | Unique plugin identifier (lowercase, underscores) |
| `version` | String | Semantic version (e.g., "1.0.0") |
| `desc` | String | Brief description (< 80 chars) |
| `homepage` | String | Plugin homepage URL |
| `url` | String | Download URL for release tarball |
| `sha256` | String | SHA256 checksum of the download |

### Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `author` | String | Plugin author name |
| `license` | String | License identifier (e.g., "MIT") |
| `plugin_type` | Symbol | `:command`, `:extension`, or `:library` |
| `categories` | Strings | Category tags for discovery |
| `quickbot_version` | String | Minimum QuickBot version |
| `python_version` | String | Minimum Python version |

### Dependency Methods

| Method | Description |
|--------|-------------|
| `depends_on_python` | Python packages (installed via pip) |
| `depends_on_plugin` | Other QuickBot plugins |
| `depends_on_system` | System tools (checked, not installed) |

### Other Methods

| Method | Description |
|--------|-------------|
| `aliases` | Command shortcuts |
| `hooks` | Lifecycle hook registrations |
| `caveats` | Post-install message |

---

## Aliases

Aliases are shortcuts for plugin commands.

### Defining Aliases

```ruby
aliases(
  "mp"  => "my_plugin",              # quick mp → quick my_plugin
  "mps" => "my_plugin status",       # quick mps → quick my_plugin status
  "mpv" => "my_plugin --verbose"     # quick mpv → quick my_plugin --verbose
)
```

### Best Practices

- Keep aliases short (2-4 characters)
- Make them memorable and intuitive
- Avoid conflicts with system commands (`ls`, `cd`, `rm`, etc.)
- Avoid conflicts with other plugins

---

## Hooks

Hooks allow extension plugins to intercept QuickBot's lifecycle.

### Available Hooks

| Hook | When Triggered |
|------|----------------|
| `pre_init` | Before QuickBot initializes |
| `post_init` | After QuickBot initializes |
| `pre_command` | Before any command runs |
| `post_command` | After any command completes |
| `on_error` | When an error occurs |

### Implementing Hooks

In your plugin's `hooks/lifecycle.py`:

```python
def before_command(command_name, args, context):
    """Called before any command executes."""
    print(f"About to run: {command_name}")
    return True  # Return False to abort

def after_command(command_name, args, result, context):
    """Called after any command completes."""
    print(f"Completed: {command_name} with exit code {result}")
```

Register in your formula:

```ruby
hooks(
  pre_command: "hooks/lifecycle.py:before_command",
  post_command: "hooks/lifecycle.py:after_command"
)
```

---

## Publishing to the Registry

### Step 1: Prepare Your Plugin Repository

- [ ] Plugin has `README.md` with usage instructions
- [ ] Plugin has `LICENSE` file
- [ ] Plugin works locally
- [ ] Tagged release exists on GitHub

### Step 2: Get SHA256 Checksum

```bash
VERSION="1.0.0"
REPO="your-username/your-plugin"

curl -L -o plugin.tar.gz \
  "https://github.com/${REPO}/archive/refs/tags/v${VERSION}.tar.gz"
  
shasum -a 256 plugin.tar.gz
# Output: abc123def456... plugin.tar.gz
```

### Step 3: Create Formula

Fork QuickBot-Recipes and create:

```
registry/[first-letter]/your_plugin.rb
```

### Step 4: Submit Pull Request

Use the PR template and fill in all required fields.

### Step 5: Wait for Review

Maintainers will:
1. Validate formula syntax
2. Check SHA256 matches
3. Review plugin source for security
4. Test installation

---

## Best Practices

### Plugin Code

```python
# ✅ Good: Handle errors gracefully
def run(args):
    try:
        result = do_something()
        print(result)
        return 0
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1

# ❌ Bad: Let exceptions propagate
def run(args):
    result = do_something()  # May crash
    print(result)
```

### Security

```python
# ✅ Good: Use environment variables
api_key = os.environ.get("MY_PLUGIN_API_KEY")

# ❌ Bad: Hardcoded secrets
api_key = "sk-secret-123"  # NEVER DO THIS
```

### Documentation

- Include usage examples in README
- Document all options and flags
- Provide troubleshooting tips

### Formula

- Use semantic versioning
- Keep descriptions under 80 characters
- Test your formula locally before submitting

---

## Need Help?

- 📖 [QuickBot Documentation](https://quickbot.dev/docs)
- 💬 [Community Discord](https://discord.gg/quickbot)
- 🐛 [Report Issues](https://github.com/quickbot/QuickBot-Recipes/issues)

---

<p align="center">
  <strong>Happy plugin development! 🚀</strong>
</p>
