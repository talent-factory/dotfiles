#!/bin/bash
# Claude Code installer module

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

# Install Claude Code configuration
install_claude() {
    local mode="$1"      # "home", "workspace", or "both"
    local method="$2"    # "symlink" or "copy"
    local source_dir="$DOTFILES_DIR/agents/claude"

    log_info "Installing Claude Code..."

    if [[ ! -d "$source_dir" ]]; then
        log_error "Claude source directory not found: $source_dir"
        return 1
    fi

    # Install to home directory
    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        _install_claude_to_target "$HOME/.claude" "$source_dir" "$method"
    fi

    # Install to workspace
    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _install_claude_to_target "$(pwd)/.claude" "$source_dir" "$method"
    fi

    log_success "Claude Code installation completed"
    return 0
}

# Internal function to install to specific target
_install_claude_to_target() {
    local target_dir="$1"
    local source_dir="$2"
    local method="$3"

    # Backup existing installation
    backup_existing "$target_dir"

    # Create target directory
    if [[ "$DRY_RUN" != true ]]; then
        mkdir -p "$target_dir"
    fi

    # Install commands
    if [[ -d "$source_dir/commands" ]]; then
        case $method in
            symlink)
                create_symlink "$source_dir/commands" "$target_dir/commands"
                ;;
            copy)
                copy_files "$source_dir/commands" "$target_dir/commands"
                ;;
            *)
                log_error "Invalid installation method: $method"
                return 1
                ;;
        esac
    else
        log_warn "Commands directory not found: $source_dir/commands"
    fi

    # Install agents
    if [[ -d "$source_dir/agents" ]]; then
        case $method in
            symlink)
                create_symlink "$source_dir/agents" "$target_dir/agents"
                ;;
            copy)
                copy_files "$source_dir/agents" "$target_dir/agents"
                ;;
        esac
    else
        log_warn "Agents directory not found: $source_dir/agents"
    fi

    # Install skills
    if [[ -d "$source_dir/skills" ]]; then
        case $method in
            symlink)
                create_symlink "$source_dir/skills" "$target_dir/skills"
                ;;
            copy)
                copy_files "$source_dir/skills" "$target_dir/skills"
                ;;
        esac
    else
        log_debug "Skills directory not found: $source_dir/skills (optional)"
    fi

    # Verify installation
    _verify_claude_installation "$target_dir"

    return 0
}

# Verify Claude installation
_verify_claude_installation() {
    local target_dir="$1"

    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would verify Claude installation at: $target_dir"
        return 0
    fi

    local errors=0

    # Check commands directory
    if [[ -d "$target_dir/commands" ]]; then
        local cmd_count=$(find -L "$target_dir/commands" -name "*.md" -type f 2>/dev/null | wc -l)
        log_success "Commands directory verified ($cmd_count commands found)"
    else
        log_error "Commands directory not found: $target_dir/commands"
        ((errors++))
    fi

    # Check agents directory
    if [[ -d "$target_dir/agents" ]]; then
        local agent_count=$(find -L "$target_dir/agents" -name "*.md" -type f 2>/dev/null | wc -l)
        log_success "Agents directory verified ($agent_count agents found)"
    else
        log_error "Agents directory not found: $target_dir/agents"
        ((errors++))
    fi

    # Check skills directory (optional)
    if [[ -d "$target_dir/skills" ]]; then
        local skill_count=$(find -L "$target_dir/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
        log_success "Skills directory verified ($skill_count skills found)"
    fi

    if [[ $errors -eq 0 ]]; then
        log_success "Claude Code installation verified at: $target_dir"
        return 0
    else
        log_error "Claude Code installation verification failed ($errors errors)"
        return 1
    fi
}

# List available Claude commands
list_claude_commands() {
    local target_dir="$1"

    if [[ ! -d "$target_dir/commands" ]]; then
        log_warn "Commands directory not found: $target_dir/commands"
        return 1
    fi

    echo ""
    echo "Available Claude Code commands:"
    echo ""

    # Find all command files
    while IFS= read -r -d '' file; do
        local cmd_name=$(basename "$file" .md)
        local cmd_path=$(dirname "$file" | sed "s|$target_dir/commands/||")

        if [[ "$cmd_path" == "." ]]; then
            echo "  • /$cmd_name"
        else
            echo "  • /$cmd_path:$cmd_name"
        fi

        # Try to extract description from frontmatter
        local description=$(grep -A 1 '^description:' "$file" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')
        if [[ -n "$description" ]]; then
            echo "    $description"
        fi
    done < <(find -L "$target_dir/commands" -name "*.md" -type f -print0 | sort -z)

    echo ""
}

# Uninstall Claude Code
uninstall_claude() {
    local mode="$1"

    log_info "Uninstalling Claude Code..."

    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        _uninstall_claude_from_target "$HOME/.claude"
    fi

    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _uninstall_claude_from_target "$(pwd)/.claude"
    fi

    log_success "Claude Code uninstalled"
}

# Internal function to uninstall from target
_uninstall_claude_from_target() {
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
export -f install_claude uninstall_claude list_claude_commands
