#!/bin/bash

# Dotfiles Installation Script
# This script creates symlinks from your home directory to the dotfiles in this repository

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

backup_existing() {
    local file="$1"
    if [[ -e "$file" && ! -L "$file" ]]; then
        mkdir -p "$BACKUP_DIR"
        log_warn "Backing up existing $file to $BACKUP_DIR"
        mv "$file" "$BACKUP_DIR/"
    elif [[ -L "$file" ]]; then
        log_info "Removing existing symlink $file"
        rm "$file"
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ -f "$source" ]]; then
        backup_existing "$target"
        mkdir -p "$(dirname "$target")"
        ln -sf "$source" "$target"
        log_info "Created symlink: $target -> $source"
    else
        log_warn "Source file not found: $source"
    fi
}

# Create symlinks for shell configurations
log_info "Setting up shell configurations..."
create_symlink "$DOTFILES_DIR/shell/zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/shell/bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/shell/bash_profile" "$HOME/.bash_profile"
create_symlink "$DOTFILES_DIR/shell/zshenv" "$HOME/.zshenv"

# Create symlinks for git configurations
log_info "Setting up git configurations..."
create_symlink "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/git/gitignore_global" "$HOME/.gitignore_global"

# Create symlinks for vim configurations
log_info "Setting up vim configurations..."
create_symlink "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"

# Create symlinks for claude configurations
log_info "Setting up claude configurations..."
create_symlink "$DOTFILES_DIR/claude/claude.json" "$HOME/.claude.json"

# Handle ~/.config directory
if [[ -d "$DOTFILES_DIR/config" ]]; then
    log_info "Setting up ~/.config directory..."
    for config_item in "$DOTFILES_DIR/config"/*; do
        if [[ -e "$config_item" ]]; then
            item_name=$(basename "$config_item")
            target="$HOME/.config/$item_name"
            backup_existing "$target"
            mkdir -p "$HOME/.config"
            ln -sf "$config_item" "$target"
            log_info "Created symlink: $target -> $config_item"
        fi
    done
fi

# Handle ~/.local directory
if [[ -d "$DOTFILES_DIR/local" ]]; then
    log_info "Setting up ~/.local directory..."
    for local_item in "$DOTFILES_DIR/local"/*; do
        if [[ -e "$local_item" ]]; then
            item_name=$(basename "$local_item")
            target="$HOME/.local/$item_name"
            backup_existing "$target"
            mkdir -p "$HOME/.local"
            ln -sf "$local_item" "$target"
            log_info "Created symlink: $target -> $local_item"
        fi
    done
fi

# SSH config (special handling as it shouldn't be tracked directly)
if [[ -f "$DOTFILES_DIR/ssh/config.template" && ! -f "$HOME/.ssh/config" ]]; then
    log_info "Creating SSH config from template..."
    mkdir -p "$HOME/.ssh"
    cp "$DOTFILES_DIR/ssh/config.template" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
    log_info "SSH config created from template. Please customize as needed."
fi

log_info "Dotfiles installation completed!"
if [[ -d "$BACKUP_DIR" ]]; then
    log_info "Backup files are stored in: $BACKUP_DIR"
fi

log_info "You may want to restart your terminal or run 'source ~/.zshrc' to apply changes."