# Augment Code Configuration

This directory contains Augment Code custom commands that can be installed to:
- **Home directory (macOS)**: `~/.augment/commands/`
- **Home directory (Windows)**: `%USERPROFILE%\.augment\commands\`
- **Workspace directory**: `./.augment/commands/`

## Structure

```
augment/
└── commands/         # Slash commands
    └── (your commands here)
```

## Installation

Use the installer script from the repository root:

```bash
# Interactive installation
./install.sh --interactive

# Or manually symlink (macOS/Linux)
ln -sf /path/to/dotfiles/agents/augment/commands ~/.augment/commands

# Or manually symlink (Windows PowerShell)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.augment\commands" -Target "path\to\dotfiles\agents\augment\commands"
```

## File Format

Commands are Markdown files (`.md`) with optional YAML frontmatter:

```yaml
---
description: Brief description of the command
argument-hint: [expected-arguments]
model: gpt-4o
---

# Command content here
```

## Commands

After installation, commands are invoked in Augment Code with:

```
/<command-name>
```

For commands in subdirectories:

```
/<subdirectory>:<command-name>
```

## Features

- **Claude Code compatible**: Augment can also read `.claude/commands/`
- **Hierarchical namespaces**: Use subdirectories for organization
- **Kebab-case naming**: `security-review.md` → `/security-review`

## Documentation

For detailed documentation, see:
- [Augment Docs](https://docs.augmentcode.com/cli/custom-commands)
- [AI Agents Reference](../../install/AI_AGENTS_REFERENCE.md)
