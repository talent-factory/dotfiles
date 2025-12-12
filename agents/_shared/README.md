# Shared AI Agent Resources

**Single Source of Truth for all AI agent configurations.**

## Purpose

This directory contains commands, scripts, and templates that are **identical across all AI agents** (Claude, Augment, Copilot, Windsurf). Instead of duplicating these files 4 times, we maintain them once here and use symlinks in agent-specific directories.

## Structure

```text
_shared/
├── commands/              # Nur echte Commands (Anthropic Best Practice)
│   ├── develop/           # Development commands
│   │   ├── commit.md
│   │   ├── create-pr.md
│   │   ├── implement-task.md    # Konsolidiert (--linear Flag)
│   │   ├── check-agents.md
│   │   ├── check-commands.md
│   │   └── ruff-check.md
│   ├── project/           # Project management commands
│   │   ├── create-prd.md
│   │   └── create-plan.md       # Konsolidiert (--linear Flag)
│   └── skills/            # Skill builder system
│       ├── build-skill.md
│       ├── package-skill.md
│       ├── scripts/       # Python validation scripts
│       └── templates/     # Skill templates
│
├── references/            # Support-Dokumentation (Progressive Disclosure)
│   ├── commit/            # Referenz-Docs für /commit
│   │   ├── best-practices.md
│   │   ├── commit-types.md
│   │   ├── pre-commit-checks.md
│   │   └── troubleshooting.md
│   ├── create-pr/         # Referenz-Docs für /create-pr
│   │   ├── code-formatting.md
│   │   ├── commit-workflow.md
│   │   ├── pr-template.md
│   │   └── troubleshooting.md
│   ├── create-plan/       # Referenz-Docs für /create-plan
│   │   ├── agent-mapping.md
│   │   ├── best-practices.md
│   │   ├── filesystem.md      # Filesystem-spezifisch (Templates)
│   │   ├── linear-integration.md  # Linear-spezifisch
│   │   └── task-breakdown.md
│   ├── create-prd/        # Referenz-Docs für /create-prd
│   │   ├── best-practices.md
│   │   ├── sections-guide.md
│   │   └── templates.md
│   └── implement-task/    # Referenz-Docs für /implement-task
│       ├── best-practices.md
│       ├── filesystem.md      # Filesystem-spezifisch
│       ├── linear.md          # Linear-spezifisch
│       ├── troubleshooting.md
│       └── workflow.md
│
└── README.md              # This file
```

### Vorteile dieser Struktur (Anthropic Best Practices)

- **Saubere Trennung**: Commands enthalten nur die Hauptlogik
- **Progressive Disclosure**: Details werden bei Bedarf nachgeladen
- **Bessere Performance**: Kürzere Command-Dateien = schnellere Verarbeitung
- **Klar definierte Pfade**: `../../references/<command>/` für alle Referenzen

## How It Works

### Agent-Specific Directories

Each AI agent has its own directory under `agents/`:

- `agents/claude/` - Claude Code commands & agents
- `agents/augment/` - Augment commands
- `agents/copilot/` - GitHub Copilot prompts
- `agents/windsurf/` - Windsurf workflows

### Symlinks

Agent directories use **symlinks** pointing to `_shared/commands/`:

```bash
# Claude, Augment, Windsurf
agents/claude/commands/develop -> ../../_shared/commands/develop
agents/augment/commands/develop -> ../../_shared/commands/develop

# Copilot uses .prompt.md naming convention
agents/copilot/prompts/commit.prompt.md -> ../../_shared/commands/develop/commit.md
```

### Agent-Specific Content

Only content that is **unique** to an agent stays in its directory:

**Claude** (`agents/claude/agents/`):
- `code-reviewer.md`
- `agent-expert.md`
- `skill-builder/` - Specialized skill builder agents

**Augment/Copilot/Windsurf**: Currently no agent-specific content.

## Benefits

1. **DRY Principle**: No duplication, single source of truth
2. **Easy Maintenance**: Update once, applies everywhere
3. **Consistency**: All agents use identical commands
4. **Reduced Repo Size**: ~120 fewer duplicate files
5. **Clear Ownership**: Shared vs. agent-specific is obvious

## Editing Shared Commands

When editing files in `_shared/`:

1. **Changes apply to ALL agents** automatically via symlinks
2. **Test with all agents** if making breaking changes
3. **Update version numbers** in command frontmatter if needed
4. **Document in CHANGELOG.md** for tracking

## Adding New Commands

### For All Agents

1. Create command in `_shared/commands/<category>/`
2. Installer will automatically symlink for all agents
3. No agent-specific setup needed

### For One Agent Only

1. Create command in `agents/<agent-name>/commands/`
2. Do NOT symlink, keep it isolated
3. Document why it's agent-specific

## File Naming Conventions

### Standard (Claude, Augment, Windsurf)

```text
command-name.md
```

### Copilot

```text
command-name.prompt.md
```

The installer handles renaming via symlinks:

```bash
# Installer creates:
ln -s ../../_shared/commands/develop/commit.md \
      agents/copilot/prompts/commit.prompt.md
```

## Installation

The installer (`install.sh` / `install.ps1`) automatically:

1. Symlinks `_shared/commands/` to agent directories
2. Handles naming conventions (`.md` vs `.prompt.md`)
3. Verifies symlink integrity
4. Reports any issues

## Troubleshooting

### Broken Symlinks

**Symptom**: Command not found or empty

**Fix**:
```bash
./install.sh --verify-symlinks
```

### Accidental Edits to Symlinked Files

**Issue**: Editing a symlink edits the source file

**Solution**: This is correct behavior! Changes propagate to all agents.

### Need Agent-Specific Variation

If a command needs to differ per agent:

1. Remove from `_shared/`
2. Create separate copies in each agent directory
3. Document the reason in commit message

## Architecture Decision

**Why this approach?**

- **Before**: 160+ duplicate files across 4 agent directories
- **After**: ~40 unique files + symlinks
- **Maintenance**: 1 edit instead of 4
- **Consistency**: Impossible to have version drift

**Trade-offs**:

- ✅ Massive reduction in duplication
- ✅ Single source of truth
- ✅ Easy maintenance
- ⚠️ All agents get same updates (usually good!)
- ⚠️ Symlinks can confuse some editors (rare)

## Version History

- **v3.1.0** (2024-11-18): Introduced `_shared/` DRY architecture
- **v3.0.0** (2024-11): Multi-agent system with duplication
- **v2.0.0** (2024-10): Progressive disclosure pattern

---

**Maintainer**: See [CONTRIBUTING.md](../../CONTRIBUTING.md)
**License**: MIT
