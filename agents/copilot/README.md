# GitHub Copilot Configuration

This directory contains GitHub Copilot prompt files that can be installed to:
- **Home directory (macOS)**: `~/Library/Application Support/Code/User/prompts`
- **Home directory (Windows)**: `%APPDATA%\Code\User\prompts`
- **Workspace directory**: `./.github/prompts/`

## Structure

```
copilot/
└── prompts/          # Prompt files
    └── (your prompts here)
```

## Installation

Use the installer script from the repository root:

```bash
# Interactive installation
./install.sh --interactive

# Or manually copy (macOS/Linux)
cp -r agents/copilot/prompts/* ~/Library/Application\ Support/Code/User/prompts/

# Or manually copy (Windows PowerShell)
Copy-Item -Path "agents\copilot\prompts\*" -Destination "$env:APPDATA\Code\User\prompts\" -Recurse
```

## File Format

⚠️ **Important**: GitHub Copilot uses a unique file extension: `.prompt.md` (not `.md`)

```markdown
<!-- code-review.prompt.md -->

You are a code reviewer. Focus on security, performance, and best practices.
```

**Note**: Frontmatter is **not** supported by GitHub Copilot.

## Activation

To enable prompt files in your workspace, add to `.vscode/settings.json`:

```json
{
  "chat.promptFiles": true
}
```

## Usage

After installation and activation, prompt files are automatically available in:
- VS Code GitHub Copilot Chat
- JetBrains IDEs with GitHub Copilot plugin

## Features

- **Workspace-specific**: Project-level customizations
- **User-level**: Global prompts across all projects
- **File name conventions**: Can contain alphanumeric characters and spaces

## Limitations

- Requires VS Code or JetBrains IDE
- Must enable `chat.promptFiles` setting
- No YAML frontmatter support
- Only `.prompt.md` extension recognized

## Documentation

For detailed documentation, see:
- [GitHub Copilot Docs](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)
- [AI Agents Reference](../../install/AI_AGENTS_REFERENCE.md)
