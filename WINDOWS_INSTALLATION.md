# Windows Installation Guide

PowerShell-basierte Installation für AI Agent Dotfiles auf Windows.

## Table of Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Symlinks on Windows](#symlinks-on-windows)
- [Usage Examples](#usage-examples)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

```powershell
# Clone repository
git clone https://github.com/yourusername/dotfiles.git $env:USERPROFILE\.dotfiles
cd $env:USERPROFILE\.dotfiles

# Interactive installation
.\install.ps1 -Interactive

# Or install with defaults
.\install.ps1 -AgentsOnly
```

---

## Prerequisites

### Required

- **Windows 10** or **Windows 11**
- **PowerShell 5.1** or later (pre-installed on Windows 10/11)
- **Git** for Windows

### Optional

- **Administrator rights** OR **Developer Mode** (for symlinks)
- VS Code (for GitHub Copilot prompts)
- Windsurf IDE (for workflows)

---

## Installation

### Method 1: Interactive (Recommended)

```powershell
# Open PowerShell (regular user, no admin needed)
cd $env:USERPROFILE\.dotfiles

# Run interactive installer
.\install.ps1 -Interactive
```

**Prompts:**
1. **Installation Target**: Home / Workspace / Both
2. **Agent Selection**: Select which AI agents to install
3. **Installation Method**: Symlink (recommended) or Copy
4. **Confirm**: Review plan and proceed

---

### Method 2: Default Installation

```powershell
# Install Claude Code only (to home directory)
.\install.ps1 -AgentsOnly

# Or full installation
.\install.ps1
```

---

### Method 3: Dry-run (Preview)

```powershell
# Preview what would be installed
.\install.ps1 -DryRun -Interactive

# Or preview default installation
.\install.ps1 -DryRun -AgentsOnly
```

---

## Symlinks on Windows

### Why Symlinks?

Symlinks allow configurations to update automatically when you pull changes from the repository.

### Option 1: Enable Developer Mode (Easiest)

**Windows 10/11:**
1. Open **Settings** → **Update & Security** → **For developers**
2. Enable **Developer Mode**
3. Restart terminal

**Benefits:**
- ✅ No administrator rights needed
- ✅ Symlinks work for regular users

---

### Option 2: Run as Administrator

**Steps:**
1. Right-click **PowerShell**
2. Select **Run as Administrator**
3. Navigate to dotfiles directory
4. Run install.ps1

**Disadvantages:**
- ❌ Requires admin rights every time
- ❌ Less convenient

---

### Option 3: Use Copy Instead

If symlinks don't work, the installer automatically falls back to copying files:

```powershell
# Force copy method (no symlinks)
.\install.ps1 -Interactive
# → Select "Copy files" when prompted
```

**Trade-offs:**
- ✅ No special permissions needed
- ❌ Updates require reinstallation

---

## Git Configuration

The installer automatically configures Git with your personal information.

### First-Time Setup

During installation, you'll be prompted for:
- **Full Name**: Your name for Git commits
- **Email Address**: Your email for Git commits

```powershell
.\install.ps1

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

```powershell
# Set your name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify configuration
git config --global --list
```

### Template System

The repository uses a template-based approach:
- `git\gitconfig.template` - Template with placeholders
- `git\gitconfig` - Generated during installation with your information

**See**: [git/README.md](git/README.md) for detailed Git configuration documentation.

---

## Usage Examples

### Example 1: First-time Setup

```powershell
# Clone repository
git clone <repo-url> $env:USERPROFILE\.dotfiles

# Enable Developer Mode (Settings → For developers)
# Or open PowerShell as Administrator

# Install interactively
cd $env:USERPROFILE\.dotfiles
.\install.ps1 -Interactive
```

**Selections:**
- Target: **Home directory**
- Agents: **All four** (Augment, Claude, Copilot, Windsurf)
- Method: **Symlink** (if Developer Mode enabled)

---

### Example 2: Project-specific Installation

```powershell
# Navigate to project
cd C:\Projects\my-project

# Install agents to workspace
$env:USERPROFILE\.dotfiles\install.ps1 -Interactive
```

**Selections:**
- Target: **Current workspace**
- Agents: **Claude Code** and **GitHub Copilot**
- Method: **Copy files** (to commit to repo)

---

### Example 3: Update Existing Installation

```powershell
cd $env:USERPROFILE\.dotfiles

# Pull latest changes
git pull origin main

# For symlink installation: Changes immediately available
# For copy installation: Reinstall
.\install.ps1 -Interactive
```

---

## Command-Line Options

```powershell
.\install.ps1 [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-Interactive` | Interactive agent selection |
| `-AgentsOnly` | Install only AI agents (skip git configs) |
| `-SkipLegacy` | Skip git configuration installation |
| `-DryRun` | Preview installation (no changes) |
| `-Help` | Show detailed help |

### Examples

```powershell
# Interactive mode
.\install.ps1 -Interactive

# Default installation with dry-run
.\install.ps1 -DryRun

# Only agents, no git configs
.\install.ps1 -AgentsOnly

# Get detailed help
.\install.ps1 -Help
```

---

## Installation Paths

All agents support both **Home** and **Workspace** installations:

| AI Agent | Home Directory | Workspace Directory |
|----------|----------------|---------------------|
| **Augment Code** | `%USERPROFILE%\.augment\commands\` | `.\.augment\commands\` |
| **Claude Code** | `%USERPROFILE%\.claude\commands\` & `agents\` | `.\.claude\commands\` & `agents\` |
| **GitHub Copilot** | `%APPDATA%\Code\User\prompts` | `.\.github\prompts\` |
| **Windsurf** | `%USERPROFILE%\.codeium\windsurf\global_workflows` | `.\.windsurf\workflows\` |

**Typical paths:**
- `%USERPROFILE%` → `C:\Users\<username>`
- `%APPDATA%` → `C:\Users\<username>\AppData\Roaming`

---

## Post-Installation

### 1. Verify Installation

```powershell
# Check Claude Code
ls $env:USERPROFILE\.claude\commands
ls $env:USERPROFILE\.claude\agents

# Check Augment Code
ls $env:USERPROFILE\.augment\commands

# Check GitHub Copilot
ls $env:APPDATA\Code\User\prompts

# Check Windsurf
ls $env:USERPROFILE\.codeium\windsurf\global_workflows
```

---

### 2. Activate GitHub Copilot Prompts

For workspace installations, add to `.vscode\settings.json`:

```json
{
  "chat.promptFiles": true
}
```

Then restart VS Code.

---

## Troubleshooting

### Symlinks Fail with "Access Denied"

**Issue**: Symlink creation requires Administrator rights or Developer Mode.

**Solutions:**

1. **Enable Developer Mode** (recommended):
   - Settings → Update & Security → For developers → Developer Mode
   - Restart PowerShell

2. **Run as Administrator**:
   - Right-click PowerShell → "Run as Administrator"

3. **Use Copy method**:
   ```powershell
   .\install.ps1 -Interactive
   # Select "Copy files" when prompted
   ```

---

### Script Execution Blocked

**Issue**: PowerShell execution policy prevents running scripts.

**Error message:**
```
.\install.ps1 : File cannot be loaded because running scripts is disabled on this system.
```

**Solution:**

```powershell
# Temporarily allow script execution (current session only)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Then run install script
.\install.ps1
```

Or permanently (requires Admin):

```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Then run install script
.\install.ps1
```

---

### Path Contains Spaces

**Issue**: Paths with spaces cause errors.

**Solution:** Always use quotes:

```powershell
# Correct
cd "C:\Users\My Name\.dotfiles"

# Incorrect
cd C:\Users\My Name\.dotfiles
```

---

### Git Not Found

**Issue**: Git is not installed or not in PATH.

**Solution:**

1. Install Git for Windows: https://git-scm.com/download/win
2. Restart PowerShell
3. Verify: `git --version`

---

### Commands Not Showing in IDE

**Claude Code / Augment:**
- Restart the IDE
- Check installation path

**GitHub Copilot:**
- Enable in workspace settings: `"chat.promptFiles": true`
- Restart VS Code

**Windsurf:**
- Restart Windsurf
- Check global workflows path

---

### Backup Files Created

**Issue**: Want to remove backup files.

**Location:**
```powershell
ls $env:USERPROFILE\.dotfiles_backup_*
```

**Remove:**
```powershell
# Review backup contents first
ls $env:USERPROFILE\.dotfiles_backup_YYYYMMDD_HHMMSS

# Then remove if not needed
rm -r $env:USERPROFILE\.dotfiles_backup_YYYYMMDD_HHMMSS
```

---

## Advanced Usage

### Custom Dotfiles Directory

```powershell
# Set custom location
$env:DOTFILES_DIR = "C:\Custom\Path\dotfiles"

# Then run install
.\install.ps1
```

---

### Debug Mode

Enable verbose output:

```powershell
# Set debug flag in install.ps1
$script:DebugMode = $true

# Then run
.\install.ps1 -Interactive
```

---

## Uninstall

```powershell
# Manual uninstall - remove installation directories
rm -r $env:USERPROFILE\.claude
rm -r $env:USERPROFILE\.augment
rm -r $env:APPDATA\Code\User\prompts
rm -r $env:USERPROFILE\.codeium\windsurf\global_workflows

# Restore from backup (if available)
$backup = Get-ChildItem $env:USERPROFILE\.dotfiles_backup_* | Sort-Object -Descending | Select-Object -First 1
if ($backup) {
    Write-Host "Restoring from: $($backup.FullName)"
    cp -r "$($backup.FullName)\.claude" $env:USERPROFILE\
}
```

---

## Comparison: macOS/Linux vs Windows

| Feature | macOS/Linux | Windows |
|---------|-------------|---------|
| **Installer** | `./install.sh` | `.\install.ps1` |
| **Shell** | Bash | PowerShell |
| **Symlinks** | Native | Requires Developer Mode or Admin |
| **Paths** | `~/.claude` | `%USERPROFILE%\.claude` |
| **Git Config** | `~/.gitconfig` | `%USERPROFILE%\.gitconfig` |

---

## Next Steps

- **Customize commands**: Edit files in `agents\<agent-name>\`
- **Add new commands**: Create new `.md` or `.prompt.md` files
- **Share with team**: Commit workspace installations to version control
- **Read main docs**: See [INSTALLATION.md](INSTALLATION.md)

---

## Support

For issues or questions:
1. Check this troubleshooting section
2. Review [INSTALLATION.md](INSTALLATION.md)
3. Check agent-specific READMEs in `agents\*\README.md`
4. Open an issue on GitHub

---

**Last Updated**: November 2024
**Version**: 3.0 (Windows Support)
