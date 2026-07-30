# OpenCode AI Agent Development Guidelines

## Overview

This directory contains OpenCode AI agents and custom commands for specialized development workflows. The structure supports both agent configurations and slash commands that can be used within the OpenCode TUI.

## Directory Structure

```
AGENTS.md                 # This file - development guidelines
├── agents/                # AI Agent configurations
│   ├── _shared/          # Shared components and utilities
│   ├── augment/          # Augment-specific agents
│   ├── claude/           # Claude-specific agents
│   ├── copilot/          # Copilot-specific agents
│   ├── opencode/         # OpenCode-specific agents
│   └── windsurf/         # Windsurf-specific agents
├── opencode/             # OpenCode configurations
│   ├── agent/            # Agent definition files (.md)
│   └── command/          # Custom slash commands (.md)
└── windsurf/             # Windsurf workflows and skills
```

### Agent Configurations
AI agents are defined as Markdown files with YAML frontmatter in the `agents/` subdirectories. Each agent can have specialized tools, permissions, and models.

### Custom Commands
Custom slash commands are defined in `opencode/command/` directory. These allow you to create reusable prompts that can be executed with `/command-name` in the OpenCode TUI.

## Custom Commands (agents/opencode/command/)

Custom commands are reusable prompts that can be executed as slash commands in the OpenCode TUI. They are defined as Markdown files in the `agents/opencode/command/` directory.

### Command Structure
Each command file follows this format:

```markdown
---
description: Brief description of what the command does
agent: build          # Optional: which agent should execute
model: anthropic/claude-sonnet-4-20250514  # Optional: model override
subtask: false        # Optional: force subagent invocation
---

Your prompt template here. Use $ARGUMENTS for command arguments.
```

### Command Features
- **Arguments**: Use `$ARGUMENTS` or positional parameters (`$1`, `$2`, etc.)
- **Shell output**: Include command output with `!`command syntax
- **File references**: Include files with `@filename`
- **Agent targeting**: Specify which agent should execute the command

### Available Commands
The `agents/opencode/command/` directory contains a comprehensive set of predefined commands:

#### Development Workflow Commands
- `/commit` - Generate commit messages
- `/create-pr` - Create pull requests
- `/implement-task` - Implement development tasks
- `/check` - Run code quality checks
- `/ruff-check` - Run ruff linting and formatting

#### Project Management Commands
- `/init-project` - Initialize new projects
- `/create-plan` - Create development plans
- `/create-prd` - Create product requirement documents
- `/package-skill` - Package development skills

#### Skill Development Commands
- `/build-skill` - Build agent skills
- `/create-command` - Create custom commands

#### Validation Commands
- `/check-commands` - Validate command syntax
- `/check-agents` - Validate agent configurations

### Example Usage
```bash
# In OpenCode TUI
/commit                                    # Generate commit message
/create-pr                                 # Create pull request
/implement-task "Add user authentication"  # Implement specific task
/check                                    # Run comprehensive checks
```

For detailed documentation, see: https://opencode.ai/docs/commands/

## Testing Commands

### Installation Testing
```bash
# Full installation test
./test-install.sh

# Skill validation
./agents/_shared/references/scripts/validate-skill.sh <skill-path>

# Skill trigger testing  
./agents/_shared/references/scripts/test-skill-trigger.sh <skill-path>

# Custom command validation
./opencode/command/check-commands.sh  # Validate command syntax and structure
```

### Single Test Execution
For Python-based skills: `python -m pytest tests/test_specific.py::test_function`
For Bash scripts: `bash -n script.sh` for syntax checking

## Code Style Guidelines

### Shell Scripts
- Use `#!/usr/bin/env bash` shebang
- Use `set -e` for error handling
- Follow existing function naming: `install_*`, `validate_*`, `log_*`
- Use color variables from common.sh: `$RED`, `$GREEN`, `$YELLOW`, `$BLUE`, `$MAGENTA`, `$CYAN`, `$NC`

### Python Scripts  
- Use ruff for linting, black for formatting
- Type hints required for function signatures
- Error handling with try/except blocks, not bare excepts
- Use f-strings for string formatting

### File Structure
- Scripts in `scripts/` directories
- Documentation in same directory as implementation
- Use relative imports within modules
- Follow existing directory naming patterns

### Naming Conventions
- Functions: `snake_case` with descriptive names
- Files: `kebab-case.sh` or `snake_case.py`
- Variables: `UPPER_SNAKE_CASE` for constants, `snake_case` for variables
- Error messages: Use log functions from common.sh

### Documentation
- YAML frontmatter in all .md files with required fields
- Usage examples in all executable scripts
- Comment complex logic and non-obvious workarounds