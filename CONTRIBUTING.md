# Contributing to AI Agent Dotfiles

Thank you for your interest in contributing! This document provides guidelines for contributing to this open-source project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## Getting Started

### Prerequisites

- **macOS/Linux**: Bash 3.2+, Git
- **Windows**: PowerShell 5.1+, Git
- One or more AI coding assistants:
  - Augment Code
  - Claude Code
  - GitHub Copilot (VS Code)
  - Windsurf IDE

### Fork and Clone

1. **Fork** the repository on GitHub
2. **Clone** your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/dotfiles.git
   cd dotfiles
   ```
3. **Add upstream** remote:
   ```bash
   git remote add upstream https://github.com/talent-factory/dotfiles.git
   ```

### Installation for Development

```bash
# macOS/Linux
./install.sh --dry-run  # Preview changes
./install.sh            # Install

# Windows
.\install.ps1 -DryRun   # Preview changes
.\install.ps1           # Install
```

## Development Workflow

### Branch Strategy

**Important**: All external contributors must use feature branches and submit Pull Requests.

#### For Contributors (External Developers)

1. **Create a feature branch** from `develop`:
   ```bash
   git checkout develop
   git pull upstream develop
   git checkout -b feature/your-feature-name
   ```

2. **Branch naming conventions**:
   - `feature/` - New features (e.g., `feature/zsh-agent-support`)
   - `fix/` - Bug fixes (e.g., `fix/windows-symlink-fallback`)
   - `docs/` - Documentation only (e.g., `docs/improve-installation-guide`)
   - `refactor/` - Code refactoring (e.g., `refactor/modularize-installer`)
   - `test/` - Test additions/changes (e.g., `test/add-powershell-tests`)

3. **Make your changes** following our coding standards

4. **Test thoroughly** on all supported platforms (if possible)

5. **Commit** using our commit message format (see below)

6. **Push** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request** to the `develop` branch

#### For Maintainers

The project maintainer may work directly on the `develop` branch but should still create PRs for significant changes to maintain code review quality.

### Syncing with Upstream

Keep your fork up-to-date:

```bash
git checkout develop
git fetch upstream
git merge upstream/develop
git push origin develop
```

## Commit Guidelines

We use **Emoji Conventional Commits** for clear, semantic git history.

### Commit Message Format

```
<emoji> <type>: <subject>

[optional body]

[optional footer]
```

### Commit Types

| Emoji | Type | Description | Example |
|-------|------|-------------|---------|
| ✨ | `feat` | New feature | `✨ feat: Add Zsh agent support` |
| 🐛 | `fix` | Bug fix | `🐛 fix: Correct Windows path detection` |
| 📚 | `docs` | Documentation | `📚 docs: Update installation guide` |
| ♻️ | `refactor` | Code refactoring | `♻️ refactor: Simplify installer logic` |
| 🧪 | `test` | Tests | `🧪 test: Add PowerShell installer tests` |
| 🔧 | `chore` | Build/tools | `🔧 chore: Update dependencies` |
| 💎 | `style` | Code formatting | `💎 style: Fix indentation` |
| ⚡ | `perf` | Performance | `⚡ perf: Optimize backup function` |

**Complete reference**: See `agents/claude/commands/develop/commit/commit-types.md`

### Commit Message Rules

1. **Use imperative mood**: "Add feature" not "Added feature"
2. **Capitalize first letter** after emoji
3. **No period** at the end of subject line
4. **Subject ≤ 72 characters**
5. **Separate subject from body** with blank line
6. **Wrap body at 72 characters**

### Examples

**Good ✅**:
```
✨ feat: Add interactive agent selection

Implements multi-select prompt allowing users to choose which
AI agents to install. Supports Augment, Claude, Copilot, and
Windsurf with visual feedback.

Closes #42
```

**Bad ❌**:
```
Updated stuff
```

## Pull Request Process

### Before Submitting

1. **Update documentation** if you changed APIs or added features
2. **Test on all platforms** (macOS, Linux, Windows if possible)
3. **Run validation checks**:
   ```bash
   # Bash installer
   ./install.sh --dry-run

   # PowerShell installer
   .\install.ps1 -DryRun
   ```
4. **Ensure commit messages** follow guidelines
5. **Rebase on latest develop**:
   ```bash
   git fetch upstream
   git rebase upstream/develop
   ```

### PR Template

Use this template for your Pull Request:

```markdown
## Description
[Clear description of what this PR does]

## Motivation
[Why is this change needed? What problem does it solve?]

## Changes
- Change 1
- Change 2

## Testing
- [ ] Tested on macOS
- [ ] Tested on Linux
- [ ] Tested on Windows
- [ ] Tested with Augment Code
- [ ] Tested with Claude Code
- [ ] Tested with GitHub Copilot
- [ ] Tested with Windsurf

## Screenshots (if applicable)
[Add screenshots for UI/output changes]

## Breaking Changes
[List any breaking changes or "None"]

## Related Issues
Closes #[issue number]
```

### PR Review Process

1. **Automated checks** must pass (if configured)
2. **Maintainer review** required
3. **Changes requested**: Address feedback and push updates
4. **Approval**: PR will be merged to `develop`
5. **Release**: Changes included in next release

### PR Guidelines

- **One PR per feature/fix**: Don't mix unrelated changes
- **Small PRs preferred**: 150-400 lines ideal, max 800 lines
- **Respond to feedback** within 7 days
- **Keep PR updated** with latest `develop`

## Testing

### Manual Testing Checklist

**Installer Testing**:
- [ ] Dry-run mode works
- [ ] Interactive mode shows all prompts
- [ ] Agent selection works (single/multiple)
- [ ] Home installation works
- [ ] Workspace installation works
- [ ] Both installation works
- [ ] Symlink method works
- [ ] Copy method works
- [ ] Backup creation works
- [ ] Error handling works

**Platform-Specific**:
- **macOS**: Test with standard Terminal and iTerm2
- **Linux**: Test with Bash 3.2+ and Bash 4.0+
- **Windows**: Test with PowerShell 5.1 and PowerShell 7+

**Agent-Specific**:
- **Claude Code**: Commands and agents appear in IDE
- **Augment Code**: Commands available in `.augment/commands/`
- **GitHub Copilot**: Prompts work in VS Code (`chat.promptFiles: true`)
- **Windsurf**: Workflows appear in global workflows

### Testing Documentation Updates

- [ ] Markdown is valid (no broken links)
- [ ] Code examples are correct
- [ ] Installation steps work as written
- [ ] Screenshots are up-to-date

## Documentation

### What to Document

**Required for new features**:
- Update `README.md` with user-facing information
- Update `INSTALLATION.md` if installation changed
- Add inline comments for complex logic
- Create/update agent READMEs if adding agents

**Optional but recommended**:
- Add examples to relevant docs
- Update `CLAUDE.md` for developer-specific changes
- Add troubleshooting entries if applicable

### Documentation Style

- **User-facing docs** (README.md): Clear, concise, example-driven
- **Developer docs** (CLAUDE.md): Technical, detailed, architecture-focused
- **Avoid redundancy**: Reference other docs instead of duplicating
- **Use code blocks**: Always specify language (```bash, ```powershell)
- **Add tables**: For comparison or structured data
- **Include examples**: Both good ✅ and bad ❌ where helpful

### File Organization

```
docs/                          # General documentation
agents/<agent>/README.md       # Agent-specific docs
install/AI_AGENTS_REFERENCE.md # Technical reference
INSTALLATION.md               # Installation guide
WINDOWS_INSTALLATION.md       # Windows-specific guide
CONTRIBUTING.md               # This file
CODE_OF_CONDUCT.md            # Code of conduct
SECURITY.md                   # Security policy
```

## Questions?

- **Issues**: Open an issue for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions
- **Security**: See [SECURITY.md](SECURITY.md) for responsible disclosure

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to AI Agent Dotfiles! 🎉
