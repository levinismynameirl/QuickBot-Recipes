# Plugin Formula Submission

Thank you for contributing to QuickBot-Recipes! Please fill out all sections below.

---

## Checklist

### Formula Requirements
- [ ] Formula file is located in `registry/[first-letter]/plugin_name.rb`
- [ ] Plugin name is lowercase with underscores only (e.g., `my_plugin`)
- [ ] Plugin name is unique and not already in the registry
- [ ] Version follows semantic versioning (e.g., `1.0.0`)
- [ ] Description is clear and under 80 characters
- [ ] Homepage URL is valid and accessible
- [ ] Download URL is accessible
- [ ] SHA256 checksum is correct and verified
- [ ] Formula inherits from `PluginFormula`
- [ ] Ruby syntax is valid (`ruby -c formula.rb`)

### Plugin Repository (Your Repo)
- [ ] Plugin source repository is publicly accessible
- [ ] Plugin has a README with usage instructions
- [ ] Plugin has a LICENSE file
- [ ] Tagged release exists on GitHub
- [ ] Plugin has been tested with the latest QuickBot version

### Aliases (if applicable)
- [ ] Aliases are short and memorable (2-4 characters)
- [ ] Aliases do not conflict with existing QuickBot commands
- [ ] Aliases do not conflict with common system commands (`ls`, `cd`, `rm`, etc.)

---

## Plugin Information

### Name

```
plugin_name
```

### Version

```
1.0.0
```

### Description

```
A clear and concise description of your plugin (under 80 chars).
```

---

## Plugin Type

- [ ] **Command** - Adds a new command to QuickBot
- [ ] **Extension** - Provides multiple commands and/or hooks
- [ ] **Library** - Provides utilities for other plugins

---

## Category

- [ ] automation
- [ ] productivity
- [ ] development
- [ ] system
- [ ] network
- [ ] file-management
- [ ] integration
- [ ] utility
- [ ] other: _____________

---

## Source Information

### Homepage URL

```
https://github.com/author/plugin-name
```

### Download URL

```
https://github.com/author/plugin-name/archive/refs/tags/v1.0.0.tar.gz
```

### SHA256 Checksum

```
# Generate with: shasum -a 256 <file.tar.gz>
abc123def456...
```

---

## Dependencies

### Python Dependencies

```
# List pip packages (or "none")
requests >= 2.25.0
click >= 8.0
```

### Plugin Dependencies

```
# List other QuickBot plugins (or "none")
none
```

### System Dependencies

```
# List system tools required (or "none")
none
```

---

## Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `mp` | `my_plugin` | Main command shortcut |
| `mps` | `my_plugin status` | Status shortcut |

---

## Submission Type

- [ ] **New Plugin** - First submission of this plugin
- [ ] **Version Update** - Updating an existing plugin
- [ ] **Bug Fix** - Fixing an issue with a formula

---

## For Updates Only

### Previous Version

```
0.9.0
```

### What Changed

- Added new feature X
- Fixed bug Y
- Updated dependency Z

---

## Testing

- [ ] Tested locally with QuickBot
- [ ] Verified SHA256 checksum matches
- [ ] Tested on macOS version: _____________
- [ ] Tested with QuickBot version: _____________

---

## Declaration

By submitting this pull request, I confirm that:

- [ ] I have read the [Plugin Development Guide](../docs/PLUGIN_GUIDE.md)
- [ ] I am the author of this plugin OR have permission to submit it
- [ ] This plugin does not contain malicious code
- [ ] This plugin does not violate any copyrights or licenses

---

## Reviewer Notes

<!-- For maintainers only -->

### Review Checklist

- [ ] Ruby syntax valid
- [ ] Required fields present
- [ ] Download URL accessible
- [ ] SHA256 verified
- [ ] Plugin source reviewed
- [ ] No alias conflicts
- [ ] Documentation adequate
