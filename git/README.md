# Git Configuration

This directory contains Git configuration files for the dotfiles repository.

## Files

### `gitconfig`
Main Git configuration file that will be symlinked to `~/.gitconfig`.

**Important**: This file contains placeholder values for user information:
- `name = YOUR_NAME`
- `email = YOUR_EMAIL`

These placeholders will be replaced during installation when you run `./install.sh` or `.\install.ps1`.

### `gitconfig.template`
Template file used by the installation scripts to generate the personalized `gitconfig`.

Contains placeholders:
- `{{GIT_USER_NAME}}` - Replaced with your full name
- `{{GIT_USER_EMAIL}}` - Replaced with your email address

### `gitignore_global`
Global gitignore patterns that apply to all repositories.

## Installation Process

### Unix/macOS (`install.sh`)

1. The installer checks if Git user is already configured
2. If not configured or contains placeholder values, prompts for:
   - Full Name
   - Email Address
3. Updates `gitconfig` from `gitconfig.template` with your information
4. Creates symlink: `~/.gitconfig` → `dotfiles/git/gitconfig`

### Windows (`install.ps1`)

Same process as Unix/macOS, but uses PowerShell:
1. Checks existing Git configuration
2. Prompts for user information if needed
3. Updates `gitconfig` from template
4. Creates symlink: `%USERPROFILE%\.gitconfig` → `dotfiles\git\gitconfig`

## Manual Configuration

If you skip the automated configuration during installation, you can configure Git manually:

```bash
# Set your name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Or edit ~/.gitconfig directly
vim ~/.gitconfig
```

## Features

The Git configuration includes:

### User Settings
- Name and email (configured during installation)

### Core Settings
- `autocrlf = input` - Line ending normalization
- `excludesfile = ~/.gitignore_global` - Global ignore patterns
- `compression = 9` - Maximum compression
- `pager = delta` - Enhanced diff viewer

### Delta (Diff Viewer)
- Side-by-side diffs
- Syntax highlighting
- Navigation between diff sections

### Aliases
- `co` = checkout
- `br` = branch
- `ci` = commit
- `st` = status
- `last` = log -1 HEAD
- `lg` = Pretty formatted log with graph

### Other Features
- Git LFS support
- Default branch: `develop`
- Auto-setup remote on push
- Diff3 merge conflict style
- Color-moved diff detection

## Customization

### Per-User Customization

After installation, you can customize your Git configuration:

```bash
# Add additional aliases
git config --global alias.unstage 'reset HEAD --'

# Change default branch
git config --global init.defaultBranch main

# Enable GPG signing
git config --global commit.gpgsign true
```

### Repository-Specific Settings

For repository-specific settings, use local config:

```bash
cd /path/to/repo
git config user.email "work@company.com"
git config user.name "Work Name"
```

## CodeRabbit Integration (Optional)

If you use CodeRabbit, uncomment and configure in `gitconfig`:

```ini
[coderabbit]
    machineId = cli/YOUR_MACHINE_ID
```

Get your machine ID from: https://coderabbit.ai/

## Troubleshooting

### Placeholder Values Not Replaced

If you see `YOUR_NAME` or `YOUR_EMAIL` in your `~/.gitconfig`:

```bash
# Re-run installation
cd ~/.dotfiles
./install.sh

# Or configure manually
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Symlink Issues

If the symlink is not created:

```bash
# Remove existing file
rm ~/.gitconfig

# Re-run installation
cd ~/.dotfiles
./install.sh
```

### Delta Not Working

Install delta for enhanced diffs:

```bash
# macOS
brew install git-delta

# Linux
cargo install git-delta

# Windows
scoop install delta
```

## See Also

- [INSTALLATION.md](../INSTALLATION.md) - Full installation guide
- [WINDOWS_INSTALLATION.md](../WINDOWS_INSTALLATION.md) - Windows-specific guide
- [Git Documentation](https://git-scm.com/doc)
- [Delta Documentation](https://dandavison.github.io/delta/)

