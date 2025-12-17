# Installation Guide

Comprehensive installation guide for AI agent dotfiles supporting Augment Code, Claude Code, GitHub Copilot, and Windsurf.

## Table of Contents

- [Quick Start](#quick-start)
- [Supported AI Agents](#supported-ai-agents)
- [Installation Modes](#installation-modes)
- [Installation Methods](#installation-methods)
- [Usage Examples](#usage-examples)
- [Platform Support](#platform-support)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

```bash
# Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Interactive installation (recommended)
./install.sh --interactive

# Or install with defaults
./install.sh --agents-only
```

---

## Supported AI Agents

All four AI agents support both **Home** (user-space) and **Workspace** (project-specific) installations:

| AI Agent | Home Directory (macOS) | Home Directory (Windows) | Workspace Directory |
|----------|------------------------|--------------------------|---------------------|
| **Augment Code** | `~/.augment/commands/` | `%USERPROFILE%\.augment\commands\` | `./.augment/commands/` |
| **Claude Code** | `~/.claude/commands/` & `agents/` | `%USERPROFILE%\.claude\commands\` & `agents\` | `./.claude/commands/` & `agents/` |
| **GitHub Copilot** | `~/Library/Application Support/Code/User/prompts` | `%APPDATA%\Code\User\prompts` | `./.github/prompts/` |
| **Windsurf** | `~/.codeium/windsurf/global_workflows` | `%USERPROFILE%\.codeium\windsurf\global_workflows` | `./.windsurf/workflows/` |

**See also**: [AI Agents Reference](install/AI_AGENTS_REFERENCE.md) for detailed documentation.

---

## Installation Modes

### 1. Full Installation (Default)

Installs shell configurations, git, vim, AND AI agents:

```bash
./install.sh
```

**Installs**:
- Shell configurations (`~/.zshrc`, `~/.bashrc`, etc.)
- Git configurations (`~/.gitconfig`, `~/.gitignore_global`)
- Vim configuration (`~/.vimrc`)
- AI agent configurations (interactive or with defaults)

---

### 2. AI Agents Only

Skips shell/git/vim installation, focuses only on AI agents:

```bash
# Non-interactive (installs Claude Code by default)
./install.sh --agents-only

# Interactive (choose agents)
./install.sh --interactive
```

---

### 3. Dry-run Mode

Preview what would be installed without making changes:

```bash
./install.sh --dry-run
./install.sh --dry-run --interactive
./install.sh --dry-run --agents-only
```

---

## Installation Methods

### Symlink (Recommended)

Creates symbolic links from home/workspace to repository:

**Advantages**:
- Changes to repository immediately reflected
- Easy to update (`git pull`)
- Best for active development

**Disadvantages**:
- Requires repository to stay in place
- Broken symlinks if repository moves

```bash
# Symlink is the default method
./install.sh --interactive
# → Select "Symlink (recommended)" when prompted
```

---

### Copy

Copies files from repository to target locations:

**Advantages**:
- Independent of repository location
- Safer for production use
- Can delete repository after installation

**Disadvantages**:
- Updates require reinstallation
- Harder to maintain

```bash
./install.sh --interactive
# → Select "Copy files" when prompted
```

---

## Git Configuration

The installer automatically configures Git with your personal information.

### First-Time Setup

During installation, you'll be prompted for:
- **Full Name**: Your name for Git commits
- **Email Address**: Your email for Git commits

```bash
./install.sh

# Prompts:
# Please enter your Git user information:
#   Full Name: John Doe
#   Email: john.doe@example.com
```

### Existing Configuration

If Git is already configured, the installer will:
- Detect existing configuration
- Skip prompting if valid values exist
- Only prompt if placeholder values (`YOUR_NAME`, `YOUR_EMAIL`) are found

### Manual Configuration

To configure Git manually after installation:

```bash
# Set your name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify configuration
git config --global --list
```

### Template System

The repository uses a template-based approach:
- `git/gitconfig.template` - Template with placeholders
- `git/gitconfig` - Generated during installation with your information

**See**: [git/README.md](git/README.md) for detailed Git configuration documentation.

---

## Usage Examples

### Example 1: First-time Setup (Recommended)

```bash
# Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Interactive installation
./install.sh --interactive
```

**Interactive Prompts**:
1. **Installation Target**: Choose "Home directory" for global setup
2. **Agent Selection**: Select agents you use (e.g., Claude Code, Augment Code)
3. **Installation Method**: Choose "Symlink (recommended)"
4. **Confirm**: Review plan and confirm

---

### Example 2: Project-specific Installation

Install AI agent configurations only for a specific project:

```bash
cd /path/to/your/project

# Interactive workspace installation
~/.dotfiles/install.sh --interactive
```

**Interactive Prompts**:
1. **Installation Target**: Choose "Current workspace"
2. **Agent Selection**: Select agents (e.g., Claude Code, Copilot)
3. **Installation Method**: Choose "Copy files" (to commit to repo)
4. **Confirm**: Review and install

---

### Example 3: Install All Agents Globally

```bash
cd ~/.dotfiles

./install.sh --interactive
```

**Selections**:
- Target: **Home directory**
- Agents: Select **all four** (Augment, Claude, Copilot, Windsurf)
- Method: **Symlink**

---

### Example 4: Preview Installation

```bash
# Dry-run to see what would be installed
./install.sh --dry-run --interactive

# Or preview default installation
./install.sh --dry-run --agents-only
```

---

### Example 5: Install Only Specific Agents

The interactive mode allows you to select exactly which agents to install:

```bash
./install.sh --interactive
```

Then:
1. Choose installation target
2. Toggle only the agents you want (e.g., just Claude and Augment)
3. Confirm installation

---

## Installation Targets

### Home Directory

**When to use**:
- Personal development machine
- Want configurations available globally
- Consistent setup across all projects

**Location** (macOS/Linux):
```
~/.augment/commands/
~/.claude/commands/ and ~/.claude/agents/
~/Library/Application Support/Code/User/prompts
~/.codeium/windsurf/global_workflows
```

---

### Workspace Directory

**When to use**:
- Team-shared configurations
- Project-specific commands
- Want to commit configs to version control

**Location**:
```
./.augment/commands/
./.claude/commands/ and ./.claude/agents/
./.github/prompts/
./.windsurf/workflows/
```

---

### Both

Install to both home and workspace for maximum flexibility:
- Home configurations as defaults
- Workspace configurations for project-specific overrides

---

## Platform Support

### macOS

✅ **Fully supported**

All features work out-of-the-box:
- Symlink installation
- Copy installation
- All four AI agents

```bash
./install.sh --interactive
```

---

### Linux

✅ **Fully supported**

Same as macOS. Paths may differ slightly:
- Copilot: `~/.config/Code/User/prompts` (instead of `~/Library/...`)

```bash
./install.sh --interactive
```

---

### Windows

✅ **Fully supported** (PowerShell installer)

The PowerShell installer (`install.ps1`) provides full support for all agents on Windows.

```powershell
# Interactive installation
.\install.ps1 -Interactive
```

#### Symlinks on Windows

Symlinks on Windows require either **Administrator rights** or **Developer Mode**. The installer automatically detects and handles both scenarios.

**Option 1: Enable Developer Mode (Recommended)**

Developer Mode allows symlinks without Administrator rights:

```powershell
# Enable Developer Mode (no admin required)
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1 -Type DWord
```

Then **restart PowerShell** and run the installer:

```powershell
.\install.ps1 -Interactive
# → Select "Symlink (recommended)" when prompted
```

**Option 2: Run as Administrator**

If you prefer not to enable Developer Mode:

```powershell
# Right-click PowerShell → "Run as Administrator"
.\install.ps1 -Interactive
# → Select "Symlink (recommended)" when prompted
```

**Option 3: Use Copy Method**

If you don't want to enable Developer Mode or run as Admin:

```powershell
.\install.ps1 -Interactive
# → Select "Copy files" when prompted
```

#### Automatic Fallback

The installer automatically falls back to **Copy** if symlinks fail, so installation will always succeed regardless of permissions.

---

## Command-Line Options

```bash
./install.sh [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `--interactive`, `-i` | Interactive agent selection |
| `--agents-only` | Install only AI agents (skip shell/git/vim) |
| `--skip-legacy` | Skip shell/git/vim installation |
| `--dry-run`, `-n` | Preview installation (no changes) |
| `--help`, `-h` | Show help message |

### Examples

```bash
# Interactive mode
./install.sh --interactive

# Default installation with dry-run
./install.sh --dry-run

# Only agents, no shell/git/vim
./install.sh --agents-only

# Skip legacy, interactive agents
./install.sh --skip-legacy --interactive
```

---

## Post-Installation

### 1. Restart Terminal

After installation, restart your terminal or source shell configuration:

```bash
# For zsh
source ~/.zshrc

# For bash
source ~/.bashrc
```

---

### 2. Verify Installation

Check that agents are installed correctly:

```bash
# Claude Code
ls -la ~/.claude/commands
ls -la ~/.claude/agents

# Augment Code
ls -la ~/.augment/commands

# GitHub Copilot (macOS)
ls -la ~/Library/Application\ Support/Code/User/prompts

# Windsurf
ls -la ~/.codeium/windsurf/global_workflows
```

---

### 3. Test Commands

**Claude Code**:
```bash
# In Claude Code, try:
/commit
/create-pr
```

**Augment Code**:
```bash
# In Augment, try:
/commit
```

**GitHub Copilot**:
1. Open VS Code
2. Add to `.vscode/settings.json`:
   ```json
   {
     "chat.promptFiles": true
   }
   ```
3. Restart VS Code
4. Prompts should be available in Copilot Chat

**Windsurf**:
```bash
# In Windsurf Cascade, try:
/<workflow-name>
```

---

## Troubleshooting

### Installation fails with "permission denied"

**On macOS/Linux**:
```bash
# Ensure install.sh is executable
chmod +x install.sh

# Then retry
./install.sh
```

---

### Symlinks not working on Windows

**Issue**: Windows requires Administrator rights or Developer Mode for symlinks.

**Solutions**:

1. **Enable Developer Mode via PowerShell (Recommended)**:

   Run this command in PowerShell (no admin required):
   ```powershell
   New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Force | Out-Null
   Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1 -Type DWord
   ```

   Then **restart PowerShell** and run the installer:
   ```powershell
   .\install.ps1 -Interactive
   ```

2. **Enable Developer Mode via Settings** (Windows 10/11):
   - Settings → System → For developers → Developer Mode (toggle on)
   - Restart PowerShell
   - Run installer

3. **Run as Administrator**:
   - Right-click PowerShell → "Run as Administrator"
   - Run: `.\install.ps1 -Interactive`
   - Select "Symlink (recommended)" when prompted

4. **Use Copy instead** (no permissions needed):
   ```powershell
   .\install.ps1 -Interactive
   # → Select "Copy files" method
   ```

**Note**: The installer automatically falls back to Copy if symlinks fail, so installation will always succeed.

---

### Commands not showing up in IDE

**Claude Code**:
- Restart Claude Code
- Check: `ls ~/.claude/commands`

**Augment Code**:
- Restart Augment
- Check: `ls ~/.augment/commands`

**GitHub Copilot**:
- Enable in workspace settings: `"chat.promptFiles": true`
- Restart VS Code

**Windsurf**:
- Restart Windsurf
- Check: `ls ~/.codeium/windsurf/global_workflows`

---

### "Source not found" error

**Issue**: Repository moved or deleted after symlink installation.

**Solutions**:
1. Move repository back to original location
2. Reinstall with correct path:
   ```bash
   cd /correct/path/to/dotfiles
   ./install.sh --interactive
   ```
3. Or use copy method instead of symlink

---

### Want to uninstall

**Manual Uninstall**:
```bash
# Backup first (optional)
mv ~/.claude ~/.claude.backup
mv ~/.augment ~/.augment.backup
mv ~/Library/Application\ Support/Code/User/prompts ~/prompts.backup
mv ~/.codeium/windsurf/global_workflows ~/workflows.backup

# Remove installations
rm -rf ~/.claude
rm -rf ~/.augment
rm -rf ~/Library/Application\ Support/Code/User/prompts
rm -rf ~/.codeium/windsurf/global_workflows
```

**Restore from backup** (if installation created one):
```bash
# Backups are stored with timestamp
ls -la ~/.dotfiles_backup_*

# Restore specific backup
mv ~/.dotfiles_backup_YYYYMMDD_HHMMSS/.claude ~/
```

---

## Update dotfiles

### For Symlink Installation

Simply pull latest changes:
```bash
cd ~/.dotfiles
git pull origin main

# Changes immediately available (symlinks point to repo)
```

---

### For Copy Installation

Reinstall to get updates:
```bash
cd ~/.dotfiles
git pull origin main
./install.sh --interactive
```

---

## Advanced Usage

### Install to Custom Location

```bash
# Set custom dotfiles directory
export DOTFILES_DIR="/custom/path/to/dotfiles"
./install.sh
```

---

### Debug Mode

Enable debug output to troubleshoot issues:

```bash
DEBUG=true ./install.sh --dry-run --interactive
```

---

### Selective Agent Installation

The interactive mode allows installing only specific agents. This is useful when you only use a subset of the supported agents.

---

## Next Steps

- **Customize commands**: Edit files in `agents/<agent-name>/`
- **Add new commands**: Create new `.md` files in respective directories
- **Share with team**: Commit workspace installations to version control
- **Read agent docs**: See [AI_AGENTS_REFERENCE.md](install/AI_AGENTS_REFERENCE.md)

---

## Support

For issues or questions:
1. Check [Troubleshooting](#troubleshooting) section
2. Review [AI Agents Reference](install/AI_AGENTS_REFERENCE.md)
3. Check agent-specific READMEs in `agents/*/README.md`
4. Open an issue on GitHub

---

**Last Updated**: December 2025
**Version**: 2.1
**Windows Support**: ✅ Full PowerShell installer with Developer Mode support
