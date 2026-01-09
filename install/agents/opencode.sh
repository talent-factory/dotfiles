#!/bin/bash
# OpenCode installer module

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

# Install OpenCode configuration
install_opencode() {
    local mode="$1"      # "home", "workspace", or "both"
    local method="$2"    # "symlink" or "copy"
    local source_dir="$DOTFILES_DIR/agents/opencode"

    log_info "Installing OpenCode..."

    if [[ ! -d "$source_dir" ]]; then
        log_error "OpenCode source directory not found: $source_dir"
        return 1
    fi

    # Install to home directory
    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        _install_opencode_to_target "$HOME/.config/opencode" "$source_dir" "$method"
    fi

    # Install to workspace
    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _install_opencode_to_target "$(pwd)/.opencode" "$source_dir" "$method"
    fi

    log_success "OpenCode installation completed"
    return 0
}

# Internal function to install to specific target
_install_opencode_to_target() {
    local target_dir="$1"
    local source_dir="$2"
    local method="$3"
    local shared_dir="$DOTFILES_DIR/agents/_shared"

    log_debug "Installing OpenCode to: $target_dir (method: $method)"

    # Create target directory if it doesn't exist (preserves existing files)
    if [[ "$DRY_RUN" != true ]]; then
        mkdir -p "$target_dir"
    else
        log_dry_run "Would ensure directory exists: $target_dir"
    fi

    # Install agents (OpenCode-specific AI agents)
    if [[ -d "$source_dir/agent" ]]; then
        case $method in
            symlink)
                create_symlink "$source_dir/agent" "$target_dir/agent"
                ;;
            copy)
                copy_files "$source_dir/agent" "$target_dir/agent"
                ;;
            *)
                log_error "Invalid installation method: $method"
                return 1
                ;;
        esac
        log_debug "OpenCode agent source: $source_dir/agent"
    else
        log_warn "OpenCode agent directory not found: $source_dir/agent"
        ls -la "$source_dir/" 2>/dev/null || log_debug "Cannot list $source_dir directory"
    fi

    # Install commands (OpenCode uses "command" singular, not "commands")
    if [[ -d "$shared_dir/commands" ]]; then
        case $method in
            symlink)
                create_symlink "$shared_dir/commands" "$target_dir/command"
                ;;
            copy)
                # For copy mode: copy actual content, resolving symlinks
                copy_files "$shared_dir/commands" "$target_dir/command"
                ;;
            *)
                log_error "Invalid installation method: $method"
                return 1
                ;;
        esac
        log_debug "Commands source: $shared_dir/commands"
    else
        log_warn "Shared commands directory not found: $shared_dir/commands"
        ls -la "$shared_dir/" 2>/dev/null || log_debug "Cannot list $shared_dir directory"
    fi

    # Install references (support documentation for commands)
    if [[ -d "$shared_dir/references" ]]; then
        case $method in
            symlink)
                create_symlink "$shared_dir/references" "$target_dir/references"
                ;;
            copy)
                copy_files "$shared_dir/references" "$target_dir/references"
                ;;
        esac
        log_debug "References source: $shared_dir/references"
    else
        log_warn "References directory not found: $shared_dir/references"
        ls -la "$shared_dir/" 2>/dev/null || log_debug "Cannot list $shared_dir directory"
    fi

    # Verify installation
    _verify_opencode_installation "$target_dir"

    return 0
}

# Verify OpenCode installation
_verify_opencode_installation() {
    local target_dir="$1"

    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would verify OpenCode installation at: $target_dir"
        return 0
    fi

    local errors=0

    # Check agent directory (OpenCode-specific AI agents)
    if [[ -d "$target_dir/agent" ]]; then
        local agent_count=$(find -L "$target_dir/agent" -name "*.md" -type f 2>/dev/null | wc -l)
        log_success "Agent directory verified ($agent_count agents found)"
    else
        log_error "Agent directory not found: $target_dir/agent"
        ((errors++))
    fi

    # Check command directory (singular for OpenCode)
    if [[ -d "$target_dir/command" ]]; then
        local cmd_count=$(find -L "$target_dir/command" -name "*.md" -type f 2>/dev/null | wc -l)
        log_success "Command directory verified ($cmd_count commands found)"
    else
        log_error "Command directory not found: $target_dir/command"
        ((errors++))
    fi

    # Check references directory (support documentation)
    if [[ -d "$target_dir/references" ]]; then
        local ref_count=$(find -L "$target_dir/references" -name "*.md" -type f 2>/dev/null | wc -l)
        log_success "References directory verified ($ref_count reference docs found)"
    else
        log_warn "References directory not found: $target_dir/references (optional but recommended)"
    fi

    if [[ $errors -eq 0 ]]; then
        log_success "OpenCode installation verified at: $target_dir"
        return 0
    else
        log_error "OpenCode installation verification failed ($errors errors)"
        return 1
    fi
}

# List available OpenCode commands
list_opencode_commands() {
    local target_dir="$1"

    if [[ ! -d "$target_dir/command" ]]; then
        log_warn "Command directory not found: $target_dir/command"
        return 1
    fi

    echo ""
    echo "Available OpenCode agents:"
    echo ""

    # Find all agent files
    find -L "$target_dir/agent" -maxdepth 1 -name "*.md" -type f | sort | while read -r file; do
        local agent_name=$(basename "$file" .md)

        echo "  • $agent_name"

        # Try to extract description from frontmatter
        local description=$(grep -A 1 '^description:' "$file" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')
        if [[ -n "$description" ]]; then
            echo "    $description"
        fi
    done

    echo ""
    echo "Available OpenCode commands:"
    echo ""

    # Find all command files
    find -L "$target_dir/command" -maxdepth 1 -name "*.md" -type f | sort | while read -r file; do
        local cmd_name=$(basename "$file" .md)

        echo "  • /$cmd_name"

        # Try to extract description from frontmatter
        local description=$(grep -A 1 '^description:' "$file" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')
        if [[ -n "$description" ]]; then
            echo "    $description"
        fi
    done

    echo ""
}

# Uninstall OpenCode
uninstall_opencode() {
    local mode="$1"

    log_info "Uninstalling OpenCode..."

    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        _uninstall_opencode_from_target "$HOME/.config/opencode"
    fi

    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _uninstall_opencode_from_target "$(pwd)/.opencode"
    fi

    log_success "OpenCode uninstalled"
}

# Internal function to uninstall from target
_uninstall_opencode_from_target() {
    local target_dir="$1"

    if [[ ! -e "$target_dir" ]]; then
        log_debug "Target does not exist: $target_dir"
        return 0
    fi

    if ask_yes_no "Remove $target_dir?" "n"; then
        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "Would remove: $target_dir"
        else
            backup_existing "$target_dir"
            log_info "Removed: $target_dir"
        fi
    else
        log_info "Skipped: $target_dir"
    fi
}

# Export functions
export -f install_opencode uninstall_opencode list_opencode_commands
