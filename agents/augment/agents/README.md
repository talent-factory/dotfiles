# Augment Code Subagents

This directory contains Augment Code subagents - specialized AI assistants for focused tasks.

## What are Subagents?

Subagents are specialized AI personas with specific expertise that can be invoked for focused tasks such as:
- Code review
- Test generation
- Documentation writing
- Security auditing
- Performance optimization
- And more...

## Structure

Each subagent is a Markdown file (`.md`) with YAML frontmatter:

```yaml
---
name: agent-identifier
description: Purpose of the agent
color: purple
model: claude-sonnet-4-5
---

# Agent instructions in markdown format
```

## Required Fields

- `name` - Unique identifier for the agent (kebab-case)

## Optional Fields

- `description` - Brief description of the agent's purpose
- `color` - ANSI color for CLI display (see available colors below)
- `model` - LLM to use (defaults to CLI default if omitted)

## Available Colors

- `blue` - Development/coding tasks
- `green` - Testing/validation
- `red` - Security/critical tasks
- `yellow` - Documentation
- `purple` - Research/analysis
- `orange` - Build/deployment
- `cyan` - Data/database
- `magenta` - UI/UX

## Usage

After installation, subagents can be invoked in Augment Code:

1. Use the Task tool with the subagent name
2. Reference the agent in your prompt (e.g., "use the code-review agent")

## Creating Subagents

You can create your own subagents or copy existing ones from:
- `agents/claude/agents/` - Claude Code subagents (compatible)
- Community repositories

**Note**: Augment Code can read Claude Code agents from `.claude/agents/` for cross-compatibility.

## Installation

Subagents are automatically installed when you run:

```bash
./install.sh --interactive
```

Or manually:

```bash
# Symlink (recommended)
ln -sf /path/to/dotfiles/agents/augment/agents ~/.augment/agents

# Copy
cp -r /path/to/dotfiles/agents/augment/agents ~/.augment/agents
```

## Documentation

For detailed documentation, see:
- [Augment Subagents Docs](https://docs.augmentcode.com/cli/subagents)
- [agents/augment/README.md](../README.md)
- [AI Agents Reference](../../../install/AI_AGENTS_REFERENCE.md)

## Examples

See `agents/claude/agents/` for example subagents that are compatible with Augment Code.
