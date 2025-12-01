#!/bin/bash
# Windsurf and Antigravity installer module

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

# Install Windsurf configuration
install_windsurf() {
    local mode="$1"      # "home", "workspace", or "both"
    local method="$2"    # "symlink" or "copy"
    local source_dir="$DOTFILES_DIR/agents/windsurf"

    log_info "Installing Windsurf..."

    if [[ ! -d "$source_dir" ]]; then
        log_error "Windsurf source directory not found: $source_dir"
        return 1
    fi

    # Install to home directory (global workflows) - FLAT structure required
    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        _install_windsurf_to_target "$HOME/.codeium/windsurf/global_workflows" "$source_dir" "$method" "flat"
    fi

    # Install to workspace - hierarchical structure allowed
    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _install_windsurf_to_target "$(pwd)/.windsurf/workflows" "$source_dir" "$method" "hierarchical"
    fi

    log_success "Windsurf installation completed"
    return 0
}

# Install Antigravity configuration (Windsurf fork)
install_antigravity() {
    local mode="$1"      # "home", "workspace", or "both"
    local method="$2"    # "symlink" or "copy"
    local source_dir="$DOTFILES_DIR/agents/windsurf"

    log_info "Installing Antigravity..."

    if [[ ! -d "$source_dir" ]]; then
        log_error "Antigravity source directory not found: $source_dir"
        return 1
    fi

    # Install to home directory (global workflows) - FLAT structure required
    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        _install_windsurf_to_target "$HOME/.gemini/windsurf/global_workflows" "$source_dir" "$method" "flat"
    fi

    # Install to workspace - hierarchical structure allowed
    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _install_windsurf_to_target "$(pwd)/.windsurf/workflows" "$source_dir" "$method" "hierarchical"
    fi

    log_success "Antigravity installation completed"
    return 0
}

# Internal function to install to specific target
_install_windsurf_to_target() {
    local target_dir="$1"
    local source_dir="$2"
    local method="$3"
    local structure="${4:-hierarchical}"  # "flat" or "hierarchical"

    log_debug "Installing Windsurf to: $target_dir (method: $method, structure: $structure)"

    # Backup existing installation
    backup_existing "$target_dir"

    # Create target directory
    if [[ "$DRY_RUN" != true ]]; then
        mkdir -p "$target_dir"
    else
        log_dry_run "Would create directory: $target_dir"
    fi

    # Install workflows
    if [[ -d "$source_dir/workflows" ]]; then
        if [[ "$structure" == "flat" ]]; then
            # Flat installation: copy/symlink all .md files directly to target (no subdirectories)
            _install_flat "$source_dir/workflows" "$target_dir" "$method"
        else
            # Hierarchical installation: preserve directory structure
            case $method in
                symlink)
                    # Symlink the workflows directory itself
                    # Remove target_dir if it exists (we're replacing it with symlink)
                    if [[ -d "$target_dir" && ! -L "$target_dir" && "$DRY_RUN" != true ]]; then
                        rmdir "$target_dir" 2>/dev/null || true
                    fi
                    create_symlink "$source_dir/workflows" "$target_dir"
                    ;;
                copy)
                    copy_files "$source_dir/workflows" "$target_dir"
                    ;;
                *)
                    log_error "Invalid installation method: $method"
                    return 1
                    ;;
            esac
        fi
    else
        log_warn "Workflows directory not found: $source_dir/workflows"
    fi

    # Verify installation
    _verify_windsurf_installation "$target_dir"

    return 0
}

# Install files flat (all .md files to single directory without subdirectories)
_install_flat() {
    local source_dir="$1"
    local target_dir="$2"
    local method="$3"

    log_debug "Flat installation: $source_dir -> $target_dir"

    # Find all .md files recursively
    local md_files=()
    while IFS= read -r -d '' file; do
        md_files+=("$file")
    done < <(find -L "$source_dir" -name "*.md" -type f -print0 2>/dev/null)

    if [[ ${#md_files[@]} -eq 0 ]]; then
        log_warn "No .md files found in: $source_dir"
        return 0
    fi

    log_info "Installing ${#md_files[@]} workflow files (flat)..."

    # Track installed filenames to detect duplicates
    declare -A installed_files

    for file in "${md_files[@]}"; do
        local filename=$(basename "$file")
        local target_file="$target_dir/$filename"

        # Check for duplicate filenames (track internally for dry-run support)
        if [[ -n "${installed_files[$filename]}" ]]; then
            log_warn "Duplicate filename: $filename (skipping, first found in: ${installed_files[$filename]})"
            continue
        fi
        installed_files[$filename]="$file"

        case $method in
            symlink)
                create_symlink "$file" "$target_file"
                ;;
            copy)
                if [[ "$DRY_RUN" != true ]]; then
                    cp "$file" "$target_file"
                    log_debug "Copied: $filename"
                else
                    log_dry_run "Would copy: $filename"
                fi
                ;;
        esac
    done
}

# Verify Windsurf installation
_verify_windsurf_installation() {
    local target_dir="$1"

    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would verify Windsurf installation at: $target_dir"
        return 0
    fi

    local errors=0

    # Check workflows directory (could be symlink or regular directory)
    if [[ -e "$target_dir" ]]; then
        local workflow_count=$(find -L "$target_dir" -name "*.md" -type f 2>/dev/null | wc -l)
        if [[ $workflow_count -gt 0 ]]; then
            log_success "Workflows verified ($workflow_count workflow files found)"
        else
            log_warn "No .md workflow files found in: $target_dir"
        fi
    else
        log_error "Workflows directory not found: $target_dir"
        ((errors++))
    fi

    if [[ $errors -eq 0 ]]; then
        log_success "Windsurf installation verified at: $target_dir"
        return 0
    else
        log_error "Windsurf installation verification failed ($errors errors)"
        return 1
    fi
}

# List available Windsurf workflows
list_windsurf_workflows() {
    local target_dir="$1"

    if [[ ! -e "$target_dir" ]]; then
        log_warn "Workflows directory not found: $target_dir"
        return 1
    fi

    echo ""
    echo "Available Windsurf workflows:"
    echo ""

    # Find all workflow files (follow symlinks with -L)
    while IFS= read -r -d '' file; do
        local workflow_name=$(basename "$file" .md)
        echo "  • /$workflow_name"

        # Show first heading as description (if available)
        local first_heading=$(grep -m 1 '^#' "$file" 2>/dev/null | sed 's/^#* *//')
        if [[ -n "$first_heading" ]]; then
            echo "    $first_heading"
        fi
    done < <(find -L "$target_dir" -name "*.md" -type f -print0 2>/dev/null | sort -z)

    echo ""
    log_info "Note: Workflow files are limited to 12,000 characters"
    echo ""
}

# Uninstall Windsurf
uninstall_windsurf() {
    local mode="$1"

    log_info "Uninstalling Windsurf..."

    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        _uninstall_windsurf_from_target "$HOME/.codeium/windsurf/global_workflows"
    fi

    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _uninstall_windsurf_from_target "$(pwd)/.windsurf/workflows"
    fi

    log_success "Windsurf uninstalled"
}

# Uninstall Antigravity
uninstall_antigravity() {
    local mode="$1"

    log_info "Uninstalling Antigravity..."

    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        _uninstall_windsurf_from_target "$HOME/.gemini/windsurf/global_workflows"
    fi

    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _uninstall_windsurf_from_target "$(pwd)/.windsurf/workflows"
    fi

    log_success "Antigravity uninstalled"
}

# Internal function to uninstall from target
_uninstall_windsurf_from_target() {
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
export -f install_windsurf install_antigravity uninstall_windsurf uninstall_antigravity list_windsurf_workflows
