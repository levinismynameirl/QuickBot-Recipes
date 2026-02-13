# QuickBot Plugin Development Guide

> Everything you need to build, test, and publish a QuickBot plugin.

> **⚠️ Development Beta (v0.1.0.dev0)** — QuickBot is in its first public release. The plugin API, hook events, context SDK, and formula format may change between development releases. Plugin authors should expect breaking changes until a stable v1.0 release.

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Plugin Structure](#plugin-structure)
4. [The `run()` Entry Point](#the-run-entry-point)
5. [Plugin Metadata (`PLUGIN_META`)](#plugin-metadata-plugin_meta)
6. [Using the Plugin Context](#using-the-plugin-context)
7. [Per-Plugin Virtual Environments](#per-plugin-virtual-environments)
8. [Hooks](#hooks)
9. [Multi-Command Plugins](#multi-command-plugins)
10. [Creating a Formula](#creating-a-formula)
11. [Formula Reference](#formula-reference)
12. [Aliases](#aliases)
13. [Testing Your Plugin Locally](#testing-your-plugin-locally)
14. [Publishing to the Registry](#publishing-to-the-registry)
15. [Best Practices](#best-practices)

---

## Overview

| Component | Repository | Purpose |
|-----------|------------|---------|
| **QuickBot** | `levinismynameirl/Quick-Bot` | The CLI tool |
| **QuickBot-Recipes** | `levinismynameirl/QuickBot-Recipes` | Formula registry (Ruby files that describe *how* to install each plugin) |
| **Your Plugin** | `your-username/your-plugin` | The actual plugin code (Python) |

The registry contains **only formula files**. Your plugin code lives in your own repository.

---

## Architecture

```
                        $ quick my_plugin --count 3
                               │
                   ┌───────────▼──────────────┐
                   │   QuickBot CLI (loader)   │
                   │  Try builtin → Try plugin │
                   └───────────┬──────────────┘
                               │
           ┌───────────────────┤ not a builtin
           ▼                   │
  QuickBot-Recipes         PluginRunner
  (formula + URL)       ┌──────┴──────────┐
           │            │ activate venv/   │
           │            │ load main.py     │
           │            │ call run(args)   │
           │            └─────────────────┘
           │
           ▼
  ~/.config/.quickbot/data/plugins/my_plugin/
  ├── my_plugin/
  │   └── commands/
  │       └── main.py          ← run(args)
  ├── hooks.py                 ← optional lifecycle hooks
  ├── venv/                    ← isolated virtual environment
  │   └── lib/python3.XX/site-packages/
  └── data/                    ← persistent config / state
      └── config.json
```

When the user runs `quick my_plugin`, QuickBot:

1. Looks for a builtin command named `my_plugin` — not found.
2. Asks `PluginRunner` whether the plugin is installed.
3. **Lazily activates** the plugin's virtual environment by injecting its
   `venv/lib/pythonX.Y/site-packages` into `sys.path`.
4. Dynamically loads `main.py` and calls `run(args)`.
5. Fires `post_command` hooks.

---

## Plugin Structure

### Minimal

```
my-plugin/                        ← your Git repo
└── my_plugin/                    ← must match the formula name
    └── commands/
        └── main.py               ← must define run(args)
```

### Recommended

```
my-plugin/
├── my_plugin/
│   ├── __init__.py
│   ├── commands/
│   │   ├── __init__.py
│   │   └── main.py              ← default command
│   ├── lib/                     ← shared helper modules
│   │   └── helpers.py
│   └── config.py                ← plugin-specific config
├── hooks.py                     ← lifecycle hooks (optional)
├── tests/
│   └── test_main.py
├── requirements.txt
├── README.md
└── LICENSE
```

> **Important:** The inner directory name (`my_plugin/`) must match the
> `name` field in your formula file. QuickBot installs into
> `~/.config/.quickbot/data/plugins/<name>/` and then looks for
> `<name>/commands/main.py` inside that directory.

---

## The `run()` Entry Point

Every plugin **must** expose a `run(args)` function in
`<name>/commands/main.py`:

```python
# my_plugin/commands/main.py
"""
My Plugin — does something useful.

Usage: quick my_plugin [options]
"""


def run(args: list[str]) -> int:
    """
    Entry point called by QuickBot.

    Parameters
    ----------
    args : list[str]
        Raw command-line arguments after the command name.
        e.g. ``quick my_plugin foo --bar`` → ``["foo", "--bar"]``

    Returns
    -------
    int
        Exit code. 0 = success, non-zero = error.
        Returning ``None`` is treated as 0.
    """
    if not args:
        print("Usage: quick my_plugin <name> [--shout]")
        return 0

    name = args[0]
    shout = "--shout" in args

    greeting = f"Hello, {name}!"
    print(greeting.upper() if shout else greeting)
    return 0
```

### Using QuickBot's argument parser

You can use QuickBot's built-in argument parser for consistent flag
handling:

```python
from quickbot.core.args import parse_args


def run(args):
    parsed = parse_args(args)

    # parsed.positional  → list of positional args
    # parsed.force       → True when --force or -f is present
    # parsed.dry_run     → True when --dry-run or -n is present
    # parsed.verbose     → True when --verbose or -v is present
    # parsed.yes         → True when --yes or -y is present
    # parsed.has_flag("--custom")  → True when --custom is present

    target = parsed.get(0, "default")
    print(f"Target: {target}, force={parsed.force}")
    return 0
```

---

## Plugin Metadata (`PLUGIN_META`)

Define a `PLUGIN_META` dict in `main.py` so QuickBot can display help
for your plugin (`quick explain my_plugin`):

```python
PLUGIN_META = {
    "description": "Download and play ambient sounds",
    "usage": "quick my_plugin <sound> [--loop] [--volume <0-100>]",
    "examples": [
        "quick my_plugin rain",
        "quick my_plugin rain --loop",
        "quick my_plugin ocean --volume 50",
    ],
    "flags": [
        "--loop          Repeat the sound continuously",
        "--volume <n>    Set volume (0-100, default 80)",
        "--list           List available sounds",
    ],
}
```

> **Note:** Built-in commands use `COMMAND_META`; plugins should use either
> `PLUGIN_META` or `COMMAND_META` — both are recognised.

---

## Using the Plugin Context

The `PluginContext` is a stable API that gives your plugin safe access to
QuickBot internals. It is the recommended way to interact with the host
app.

```python
from quickbot.core.context import get_context


def run(args):
    ctx = get_context()

    # ── Logging (coloured, prefixed with "quick") ────────────────────
    ctx.log_info("Fetching data...")
    ctx.log_warn("Rate limit approaching")
    ctx.log_error("Request failed")
    ctx.log_success("Done!")

    # ── Paths ────────────────────────────────────────────────────────
    data = ctx.plugin_data_dir("my_plugin")   # ~/.../plugins/my_plugin/data/
    cache = ctx.cache_dir()                    # ~/.../cache/

    # ── Plugin configuration (persisted JSON) ────────────────────────
    cfg = ctx.read_config("my_plugin")         # returns dict
    cfg["last_run"] = "2025-01-01"
    ctx.write_config("my_plugin", cfg)         # writes config.json

    # ── Environment variables (from ~/.quickbot/.env) ────────────────
    api_key = ctx.get_env("MY_PLUGIN_API_KEY")

    # ── macOS notifications ──────────────────────────────────────────
    ctx.notify("My Plugin", "Task complete!")
    ctx.beep()

    # ── Run a shell command ──────────────────────────────────────────
    result = ctx.run_shell("ls -la /tmp")
    print(result.stdout)

    # ── Locate a macOS app ───────────────────────────────────────────
    app = ctx.find_app("Safari")

    # ── Audit logging ────────────────────────────────────────────────
    ctx.audit_log("my_plugin", args, outcome="success")

    # ── Invoke another QuickBot command ──────────────────────────────
    ctx.invoke("notify", ["--title", "Done", "Backup finished"])

    return 0
```

### Context API Reference

| Method | Returns | Description |
|--------|---------|-------------|
| `log_info(msg)` | `None` | Print an info message |
| `log_warn(msg)` | `None` | Print a warning |
| `log_error(msg)` | `None` | Print an error |
| `log_success(msg)` | `None` | Print a success message |
| `data_root()` | `Path` | QuickBot data root |
| `plugins_dir()` | `Path` | All plugins directory |
| `cache_dir()` | `Path` | Shared cache directory |
| `config_dir()` | `Path` | QuickBot config directory |
| `log_dir()` | `Path` | Audit logs directory |
| `plugin_data_dir(name)` | `Path` | Per-plugin persistent data dir (created if needed) |
| `read_config(name)` | `dict` | Load plugin's config.json |
| `write_config(name, data)` | `None` | Save plugin's config.json |
| `get_env(key, default="")` | `str` | Read an env var |
| `quickbot_version()` | `str` | Current QuickBot version |
| `notify(title, msg)` | `None` | macOS notification |
| `beep()` | `None` | System alert sound |
| `run_shell(cmd)` | `CompletedProcess` | Run a shell command |
| `find_app(name)` | `str \| None` | Locate a macOS .app |
| `audit_log(cmd, args, ...)` | `None` | Write audit log entry |
| `invoke(cmd, args)` | `int` | Call another QuickBot command |

---

## Per-Plugin Virtual Environments

When you declare `depends_on_python` in your formula, QuickBot creates a
**dedicated virtual environment** inside the plugin directory
(`plugins/<name>/venv/`). This means:

- Your dependencies never conflict with QuickBot's own packages.
- Different plugins can depend on different versions of the same library.
- The venv is created at install time and transparently activated at
  runtime — no action needed in your plugin code.

```
plugins/weather_plugin/
├── weather_plugin/
│   └── commands/
│       └── main.py
└── venv/                         ← created automatically
    ├── bin/
    │   ├── python
    │   └── pip
    └── lib/
        └── python3.XX/
            └── site-packages/
                └── requests/     ← your dependency
```

Lazy loading means the venv is only activated (injected into `sys.path`)
when the plugin is actually called. Plugins that are never invoked in a
session have zero overhead.

---

## Hooks

Hooks let your plugin react to QuickBot lifecycle events — e.g. logging
every command, blocking dangerous actions, or cleaning up on exit.

### Available Events

| Event | Keyword Arguments | Description |
|-------|-------------------|-------------|
| `on_startup` | `ctx` | QuickBot process starts |
| `on_shutdown` | `ctx`, `exit_code` | QuickBot process exits |
| `pre_command` | `ctx`, `command`, `args` | Before any command runs (return `False` to abort) |
| `post_command` | `ctx`, `command`, `args`, `exit_code` | After a command succeeds |
| `on_error` | `ctx`, `command`, `args`, `error` | When a command raises an exception |
| `on_install` | `ctx`, `plugin_name`, `version` | After a plugin is installed |
| `on_remove` | `ctx`, `plugin_name` | Before a plugin is removed |
| `pre_update` | `ctx`, `plugin_name` | Before an update is applied |
| `post_update` | `ctx`, `plugin_name`, `version` | After an update completes |

Every handler receives `ctx` — a `PluginContext` instance (see above).

### Writing Hooks — Option A: `hooks.py` at plugin root

Place a `hooks.py` at the top level of your plugin package. QuickBot will
auto-discover functions whose names match event names:

```python
# hooks.py  (inside your installed plugin directory)
"""Lifecycle hooks for my_plugin."""


def on_startup(ctx, **kw):
    """Called when QuickBot starts."""
    ctx.log_info("[my_plugin] QuickBot is starting up")


def pre_command(ctx, command, args, **kw):
    """
    Called before every command.

    Return False to prevent the command from running.
    """
    blocked = ["trash", "clean"]
    if command in blocked and not any(f == "--force" for f in args):
        ctx.log_warn(f"[my_plugin] '{command}' blocked — use --force to override")
        return False
    return True


def post_command(ctx, command, args, exit_code, **kw):
    """Called after every successful command."""
    ctx.audit_log(f"hook:my_plugin:{command}", args, outcome="success")


def on_error(ctx, command, args, error, **kw):
    """Called when any command raises."""
    ctx.notify("QuickBot Error", f"{command} failed: {error}")


def on_install(ctx, plugin_name, version, **kw):
    ctx.log_success(f"[my_plugin] Saw install of {plugin_name} v{version}")


def on_remove(ctx, plugin_name, **kw):
    ctx.log_warn(f"[my_plugin] Plugin {plugin_name} is being removed")
```

> **Tip:** Always accept `**kw` so your hooks remain forward-compatible
> when new keyword arguments are added.

### Writing Hooks — Option B: Formula registration

For finer control (custom file paths, separate files per event), register
hooks in your formula:

```ruby
hooks(
  pre_command:  "hooks/guard.py:check_allowed",
  post_command: "hooks/telemetry.py:record",
  on_error:     "hooks/alerts.py:send_alert"
)
```

The path is relative to the installed plugin directory. The part after
`:` is the function name.

```python
# hooks/guard.py
def check_allowed(ctx, command, args, **kw):
    if command == "sleep" and "--force" not in args:
        ctx.log_warn("Sleep blocked by guard plugin")
        return False
    return True
```

### Hook Priority

By default all hooks run at priority 100. In auto-discovered hooks,
you can set a `HOOK_PRIORITY` module-level constant:

```python
# hooks.py
HOOK_PRIORITY = 50   # lower = runs earlier (before priority-100 hooks)


def pre_command(ctx, command, args, **kw):
    ...
```

### What Hooks Can Do

- **Block commands** (`pre_command` returning `False`)
- **Log or audit** every command
- **Send notifications** on errors or long-running operations
- **Chain commands** (e.g. always run `clean` after `update`)
- **Guard dangerous operations** (require `--force`)
- **Collect telemetry** (timing, usage statistics)
- **Read/write config** and persist state between runs
- **Invoke other commands** via `ctx.invoke()`

---

## Multi-Command Plugins

A plugin can expose sub-commands. Each file in `commands/` with a
`run(args)` function becomes a sub-command:

```
my_plugin/
└── my_plugin/
    └── commands/
        ├── __init__.py
        ├── main.py          ← quick my_plugin
        ├── status.py        ← quick my_plugin status
        └── sync.py          ← quick my_plugin sync
```

Route sub-commands in `main.py`:

```python
# my_plugin/commands/main.py
import importlib

PLUGIN_META = {
    "description": "Backup manager with sub-commands",
    "usage": "quick my_plugin <subcommand> [options]",
    "examples": [
        "quick my_plugin status",
        "quick my_plugin sync --force",
    ],
}

SUBCOMMANDS = ["status", "sync"]


def run(args):
    if args and args[0] in SUBCOMMANDS:
        sub = args[0]
        mod = importlib.import_module(f".{sub}", package=__package__)
        return mod.run(args[1:])

    # Default behaviour when no sub-command
    print("Usage: quick my_plugin <status|sync>")
    return 0
```

```python
# my_plugin/commands/status.py
def run(args):
    print("Everything is up to date.")
    return 0
```

---

## Creating a Formula

### Location in the Registry

```
QuickBot-Recipes/
└── registry/
    └── [first letter of plugin name]/
        └── your_plugin.rb

# Examples:
#   backup_tool    → registry/b/backup_tool.rb
#   weather_plugin → registry/w/weather_plugin.rb
```

### Minimal Formula

```ruby
# registry/m/my_plugin.rb
require_relative "../../abstract/formula"

class MyPlugin < PluginFormula
  name    "my_plugin"
  version "1.0.0"
  desc    "One-line description (< 80 chars)"
  homepage "https://github.com/you/my-plugin"

  url    "https://github.com/you/my-plugin/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb924..."

  license "MIT"
end
```

### Full Formula

```ruby
# registry/b/backup_tool.rb
require_relative "../../abstract/formula"

class BackupTool < PluginFormula
  # ── Required ────────────────────────────────────────────────────────
  name    "backup_tool"
  version "2.1.0"
  desc    "Automated backup management for QuickBot"
  homepage "https://github.com/you/backup-tool"

  url    "https://github.com/you/backup-tool/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "a1b2c3d4e5f6..."

  # Or: git "https://github.com/you/backup-tool.git", tag: "v2.1.0"

  # ── Metadata ────────────────────────────────────────────────────────
  author      "Your Name"
  license     "MIT"
  plugin_type :command          # :command | :extension | :library
  categories  "backup", "utility", "automation"

  # ── Version constraints ─────────────────────────────────────────────
  quickbot_version ">= 0.1.0.dev0"
  python_version   ">= 3.11"

  # ── Dependencies ────────────────────────────────────────────────────
  depends_on_python "requests >= 2.31", "pyyaml >= 6.0"
  depends_on_plugin "file_utils >= 1.0.0"
  depends_on_system "rsync", "ssh"

  # ── Aliases ─────────────────────────────────────────────────────────
  aliases(
    "bt"  => "backup_tool",
    "bts" => "backup_tool status",
    "btr" => "backup_tool sync --force"
  )

  # ── Hooks ───────────────────────────────────────────────────────────
  hooks(
    pre_command:  "hooks.py:pre_command",
    post_command: "hooks.py:post_command",
    on_error:     "hooks.py:on_error"
  )

  # ── Post-install message ────────────────────────────────────────────
  caveats <<~EOS
    Backup Tool installed!

    Quick start:
      quick backup_tool status     Check backup status
      quick backup_tool sync       Run a backup

    Set your API key:
      export BACKUP_TOOL_KEY="your-key"
    Or add it to ~/.quickbot/.env
  EOS
end
```

---

## Formula Reference

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | `String` | Unique identifier (`lowercase_with_underscores`) |
| `version` | `String` | Semantic version (`"1.2.3"`) |
| `desc` | `String` | One-line description (< 80 chars) |
| `homepage` | `String` | Your plugin's homepage URL |
| `url` | `String` | Download URL for the release tarball |
| `sha256` | `String` | SHA-256 checksum of the tarball |

### Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `author` | `String` | Plugin author |
| `license` | `String` | SPDX identifier (`"MIT"`, `"GPL-3.0"`, etc.) |
| `plugin_type` | `Symbol` | `:command`, `:extension`, or `:library` |
| `categories` | `String...` | Category tags for discovery |
| `quickbot_version` | `String` | Minimum QuickBot version |
| `python_version` | `String` | Minimum Python version |
| `caveats` | `String` | Message shown after install |

### Dependency Methods

| Method | Description |
|--------|-------------|
| `depends_on_python "pkg >= ver"` | Python packages (installed into plugin venv) |
| `depends_on_plugin "name >= ver"` | Other QuickBot plugins (installed first) |
| `depends_on_system "tool"` | System binaries (checked, not auto-installed) |

### Other Methods

| Method | Description |
|--------|-------------|
| `aliases(hash)` | Command shortcuts |
| `hooks(hash)` | Lifecycle hook registrations |
| `git url, tag: "..."` | Clone from git instead of download url |

---

## Aliases

```ruby
aliases(
  "w"  => "weather_plugin",              # quick w → quick weather_plugin
  "wf" => "weather_plugin --forecast",   # quick wf → quick weather_plugin --forecast
)
```

Rules:

- Keep aliases **2–4 characters**
- Avoid conflicts with builtins (`open`, `clean`, `start`, etc.)
- Avoid common system commands (`ls`, `cd`, `rm`)

---

## Testing Your Plugin Locally

### 1. Symlink into the plugins directory

```bash
# Create a symlink so QuickBot sees your dev code
ln -s "$(pwd)/my_plugin" \
  ~/.config/.quickbot/data/plugins/my_plugin/my_plugin
```

### 2. Run it

```bash
quick my_plugin --help
```

### 3. Create a venv manually (if you have dependencies)

```bash
cd ~/.config/.quickbot/data/plugins/my_plugin
python3 -m venv venv
venv/bin/pip install -r /path/to/my-plugin/requirements.txt
```

### 4. Test hooks

```bash
# If your plugin registers pre_command hooks, any command will trigger them:
quick version
```

---

## Publishing to the Registry

### Step 1 — Prepare

- [ ] `README.md` with usage instructions
- [ ] `LICENSE` file
- [ ] Plugin works locally (see above)
- [ ] Tagged release on GitHub (`git tag v1.0.0 && git push --tags`)

### Step 2 — Get SHA-256

```bash
VERSION="1.0.0"
REPO="your-username/my-plugin"

curl -L -o plugin.tar.gz \
  "https://github.com/${REPO}/archive/refs/tags/v${VERSION}.tar.gz"

shasum -a 256 plugin.tar.gz
# → abc123def456...  plugin.tar.gz
```

### Step 3 — Create the formula

Fork `levinismynameirl/QuickBot-Recipes` and create:

```
registry/[first letter]/my_plugin.rb
```

### Step 4 — Submit a Pull Request

Fill in the PR template. Maintainers will:

1. Validate formula syntax
2. Verify SHA-256 matches
3. Review plugin source for security
4. Test installation end-to-end

---

## Best Practices

### Error handling

```python
# ✅ Catch errors, return a meaningful exit code
def run(args):
    try:
        do_work()
        return 0
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1
```

### Secrets

```python
# ✅ Use env vars (loaded from ~/.quickbot/.env)
from quickbot.core.context import get_context
api_key = get_context().get_env("MY_PLUGIN_API_KEY")

# ❌ Never hardcode
api_key = "sk-secret-123"
```

### Accept `**kw` in hooks

```python
# ✅ Forward-compatible
def pre_command(ctx, command, args, **kw):
    ...

# ❌ Will break when new kwargs are added
def pre_command(ctx, command, args):
    ...
```

### Use the Context, not internal imports

```python
# ✅ Stable API
from quickbot.core.context import get_context
get_context().log_info("Hello")

# ❌ Internal — may change without notice
from quickbot.utils.console import log_info
log_info("Hello")
```

### Keep dependencies minimal

Only declare what you actually import. Every dependency slows install and
grows the plugin venv.

---

*Happy plugin development!*
