#!/bin/bash

# Dotfiles Installation Script
# This script creates symlinks from your home directory to the dotfiles in this repository
#
# Usage:
#   ./install.sh           # Normal installation
#   ./install.sh --dry-run # Simulation mode (no changes)
#   ./install.sh -n        # Simulation mode (short form)

set -e

# Parse command line arguments
DRY_RUN=false
if [[ "$1" == "--dry-run" || "$1" == "-n" ]]; then
    DRY_RUN=true
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${BLUE}[SUCCESS]${NC} $1"
}

log_dry_run() {
    echo -e "${MAGENTA}[DRY-RUN]${NC} $1"
}

backup_existing() {
    local file="$1"
    if [[ -e "$file" && ! -L "$file" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "Would backup existing $file to $BACKUP_DIR"
        else
            mkdir -p "$BACKUP_DIR"
            log_warn "Backing up existing $file to $BACKUP_DIR"
            mv "$file" "$BACKUP_DIR/"
        fi
    elif [[ -L "$file" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "Would remove existing symlink $file"
        else
            log_info "Removing existing symlink $file"
            rm "$file"
        fi
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"

    if [[ -f "$source" || -d "$source" ]]; then
        backup_existing "$target"
        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "Would create symlink: $target -> $source"
        else
            mkdir -p "$(dirname "$target")"
            ln -sf "$source" "$target"
            log_info "Created symlink: $target -> $source"
        fi
    else
        log_warn "Source not found: $source"
    fi
}

echo ""
if [[ "$DRY_RUN" == true ]]; then
    log_dry_run "═══════════════════════════════════════════════════════════"
    log_dry_run "  SIMULATION MODE - No changes will be made"
    log_dry_run "═══════════════════════════════════════════════════════════"
    echo ""
fi
log_info "Starting Dotfiles Installation..."
echo ""

# Create symlinks for shell configurations
log_info "Setting up shell configurations..."
create_symlink "$DOTFILES_DIR/shell/zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/shell/bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/shell/bash_profile" "$HOME/.bash_profile"
create_symlink "$DOTFILES_DIR/shell/zshenv" "$HOME/.zshenv"
echo ""

# Create symlinks for git configurations
log_info "Setting up git configurations..."
create_symlink "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/git/gitignore_global" "$HOME/.gitignore_global"
echo ""

# Create symlinks for vim configurations
log_info "Setting up vim configurations..."
create_symlink "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"
echo ""

# Create symlink for Claude Code configurations
log_info "Setting up Claude Code configurations..."
if [[ -d "$DOTFILES_DIR/claude" ]]; then
    backup_existing "$HOME/.claude"
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would create symlink: $HOME/.claude -> $DOTFILES_DIR/claude"
        
        # Verify Claude commands are accessible
        if [[ -d "$DOTFILES_DIR/claude/commands" ]]; then
            log_dry_run "Would link Claude commands directory"
        fi

        # Verify Claude agents are accessible
        if [[ -d "$DOTFILES_DIR/claude/agents" ]]; then
            log_dry_run "Would link Claude agents directory"
        fi
    else
        ln -sf "$DOTFILES_DIR/claude" "$HOME/.claude"
        log_info "Created symlink: $HOME/.claude -> $DOTFILES_DIR/claude"

        # Verify Claude commands are accessible
        if [[ -d "$HOME/.claude/commands" ]]; then
            log_success "Claude commands directory linked successfully"
        fi

        # Verify Claude agents are accessible
        if [[ -d "$HOME/.claude/agents" ]]; then
            log_success "Claude agents directory linked successfully"
        fi
    fi
else
    log_warn "claude directory not found in dotfiles"
fi
echo ""

# Setup local configuration templates
log_info "Setting up local configuration templates..."
if [[ -f "$DOTFILES_DIR/shell/zshrc.local.example" && ! -f "$HOME/.zshrc.local" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would copy: $DOTFILES_DIR/shell/zshrc.local.example -> $HOME/.zshrc.local"
    else
        cp "$DOTFILES_DIR/shell/zshrc.local.example" "$HOME/.zshrc.local"
        log_info "Created ~/.zshrc.local from template. Please customize as needed."
    fi
fi

if [[ -f "$DOTFILES_DIR/shell/bashrc.local.example" && ! -f "$HOME/.bashrc.local" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would copy: $DOTFILES_DIR/shell/bashrc.local.example -> $HOME/.bashrc.local"
    else
        cp "$DOTFILES_DIR/shell/bashrc.local.example" "$HOME/.bashrc.local"
        log_info "Created ~/.bashrc.local from template. Please customize as needed."
    fi
fi
echo ""

# Handle ~/.config directory
if [[ -d "$DOTFILES_DIR/config" ]]; then
    log_info "Setting up ~/.config directory..."
    for config_item in "$DOTFILES_DIR/config"/*; do
        if [[ -e "$config_item" ]]; then
            item_name=$(basename "$config_item")
            target="$HOME/.config/$item_name"
            backup_existing "$target"
            if [[ "$DRY_RUN" == true ]]; then
                log_dry_run "Would create directory: $HOME/.config"
                log_dry_run "Would create symlink: $target -> $config_item"
            else
                mkdir -p "$HOME/.config"
                ln -sf "$config_item" "$target"
                log_info "Created symlink: $target -> $config_item"
            fi
        fi
    done
    echo ""
fi

# Handle ~/.local directory
if [[ -d "$DOTFILES_DIR/local" ]]; then
    log_info "Setting up ~/.local directory..."
    for local_item in "$DOTFILES_DIR/local"/*; do
        if [[ -e "$local_item" ]]; then
            item_name=$(basename "$local_item")
            target="$HOME/.local/$item_name"
            backup_existing "$target"
            if [[ "$DRY_RUN" == true ]]; then
                log_dry_run "Would create directory: $HOME/.local"
                log_dry_run "Would create symlink: $target -> $local_item"
            else
                mkdir -p "$HOME/.local"
                ln -sf "$local_item" "$target"
                log_info "Created symlink: $target -> $local_item"
            fi
        fi
    done
    echo ""
fi

# SSH config (special handling as it shouldn't be tracked directly)
if [[ -f "$DOTFILES_DIR/ssh/config.template" && ! -f "$HOME/.ssh/config" ]]; then
    log_info "Creating SSH config from template..."
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would create directory: $HOME/.ssh"
        log_dry_run "Would copy: $DOTFILES_DIR/ssh/config.template -> $HOME/.ssh/config"
        log_dry_run "Would set permissions: chmod 600 $HOME/.ssh/config"
    else
        mkdir -p "$HOME/.ssh"
        cp "$DOTFILES_DIR/ssh/config.template" "$HOME/.ssh/config"
        chmod 600 "$HOME/.ssh/config"
        log_info "SSH config created from template. Please customize as needed."
    fi
    echo ""
fi

echo ""
if [[ "$DRY_RUN" == true ]]; then
    log_dry_run "╔════════════════════════════════════════════════════════════╗"
    log_dry_run "║  Simulation completed - No changes were made              ║"
    log_dry_run "╚════════════════════════════════════════════════════════════╝"
    echo ""
    log_info "To perform the actual installation, run: ./install.sh"
else
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  Dotfiles installation completed successfully! 🎉          ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""

    if [[ -d "$BACKUP_DIR" ]]; then
        log_info "Backup files are stored in: $BACKUP_DIR"
    fi

    echo ""
    log_info "Next steps:"
    log_info "  1. Restart your terminal or run: source ~/.zshrc"
    log_info "  2. Verify Claude Code commands are available"
    log_info "  3. Customize SSH config if needed: vim ~/.ssh/config"
fi
echo ""

# Claude Code verification
if [[ -d "$HOME/.claude/commands" ]]; then
    log_success "Claude Code Commands available:"
    log_info "  • /commit - Professional Git commits with pre-commit checks"
    log_info "  • /create-pr - Pull requests with automatic branch creation"
    log_info "  • /project:create-prd - Product Requirements Documents"
    echo ""
fi
