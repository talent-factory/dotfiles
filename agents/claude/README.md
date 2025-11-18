# Claude Code Configuration

This directory contains Claude Code agents and commands that can be installed to:
- **Home directory**: `~/.claude/`
- **Workspace directory**: `./.claude/`

## Structure

```
claude/
├── agents/           # AI Agents for specialized tasks
│   ├── code-reviewer.md
│   ├── markdown-syntax-formatter.md
│   └── skill-builder/
│       ├── skill-documenter-agent.md
│       ├── skill-elicitation-agent.md
│       ├── skill-generator-agent.md
│       └── skill-validator-agent.md
└── commands/         # Slash commands
    ├── develop/
    │   ├── commit.md
    │   ├── create-pr.md
    │   ├── check-agents.md
    │   └── check-commands.md
    ├── project/
    │   ├── create-prd.md
    │   └── create-plan.md
    └── skills/
        ├── build-skill.md
        └── package-skill.md
```

## Installation

Use the installer script from the repository root:

```bash
# Interactive installation
./install.sh

# Or manually symlink
ln -sf /path/to/dotfiles/agents/claude ~/.claude
```

## Commands

After installation, the following commands are available in Claude Code:

- `/commit` - Professional Git commits with pre-commit checks
- `/create-pr` - Pull requests with automatic branch creation
- `/develop:check-agents` - Validate agent configuration
- `/develop:check-commands` - Validate command configuration
- `/project:create-prd` - Create Product Requirements Documents
- `/project:create-plan` - Create project plans from PRDs

## Agents

Specialized AI agents for specific tasks:

- `code-reviewer` - Code quality and security review
- `markdown-syntax-formatter` - Markdown formatting
- `skill-builder/*` - Skill development workflow

## Documentation

For detailed documentation, see [CLAUDE.md](../../CLAUDE.md) in the repository root.
