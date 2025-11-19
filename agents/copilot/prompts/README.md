# GitHub Copilot Prompts

**⚠️ This directory is managed by the installer.**

## How It Works

GitHub Copilot requires `.prompt.md` extension for prompt files, while our shared commands use `.md`.

The installer automatically:

1. **Reads** from `agents/_shared/commands/` (`.md` files)
2. **Creates** individual symlinks in this directory
3. **Renames** top-level files to `.prompt.md`

### Example Structure

```text
After installation:

prompts/
├── check-agents.prompt.md → ../../_shared/commands/develop/check-agents.md
├── check-commands.prompt.md → ../../_shared/commands/develop/check-commands.md
├── commit.prompt.md → ../../_shared/commands/develop/commit.md
├── commit/                  # Subdirectory (no rename)
│   ├── best-practices.md → ../../_shared/commands/develop/commit/best-practices.md
│   ├── commit-types.md → ../../_shared/commands/develop/commit/commit-types.md
│   └── ...
├── create-pr.prompt.md → ../../_shared/commands/develop/create-pr.md
└── ...
```

### Why This Approach?

- **DRY Principle**: Single source of truth in `_shared/commands/`
- **Naming Convention**: Copilot expects `.prompt.md`, others use `.md`
- **Automatic**: Installer handles all renaming
- **Consistent**: All agents use same shared content

### Manual Installation

If you need to set this up manually:

```bash
cd agents/copilot/prompts
find ../../_shared/commands -name "*.md" -type f | while read -r file; do
    # Top-level files get .prompt.md extension
    # Subdirectory files keep .md extension
    # ... (see install/agents/copilot.sh for details)
done
```

### Updating

When new commands are added to `_shared/commands/`, re-run the installer:

```bash
./install.sh
```

The installer will create symlinks for new files automatically.

---

**Maintained by**: Installer (automated)
**Source**: `agents/_shared/commands/`
**Convention**: `.prompt.md` for top-level, `.md` for subdirectories
