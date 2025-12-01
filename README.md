# AI Agent Dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-blue)]()
[![AI Agents](https://img.shields.io/badge/AI%20Agents-5-green)]()

**Professional dotfiles and AI agent configurations for students and developers.**

Cross-platform installation system supporting Augment Code, Claude Code, GitHub Copilot, Windsurf, and Antigravity with comprehensive commands, agents, and best practices.

---

## ✨ Features

- **🤖 5 AI Agents Supported**: Augment Code, Claude Code, GitHub Copilot, Windsurf, Antigravity
- **🌍 Cross-Platform**: macOS, Linux, Windows (Bash + PowerShell)
- **🎯 Dual Installation**: Home directory (global) or workspace (project-specific)
- **🔗 Flexible Methods**: Symlink (live updates) or copy (independent)
- **📦 Automated Backups**: Safe installation with automatic backups
- **📚 Comprehensive Documentation**: 12,500+ lines of guides and best practices
- **🚀 Interactive Installer**: Agent selection with visual feedback
- **⚡ Optimized Commands**: Progressive disclosure pattern for performance

---

## 🚀 Quick Start

### macOS / Linux

```bash
# Clone repository
git clone https://github.com/talent-factory/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Interactive installation
./install.sh --interactive

# Or install with defaults
./install.sh
```

### Windows

```powershell
# Clone repository
git clone https://github.com/talent-factory/dotfiles.git $env:USERPROFILE\.dotfiles
cd $env:USERPROFILE\.dotfiles

# Interactive installation
.\install.ps1 -Interactive

# Or install with defaults
.\install.ps1
```

---

## 📋 Table of Contents

- [Supported AI Agents](#supported-ai-agents)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

---

## 🤖 Supported AI Agents

| AI Agent | Home Installation | Workspace Installation | File Format |
|----------|-------------------|------------------------|-------------|
| **Augment Code** | `~/.augment/commands/` | `.augment/commands/` | `.md` |
| **Claude Code** | `~/.claude/commands/`, `agents/` | `.claude/commands/`, `agents/` | `.md` |
| **GitHub Copilot** | `~/Library/Application Support/Code/User/prompts` (macOS)<br>`~/.config/Code/User/prompts` (Linux)<br>`%APPDATA%/Code/User/prompts` (Windows) | `.github/prompts/` | `.prompt.md` |
| **Windsurf** | `~/.codeium/windsurf/global_workflows` | `.windsurf/workflows/` | `.md` |
| **Antigravity** | `~/.gemini/antigravity/global_workflows` | `.antigravity/workflows/` | `.md` |

**See [install/AI_AGENTS_REFERENCE.md](install/AI_AGENTS_REFERENCE.md) for detailed paths and configuration.**

---

## 📦 Installation

### Prerequisites

**All Platforms:**
- Git

**macOS / Linux:**
- Bash 3.2+ (pre-installed)

**Windows:**
- PowerShell 5.1+ (pre-installed on Windows 10/11)
- Optional: Developer Mode or Administrator rights (for symlinks)

### Installation Methods

#### Interactive Mode (Recommended)

Choose which agents to install and where:

```bash
# macOS/Linux
./install.sh --interactive

# Windows
.\install.ps1 -Interactive
```

**Prompts:**
1. **Installation Target**: Home / Workspace / Both
2. **Agent Selection**: Select AI agents (multi-select)
3. **Installation Method**: Symlink (recommended) or Copy
4. **Confirm**: Review plan and proceed

#### Default Installation

Install Claude Code only to home directory:

```bash
# macOS/Linux
./install.sh

# Windows
.\install.ps1
```

#### Preview Mode (Dry-run)

See what would be installed without making changes:

```bash
# macOS/Linux
./install.sh --dry-run --interactive

# Windows
.\install.ps1 -DryRun -Interactive
```

### Command-Line Options

**Bash (macOS/Linux):**
```bash
./install.sh [OPTIONS]

  --interactive, -i     Interactive agent selection
  --agents-only         Install only AI agents (skip shell/git configs)
  --skip-legacy         Skip shell/git/vim installation
  --dry-run, -n         Preview installation (no changes)
  --help, -h            Show help message
```

**PowerShell (Windows):**
```powershell
.\install.ps1 [OPTIONS]

  -Interactive          Interactive agent selection
  -AgentsOnly           Install only AI agents (skip configs)
  -SkipLegacy           Skip shell/git installation
  -DryRun               Preview installation (no changes)
  -Help                 Show help message
```

### What Gets Installed

The installer will:
- ✅ Create backups of existing configurations
- ✅ Install selected AI agent configurations
- ✅ Set up symlinks or copy files (based on your choice)
- ✅ Configure shell environments (optional)
- ✅ Install git configurations (optional)

**See [INSTALLATION.md](INSTALLATION.md) for detailed installation guide.**
**See [WINDOWS_INSTALLATION.md](WINDOWS_INSTALLATION.md) for Windows-specific instructions.**

---

## 📁 Project Structure

```
dotfiles/
├── agents/                           # AI agent configurations
│   ├── augment/                      # Augment Code commands
│   ├── claude/                       # Claude Code commands, agents & skills
│   │   ├── commands/                 # Claude Code commands (symlink to _shared)
│   │   ├── agents/                   # Claude-specific agents
│   │   └── skills/                   # Claude Code skills (PDF converter, etc.)
│   ├── copilot/                      # GitHub Copilot prompts
│   ├── windsurf/                     # Windsurf workflows
│   └── antigravity -> windsurf       # Antigravity (symlink, Windsurf fork)
│
├── install/                          # Installation system
│   ├── lib/                          # Shared libraries
│   │   ├── bash/                     # Bash common functions
│   │   └── powershell/               # PowerShell common functions
│   └── agents/                       # Agent-specific installers
│       ├── bash/                     # Bash installers
│       └── powershell/               # PowerShell installers
│
├── shell/                            # Shell configurations
│   ├── zshrc, bashrc                 # Shell configs
│   └── *.local.example               # Local config templates
│
├── git/                              # Git configurations
│   ├── gitconfig                     # Global git config
│   └── gitignore_global              # Global gitignore
│
├── install.sh                        # Bash installer (macOS/Linux)
├── install.ps1                       # PowerShell installer (Windows)
├── .env.example                      # Environment variables template
│
├── INSTALLATION.md                   # Installation guide
├── WINDOWS_INSTALLATION.md           # Windows-specific guide
├── CONTRIBUTING.md                   # Contribution guidelines
├── CODE_OF_CONDUCT.md                # Code of conduct
├── SECURITY.md                       # Security policy
└── LICENSE                           # MIT License
```

**For developers:** See [CLAUDE.md](CLAUDE.md) for detailed architecture and developer documentation.

---

## 🎯 Usage

### Claude Code Commands

After installing Claude Code configurations, the following commands are available:

| Command | Description |
|---------|-------------|
| `/commit` | Professional git commits with pre-commit checks |
| `/create-pr` | Create pull requests with branch management |
| `/project:create-prd` | Generate Product Requirements Documents |
| `/project:create-plan` | Create project plans from PRDs with Linear integration |
| `/develop:check-agents` | Validate agent configurations |
| `/develop:check-commands` | Validate command files |
| `/skills:build-skill` | Build custom Claude Code skills |

**See [CLAUDE.md](CLAUDE.md) for complete command documentation.**

### Augment Code Commands

36+ commands available after installation in Augment Code IDE.

### GitHub Copilot Prompts

VS Code workspace activation required:

```json
{
  "chat.promptFiles": true
}
```

### Windsurf & Antigravity Workflows

Global workflows automatically available in Windsurf IDE and Antigravity (Windsurf fork).

---

## 📚 Documentation

### User Guides

- **[INSTALLATION.md](INSTALLATION.md)** - Comprehensive installation guide
- **[WINDOWS_INSTALLATION.md](WINDOWS_INSTALLATION.md)** - Windows-specific instructions
- **[install/AI_AGENTS_REFERENCE.md](install/AI_AGENTS_REFERENCE.md)** - AI agent paths and configuration

### Developer Guides

- **[CLAUDE.md](CLAUDE.md)** - Claude Code integration and architecture
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Complete project overview (4,500+ lines)

### Policies

- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)** - Community guidelines
- **[SECURITY.md](SECURITY.md)** - Security policy and reporting
- **[LICENSE](LICENSE)** - MIT License

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Quick Contribution Guide

1. **Fork** the repository
2. **Create a feature branch**: `git checkout -b feature/your-feature`
3. **Make your changes** following our coding standards
4. **Test** on relevant platforms
5. **Commit** using emoji conventional commits
6. **Push** to your fork
7. **Create a Pull Request** to the `develop` branch

### Development Workflow

**External Contributors:**

- Must use feature branches
- Submit PRs to `develop` branch
- Follow emoji conventional commits format

**See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.**

---

## 🔒 Security

### Reporting Vulnerabilities

**DO NOT** create public issues for security vulnerabilities.

Use [GitHub Security Advisories](https://github.com/talent-factory/dotfiles/security/advisories) to report privately.

**See [SECURITY.md](SECURITY.md) for detailed security policy.**

### Safe Usage

- ✅ Review installation scripts before running
- ✅ Use dry-run mode to preview changes
- ✅ Keep sensitive data in `.env` (not tracked)
- ❌ Never commit API keys or credentials

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**TL;DR**: You can use, modify, and distribute this project freely. Attribution appreciated but not required.

---

## 🙏 Acknowledgments

- Inspired by [GitHub's spec-kit](https://github.com/github/spec-kit)
- Built for students and developers seeking professional AI-assisted workflows
- Community contributions welcome!

---

## 📞 Support

**Issues & Bugs:**

- Open a [GitHub Issue](https://github.com/talent-factory/dotfiles/issues)
- Use our issue templates (Bug Report, Feature Request, Documentation)

**Questions:**

- Check [INSTALLATION.md](INSTALLATION.md) troubleshooting section
- Review [CLAUDE.md](CLAUDE.md) for Claude Code specific questions
- Open a [GitHub Discussion](https://github.com/talent-factory/dotfiles/discussions)

**Security:**

- See [SECURITY.md](SECURITY.md) for responsible disclosure

---

**Version**: 3.2.0 (Multi-User Support)
**Last Updated**: November 2024
**Maintainer**: Daniel

**⭐ If this project helps you, consider giving it a star!**
