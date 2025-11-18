#!/bin/bash
# Dotfiles Installation Script
# Supports shell configs, git, vim, and AI agent configurations (Claude, Augment, etc.)
#
# Usage:
#   ./install.sh                  # Full installation (shell + git + vim + AI agents)
#   ./install.sh --interactive    # Interactive AI agent installation only
#   ./install.sh --agents-only    # Install AI agents with defaults (non-interactive)
#   ./install.sh --dry-run        # Simulation mode (no changes)
#   ./install.sh -n               # Simulation mode (short form)

set -e

# Parse command line arguments
DRY_RUN=false
INTERACTIVE=false
AGENTS_ONLY=false
SKIP_LEGACY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --interactive|-i)
            INTERACTIVE=true
            shift
            ;;
        --agents-only)
            AGENTS_ONLY=true
            SKIP_LEGACY=true
            shift
            ;;
        --skip-legacy)
            SKIP_LEGACY=true
            shift
            ;;
        --help|-h)
            cat << EOF
Dotfiles Installation Script

Usage:
  ./install.sh [OPTIONS]

Options:
  --interactive, -i      Interactive AI agent installation
  --agents-only         Install only AI agents (non-interactive)
  --skip-legacy         Skip shell/git/vim installation
  --dry-run, -n         Simulation mode (no changes)
  --help, -h            Show this help message

Examples:
  ./install.sh                    # Full installation
  ./install.sh --interactive      # Choose AI agents interactively
  ./install.sh --agents-only      # Install all AI agents with defaults
  ./install.sh --dry-run          # Preview what would be installed

EOF
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Run './install.sh --help' for usage information"
            exit 1
            ;;
    esac
done

# Export variables
export DRY_RUN
export INTERACTIVE
export DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Source libraries
source "$DOTFILES_DIR/install/lib/common.sh"
source "$DOTFILES_DIR/install/lib/prompts.sh"

# Source agent installers
source "$DOTFILES_DIR/install/agents/claude.sh"
source "$DOTFILES_DIR/install/agents/augment.sh"
source "$DOTFILES_DIR/install/agents/copilot.sh"
source "$DOTFILES_DIR/install/agents/windsurf.sh"

# Main installation function
main() {
    print_header "AI Agent Dotfiles Installer"

    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "═══════════════════════════════════════════════════════════"
        log_dry_run "  SIMULATION MODE - No changes will be made"
        log_dry_run "═══════════════════════════════════════════════════════════"
        echo ""
    fi

    # Legacy installations (shell, git, vim)
    if [[ "$SKIP_LEGACY" != true ]]; then
        install_legacy_dotfiles
    fi

    # AI Agent installations
    if [[ "$INTERACTIVE" == true ]]; then
        install_agents_interactive
    elif [[ "$AGENTS_ONLY" == true ]]; then
        install_agents_default
    else
        # Default: Ask if user wants to install agents
        echo ""
        if ask_yes_no "Do you want to install AI agent configurations?" "y"; then
            if ask_yes_no "Use interactive mode?" "y"; then
                install_agents_interactive
            else
                install_agents_default
            fi
        fi
    fi

    # Summary
    print_summary
}

# Install legacy dotfiles (shell, git, vim)
install_legacy_dotfiles() {
    print_section "Legacy Dotfiles Installation"

    log_info "Setting up shell configurations..."
    create_symlink "$DOTFILES_DIR/shell/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/shell/bashrc" "$HOME/.bashrc"
    create_symlink "$DOTFILES_DIR/shell/bash_profile" "$HOME/.bash_profile"
    create_symlink "$DOTFILES_DIR/shell/zshenv" "$HOME/.zshenv"

    log_info "Setting up git configurations..."
    create_symlink "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
    create_symlink "$DOTFILES_DIR/git/gitignore_global" "$HOME/.gitignore_global"

    log_info "Setting up vim configurations..."
    create_symlink "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"

    # Local configuration templates
    if [[ -f "$DOTFILES_DIR/shell/zshrc.local.example" && ! -f "$HOME/.zshrc.local" ]]; then
        if [[ "$DRY_RUN" != true ]]; then
            cp "$DOTFILES_DIR/shell/zshrc.local.example" "$HOME/.zshrc.local"
            log_info "Created ~/.zshrc.local from template"
        else
            log_dry_run "Would create ~/.zshrc.local from template"
        fi
    fi

    if [[ -f "$DOTFILES_DIR/shell/bashrc.local.example" && ! -f "$HOME/.bashrc.local" ]]; then
        if [[ "$DRY_RUN" != true ]]; then
            cp "$DOTFILES_DIR/shell/bashrc.local.example" "$HOME/.bashrc.local"
            log_info "Created ~/.bashrc.local from template"
        else
            log_dry_run "Would create ~/.bashrc.local from template"
        fi
    fi

    # SSH config
    if [[ -f "$DOTFILES_DIR/ssh/config.template" && ! -f "$HOME/.ssh/config" ]]; then
        if [[ "$DRY_RUN" != true ]]; then
            mkdir -p "$HOME/.ssh"
            cp "$DOTFILES_DIR/ssh/config.template" "$HOME/.ssh/config"
            chmod 600 "$HOME/.ssh/config"
            log_info "Created SSH config from template"
        else
            log_dry_run "Would create SSH config from template"
        fi
    fi

    echo ""
}

# Interactive AI agent installation
install_agents_interactive() {
    print_section "Interactive AI Agent Installation"

    # Prompt for installation target
    local target=$(prompt_installation_target)
    log_debug "Selected target: $target"

    # Prompt for agent selection
    local agents=$(prompt_agent_selection)
    log_debug "Selected agents: $agents"

    if [[ -z "$agents" ]]; then
        log_warn "No agents selected. Skipping agent installation."
        return 0
    fi

    # Prompt for installation method
    local method=$(prompt_installation_method)
    log_debug "Selected method: $method"

    # Display installation plan
    display_installation_plan "$target" "$agents" "$method"

    # Confirm installation
    if ! confirm_installation; then
        log_warn "Installation cancelled by user"
        return 0
    fi

    # Perform installation
    for agent in $agents; do
        case $agent in
            augment)
                install_augment "$target" "$method"
                ;;
            claude)
                install_claude "$target" "$method"
                ;;
            copilot)
                install_copilot "$target" "$method"
                ;;
            windsurf)
                install_windsurf "$target" "$method"
                ;;
            *)
                log_error "Unknown agent: $agent"
                ;;
        esac
    done

    echo ""
}

# Default AI agent installation (non-interactive)
install_agents_default() {
    print_section "AI Agent Installation (Default)"

    log_info "Installing Claude Code to home directory..."
    install_claude "home" "symlink"

    echo ""
}

# Print installation summary
print_summary() {
    local width=60
    local text_width=$((width - 2))

    echo ""
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "╔$(printf '═%.0s' $(seq 1 $width))╗"
        log_dry_run "$(printf '║  %-'${text_width}'s║' 'Simulation completed - No changes were made')"
        log_dry_run "╚$(printf '═%.0s' $(seq 1 $width))╝"
        echo ""
        log_info "To perform the actual installation, run: ./install.sh"
    else
        log_success "╔$(printf '═%.0s' $(seq 1 $width))╗"
        log_success "$(printf '║  %-'${text_width}'s║' 'Installation completed successfully! 🎉')"
        log_success "╚$(printf '═%.0s' $(seq 1 $width))╝"
        echo ""

        if [[ -d "$BACKUP_DIR" ]]; then
            log_info "Backup files stored in: $BACKUP_DIR"
        fi

        echo ""
        log_info "Next steps:"
        log_info "  1. Restart your terminal or run: source ~/.zshrc"
        log_info "  2. Verify Claude Code commands are available"
        log_info "  3. Customize local configs as needed"
    fi
}

# Run main installation
main
