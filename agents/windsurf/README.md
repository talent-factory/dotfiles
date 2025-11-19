# Windsurf Configuration

This directory contains Windsurf workflows that can be installed to:
- **Home directory (macOS)**: `~/.codeium/windsurf/global_workflows`
- **Home directory (Windows)**: `%USERPROFILE%\.codeium\windsurf\global_workflows`
- **Workspace directory**: `./.windsurf/workflows/`

## Structure

```
windsurf/
└── workflows/        # Workflow files
    └── (your workflows here)
```

## Installation

Use the installer script from the repository root:

```bash
# Interactive installation
./install.sh --interactive

# Or manually symlink (macOS/Linux)
ln -sf /path/to/dotfiles/agents/windsurf/workflows ~/.codeium/windsurf/global_workflows

# Or manually symlink (Windows PowerShell)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.codeium\windsurf\global_workflows" -Target "path\to\dotfiles\agents\windsurf\workflows"
```

## File Format

Workflows are Markdown files (`.md`) that define multi-step task automation:

```markdown
<!-- deploy.md -->

# Deployment Workflow

1. Run tests
2. Build application
3. Deploy to staging
4. Run smoke tests
5. Deploy to production
```

**Note**: YAML frontmatter is **not** supported by Windsurf workflows.

## Usage

After installation, workflows are invoked in Windsurf Cascade with:

```
/<workflow-name>
```

## Features

- **Multi-step automation**: Guide Cascade through complex tasks
- **Git-repository-aware**: Searches up to git root for workflows
- **Global + Local**: Combine user-level and project-level workflows
- **Character limit**: 12,000 characters per workflow

## Search Order

Windsurf searches for workflows in this order:
1. Current workspace `.windsurf/workflows/`
2. Subdirectories of workspace
3. Parent directories up to git root (for git repos)
4. Global workflows `~/.codeium/windsurf/global_workflows`

**Priority**: Workspace workflows override global workflows

## Limitations

- Maximum 12,000 characters per workflow file
- No frontmatter support
- Requires Windsurf IDE

## Documentation

For detailed documentation, see:
- [Windsurf Docs](https://docs.windsurf.com/windsurf/cascade/workflows)
- [AI Agents Reference](../../install/AI_AGENTS_REFERENCE.md)
