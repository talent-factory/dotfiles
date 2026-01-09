# Augment Code Configuration

This directory contains Augment Code custom commands and subagents that can be installed to:
- **Home directory (macOS)**: `~/.augment/commands/` and `~/.augment/agents/`
- **Home directory (Windows)**: `%USERPROFILE%\.augment\commands\` and `%USERPROFILE%\.augment\agents\`
- **Workspace directory**: `./.augment/commands/` and `./.augment/agents/`

## Structure

```
augment/
├── commands/         # Slash commands
│   └── (your commands here)
└── agents/           # Subagents (NEW: since Augment Code CLI update)
    └── (your agents here)
```

## Installation

Use the installer script from the repository root:

```bash
# Interactive installation (recommended - installs both commands and agents)
./install.sh --interactive

# Or manually symlink (macOS/Linux)
ln -sf /path/to/dotfiles/agents/augment/commands ~/.augment/commands
ln -sf /path/to/dotfiles/agents/augment/agents ~/.augment/agents

# Or manually symlink (Windows PowerShell)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.augment\commands" -Target "path\to\dotfiles\agents\augment\commands"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.augment\agents" -Target "path\to\dotfiles\agents\augment\agents"
```

## File Format

### Commands

Commands are Markdown files (`.md`) with optional YAML frontmatter:

```yaml
---
description: Brief description of the command
argument-hint: [expected-arguments]
model: gpt-4o
---

# Command content here
```

### Subagents

Subagents are Markdown files (`.md`) with YAML frontmatter:

```yaml
---
name: agent-identifier
description: Purpose of the agent
color: purple
model: claude-sonnet-4-5
---

# Agent instructions in markdown format
```

**Required fields**: `name`
**Optional fields**: `description`, `color`, `model`

**Available colors**: `blue`, `green`, `red`, `yellow`, `purple`, `orange`, `cyan`, `magenta`

## Usage

### Commands

After installation, commands are invoked in Augment Code with:

```
/<command-name>
```

For commands in subdirectories:

```
/<subdirectory>:<command-name>
```

### Subagents

Subagents are specialized AI assistants that can be invoked using the Task tool or by referencing their name. They provide focused expertise for specific tasks (e.g., code review, testing, documentation).

To use a subagent from Augment Code:
1. Use the Task tool with the subagent name
2. Or reference it in your prompt (e.g., "use the code-review agent")

## Features

- **Claude Code compatible**: Augment can also read `.claude/commands/` and `.claude/agents/`
- **Hierarchical namespaces**: Use subdirectories for organization
- **Kebab-case naming**: `security-review.md` → `/security-review`
- **Subagents support**: NEW - Deploy specialized AI agents for focused tasks

## Documentation

For detailed documentation, see:
- [Augment Commands Docs](https://docs.augmentcode.com/cli/custom-commands)
- [Augment Subagents Docs](https://docs.augmentcode.com/cli/subagents)
- [AI Agents Reference](../../install/AI_AGENTS_REFERENCE.md)
