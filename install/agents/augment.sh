#!/bin/bash
# Augment Code installer module

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

# Install Augment Code configuration
install_augment() {
    local mode="$1"      # "home", "workspace", or "both"
    local method="$2"    # "symlink" or "copy"
    local source_dir="$DOTFILES_DIR/agents/augment"

    log_info "Installing Augment Code..."

    if [[ ! -d "$source_dir" ]]; then
        log_error "Augment source directory not found: $source_dir"
        return 1
    fi

    # Install to home directory
    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        _install_augment_to_target "$HOME/.augment" "$source_dir" "$method"
    fi

    # Install to workspace
    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _install_augment_to_target "$(pwd)/.augment" "$source_dir" "$method"
    fi

    log_success "Augment Code installation completed"
    return 0
}

# Internal function to install to specific target
_install_augment_to_target() {
    local target_dir="$1"
    local source_dir="$2"
    local method="$3"
    local shared_dir="$DOTFILES_DIR/agents/_shared"

    log_debug "Installing Augment to: $target_dir (method: $method)"

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
                # For copy mode: copy actual content, resolving symlinks
                copy_files "$shared_dir/commands" "$target_dir/commands"
                ;;
            *)
                log_error "Invalid installation method: $method"
                return 1
                ;;
        esac
    else
        log_warn "Commands directory not found: $source_dir/commands"
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
    else
        log_warn "References directory not found: $shared_dir/references"
    fi

    # Verify installation
    _verify_augment_installation "$target_dir"

    return 0
}

# Verify Augment installation
_verify_augment_installation() {
    local target_dir="$1"

    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would verify Augment installation at: $target_dir"
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

    # Check references directory (support documentation)
    if [[ -d "$target_dir/references" ]]; then
        local ref_count=$(find -L "$target_dir/references" -name "*.md" -type f 2>/dev/null | wc -l)
        log_success "References directory verified ($ref_count reference docs found)"
    else
        log_warn "References directory not found: $target_dir/references (optional but recommended)"
    fi

    if [[ $errors -eq 0 ]]; then
        log_success "Augment Code installation verified at: $target_dir"
        return 0
    else
        log_error "Augment Code installation verification failed ($errors errors)"
        return 1
    fi
}

# List available Augment commands
list_augment_commands() {
    local target_dir="$1"

    if [[ ! -d "$target_dir/commands" ]]; then
        log_warn "Commands directory not found: $target_dir/commands"
        return 1
    fi

    echo ""
    echo "Available Augment Code commands:"
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

# Uninstall Augment Code
uninstall_augment() {
    local mode="$1"

    log_info "Uninstalling Augment Code..."

    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        _uninstall_augment_from_target "$HOME/.augment"
    fi

    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _uninstall_augment_from_target "$(pwd)/.augment"
    fi

    log_success "Augment Code uninstalled"
}

# Internal function to uninstall from target
_uninstall_augment_from_target() {
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
export -f install_augment uninstall_augment list_augment_commands
