# OpenCode Configuration

This directory contains OpenCode custom commands that can be installed to:
- **Home directory (macOS/Linux)**: `~/.config/opencode/command/`
- **Home directory (Windows)**: `%USERPROFILE%\.config\opencode\command\`
- **Workspace directory**: `.opencode/command/`

## Structure

```
opencode/
└── command/          # Slash commands (symlink to _shared/commands)
    └── (your commands here)
```

## Installation

Use the installer script from the repository root:

```bash
# Interactive installation
./install.sh --interactive

# Or manually symlink (macOS/Linux)
ln -sf /path/to/dotfiles/agents/_shared/commands ~/.config/opencode/command

# Or manually symlink (Windows PowerShell)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\opencode\command" -Target "path\to\dotfiles\agents\_shared\commands"
```

## File Format

Commands are Markdown files (`.md`) with optional YAML frontmatter:

```yaml
---
description: Brief description of the command
agent: coder
model: anthropic/claude-sonnet-4-20250514
subtask: false
---

# Command content here
```

### Frontmatter Options

| Field | Required | Description |
|-------|----------|-------------|
| `description` | Optional | Shown in the TUI when typing the command |
| `agent` | Optional | Which agent should execute (e.g., `coder`, `build`, `plan`) |
| `model` | Optional | Override default model (e.g., `anthropic/claude-sonnet-4-20250514`) |
| `subtask` | Optional | Force command to run as subagent (`true`/`false`) |

**Note**: Fields like `category` and `allowed-tools` from other agents are ignored by OpenCode but don't cause errors.

## Commands

After installation, commands are invoked in OpenCode TUI with:

```
/<command-name>
```

For example, `commit.md` becomes:

```
/commit
```

## Special Syntax

OpenCode supports additional placeholders in command templates:

### Arguments

```markdown
Create a component named $ARGUMENTS
```

Or positional arguments:

```markdown
Create file $1 in directory $2 with content $3
```

### Shell Output

Include shell command output with backtick syntax:

```markdown
Here are the test results:
!`npm test`
```

### File References

Include file content with `@` prefix:

```markdown
Review the code in @src/components/Button.tsx
```

## Features

- **YAML frontmatter**: Supports `description`, `agent`, `model`, `subtask`
- **Argument placeholders**: `$ARGUMENTS`, `$1`, `$2`, `$3`, etc.
- **Shell integration**: Include command output with `` !`command` ``
- **File references**: Include files with `@path/to/file`
- **TUI integration**: Commands shown in OpenCode terminal UI

## Limitations

- `category` frontmatter field is ignored (used by Claude/Augment)
- `allowed-tools` frontmatter field is ignored (used by Claude)
- No hierarchical namespaces (flat command structure)

## Configuration

OpenCode can also be configured via `opencode.jsonc`:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "command": {
    "test": {
      "template": "Run the test suite with coverage",
      "description": "Run tests with coverage",
      "agent": "build",
      "model": "anthropic/claude-sonnet-4-20250514"
    }
  }
}
```

## Built-in Commands

OpenCode includes several built-in commands:

- `/init` - Initialize OpenCode in a project
- `/undo` - Undo last action
- `/redo` - Redo last undone action
- `/share` - Share conversation
- `/help` - Show help

**Note**: Custom commands can override built-in commands.

## Documentation

For detailed documentation, see:
- [OpenCode Commands Docs](https://opencode.ai/docs/commands/)
- [AI Agents Reference](../../install/AI_AGENTS_REFERENCE.md)