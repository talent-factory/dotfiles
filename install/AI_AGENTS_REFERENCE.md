# AI Agent Configuration Reference

Comprehensive reference for AI agent installation paths and formats.

## Supported AI Agents

All four AI agents support **both** Home (user-space) and Workspace (project-specific) installations.

### Installation Paths Overview

| AI Agent | Home Directory (macOS) | Home Directory (Windows) | Workspace Directory | File Format |
|----------|------------------------|--------------------------|---------------------|-------------|
| **Augment Code** | `~/.augment/commands/` | `%USERPROFILE%\.augment\commands\` | `./.augment/commands/` | `<name>.md` |
| **Claude Code** | `~/.claude/commands/` & `~/.claude/agents/` | `%USERPROFILE%\.claude\commands\` & `agents\` | `./.claude/commands/` & `agents/` | `<name>.md` |
| **GitHub Copilot** | `~/Library/Application Support/Code/User/prompts` | `%APPDATA%\Code\User\prompts` | `./.github/prompts/` | `<name>.prompt.md` |
| **OpenCode** | `~/.config/opencode/command/` | `%USERPROFILE%\.config\opencode\command\` | `./.opencode/command/` | `<name>.md` |
| **Windsurf** | `~/.codeium/windsurf/global_workflows` | `%USERPROFILE%\.codeium\windsurf\global_workflows` | `./.windsurf/workflows/` | `<name>.md` |
| **Antigravity** | `~/.gemini/antigravity/global_workflows` | `%USERPROFILE%\.gemini\antigravity\global_workflows` | `./.antigravity/workflows/` | `<name>.md` |

## Detailed Agent Information

### Augment Code

**Documentation**: https://docs.augmentcode.com/cli/custom-commands

**Paths**:
- **macOS Home**: `~/.augment/commands/`
- **Windows Home**: `%USERPROFILE%\.augment\commands\`
- **Workspace**: `./.augment/commands/`

**File Format**: Markdown (`.md`)

**Features**:
- Supports YAML frontmatter for metadata
- Hierarchical commands via subdirectories (e.g., `/frontend:component`)
- Claude Code compatibility (can read `.claude/commands/`)

**Priority**: Home commands take precedence over workspace commands

**Example**:
```bash
# Home installation
~/.augment/commands/commit.md → /commit

# Workspace installation
./project/.augment/commands/commit.md → /commit
```

---

### Claude Code

**Documentation**: https://code.claude.com/docs/en/slash-commands

**Paths**:
- **macOS Home**: `~/.claude/commands/` and `~/.claude/agents/`
- **Windows Home**: `%USERPROFILE%\.claude\commands\` and `agents\`
- **Workspace**: `./.claude/commands/` and `./.claude/agents/`

**File Format**: Markdown (`.md`)

**Features**:
- Separate directories for commands and agents
- Agents are specialized AI personas with specific expertise
- Supports YAML frontmatter (description, category, allowed-tools)
- Hierarchical namespace via subdirectories

**Priority**: Home commands take precedence over workspace commands

**Example**:
```bash
# Home installation
~/.claude/commands/develop/commit.md → /develop:commit
~/.claude/agents/code-reviewer.md → code-reviewer agent

# Workspace installation
./.claude/commands/commit.md → /commit
```

---

### GitHub Copilot

**Documentation**: https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot

**Paths**:
- **macOS Home**: `~/Library/Application Support/Code/User/prompts`
- **Windows Home**: `%APPDATA%\Code\User\prompts` (typically `C:\Users\<username>\AppData\Roaming\Code\User\prompts`)
- **Workspace**: `./.github/prompts/`

**File Format**: Prompt Markdown (`.prompt.md`)

**Features**:
- Unique file extension: `.prompt.md` (different from other agents)
- Requires VS Code or JetBrains IDE
- Must enable in workspace settings: `"chat.promptFiles": true`
- File names can contain alphanumeric characters and spaces

**Priority**: Workspace prompts likely take precedence (workspace-specific)

**Example**:
```bash
# Home installation (VS Code User directory)
~/Library/Application Support/Code/User/prompts/code-review.prompt.md

# Workspace installation
./.github/prompts/code-review.prompt.md
```

**Activation**:
Add to `.vscode/settings.json`:
```json
{
  "chat.promptFiles": true
}
```

---

### OpenCode

**Documentation**: https://opencode.ai/docs/commands/

**Paths**:
- **macOS/Linux Home**: `~/.config/opencode/command/`
- **Windows Home**: `%USERPROFILE%\.config\opencode\command\`
- **Workspace**: `./.opencode/command/`

**File Format**: Markdown (`.md`)

**Features**:
- Supports YAML frontmatter for metadata (`description`, `agent`, `model`, `subtask`)
- Argument placeholders (`$ARGUMENTS`, `$1`, `$2`, etc.)
- Shell output inclusion with `` !`command` `` syntax
- File references with `@path/to/file` syntax
- TUI-based interface

**Note**: Uses `command` (singular) instead of `commands` (plural)

**Example**:
```bash
# Home installation
~/.config/opencode/command/commit.md → /commit

# Workspace installation
./.opencode/command/commit.md → /commit
```

---

### Windsurf

**Documentation**: https://docs.windsurf.com/windsurf/cascade/workflows

**Paths**:
- **macOS Home**: `~/.codeium/windsurf/global_workflows`
- **Windows Home**: `%USERPROFILE%\.codeium\windsurf\global_workflows`
- **Workspace**: `./.windsurf/workflows/`

**File Format**: Markdown (`.md`)

**Features**:
- Workflows define multi-step task automation
- Git-repository-aware (searches up to git root)
- Character limit: 12,000 per workflow file
- Invoked via `/[workflow-name]`

**Priority**: Workspace workflows can override global workflows

**Search Order**:
1. Current workspace `.windsurf/workflows/`
2. Subdirectories of workspace
3. Parent directories up to git root (for git repos)
4. Global workflows `~/.codeium/windsurf/global_workflows`

**Example**:
```bash
# Global installation
~/.codeium/windsurf/global_workflows/deploy.md → /deploy

# Workspace installation
./.windsurf/workflows/deploy.md → /deploy (overrides global)
```

---

### Antigravity

**Note**: Antigravity is a fork of Windsurf and uses the same workflow format.

**Paths**:
- **macOS Home**: `~/.gemini/antigravity/global_workflows`
- **Windows Home**: `%USERPROFILE%\.gemini\antigravity\global_workflows`
- **Workspace**: `./.antigravity/workflows/`

**File Format**: Markdown (`.md`)

**Features**: Same as Windsurf (see above)

**Source**: Uses `agents/antigravity` symlink → `agents/windsurf`

---

## Installation Priority & Conflict Resolution

### Priority Order

When the same command/prompt exists in multiple locations:

1. **Augment & Claude**: Home > Workspace
2. **Copilot**: Workspace likely takes precedence (per-project customization)
3. **Windsurf & Antigravity**: Workspace > Parent dirs > Global

### Best Practices

**Home Installation**:
- Use for general-purpose, reusable commands
- Consistent across all projects
- Easier to maintain and update centrally

**Workspace Installation**:
- Use for project-specific commands
- Can be committed to version control
- Team-shared configurations
- Overrides for project requirements

**Hybrid Approach**:
- Install common commands in Home
- Project-specific overrides in Workspace
- Document which commands are workspace-specific

---

## Cross-Platform Path Translations

### macOS Paths

```bash
~/.augment/commands/
~/.claude/commands/ and ~/.claude/agents/
~/Library/Application Support/Code/User/prompts
~/.config/opencode/command
~/.codeium/windsurf/global_workflows
~/.gemini/antigravity/global_workflows
```

### Windows Paths

```powershell
%USERPROFILE%\.augment\commands\
%USERPROFILE%\.claude\commands\ and agents\
%APPDATA%\Code\User\prompts
%USERPROFILE%\.config\opencode\command
%USERPROFILE%\.codeium\windsurf\global_workflows
%USERPROFILE%\.gemini\antigravity\global_workflows
```

**Typical Windows Expansions**:
- `%USERPROFILE%` → `C:\Users\<username>`
- `%APPDATA%` → `C:\Users\<username>\AppData\Roaming`

---

## File Format Comparison

| Agent | Extension | Frontmatter | Special Features |
|-------|-----------|-------------|------------------|
| Augment | `.md` | YAML (optional) | Claude-compatible |
| Claude | `.md` | YAML (optional) | Agents + Commands |
| Copilot | `.prompt.md` | No | VS Code integration required |
| OpenCode | `.md` | YAML (optional) | TUI, `$ARGUMENTS`, `` !`shell` ``, `@file` |
| Windsurf | `.md` | No | 12k character limit |
| Antigravity | `.md` | No | 12k character limit (Windsurf fork) |

---

## References

- [Augment Code Docs](https://docs.augmentcode.com/cli/custom-commands)
- [Claude Code Docs](https://code.claude.com/docs/en/slash-commands)
- [GitHub Copilot Docs](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)
- [OpenCode Docs](https://opencode.ai/docs/commands/)
- [Windsurf Docs](https://docs.windsurf.com/windsurf/cascade/workflows)

---

**Last Updated**: November 2024
**Version**: 2.0
