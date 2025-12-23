#!/bin/bash
# GitHub Copilot installer module

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

# Get platform-specific home directory for Copilot
_get_copilot_home_dir() {
    local os_type="$(uname -s)"

    case "$os_type" in
        Darwin)
            # macOS
            echo "$HOME/Library/Application Support/Code/User/prompts"
            ;;
        Linux)
            # Linux (same as macOS structure for VS Code)
            echo "$HOME/.config/Code/User/prompts"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            # Windows (Git Bash, MSYS2, Cygwin)
            echo "$APPDATA/Code/User/prompts"
            ;;
        *)
            log_error "Unsupported platform: $os_type"
            return 1
            ;;
    esac
}

# Install GitHub Copilot configuration
install_copilot() {
    local mode="$1"      # "home", "workspace", or "both"
    local method="$2"    # "symlink" or "copy"
    local source_dir="$DOTFILES_DIR/agents/copilot"

    log_info "Installing GitHub Copilot..."

    if [[ ! -d "$source_dir" ]]; then
        log_error "Copilot source directory not found: $source_dir"
        return 1
    fi

    # Install to home directory
    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        local home_dir=$(_get_copilot_home_dir)
        if [[ -n "$home_dir" ]]; then
            _install_copilot_to_target "$home_dir" "$source_dir" "$method"
        else
            log_error "Could not determine Copilot home directory"
            return 1
        fi
    fi

    # Install to workspace
    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _install_copilot_to_target "$(pwd)/.github/prompts" "$source_dir" "$method"
    fi

    log_success "GitHub Copilot installation completed"

    # Show activation instructions
    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _show_copilot_activation_instructions
    fi

    return 0
}

# Internal function to install to specific target
_install_copilot_to_target() {
    local target_dir="$1"
    local source_dir="$2"
    local method="$3"

    log_debug "Installing Copilot to: $target_dir (method: $method)"

    # Backup existing installation
    backup_existing "$target_dir"

    # Install prompts
    # Note: GitHub Copilot uses .prompt.md extension instead of .md
    # We need to create individual symlinks with renamed extensions
    # Source is agents/_shared/commands/ (not copilot/prompts/)
    local shared_commands_dir="$(dirname "$source_dir")/_shared/commands"
    local shared_commands="$shared_commands_dir"

    if [[ -d "$shared_commands_dir" ]]; then
        case $method in
            symlink)
                # For Copilot, create individual symlinks with .prompt.md extension
                # Source is _shared/commands with .md files
                # Target needs .prompt.md extension for Copilot
                if [[ "$DRY_RUN" != true ]]; then
                    mkdir -p "$target_dir"
                fi

                # Create symlinks with renamed extensions
                if [[ "$DRY_RUN" != true ]]; then
                    find -L "$shared_commands" -name "*.md" -type f | while read -r source_file; do
                        # Get relative path from shared commands
                        relative_path="${source_file#$shared_commands/}"

                        # Count slashes to determine depth
                        # develop/commit.md = 1 slash = top-level → commit.prompt.md
                        # develop/commit/best-practices.md = 2 slashes → commit/best-practices.md
                        slash_count=$(echo "$relative_path" | tr -cd '/' | wc -c | tr -d ' ')

                        if [[ $slash_count -eq 1 ]]; then
                            # Top-level command: develop/commit.md → commit.prompt.md
                            base_name=$(basename "$relative_path" .md)
                            target_file="$target_dir/${base_name}.prompt.md"
                        else
                            # Subdirectory: develop/commit/best-practices.md → commit/best-practices.prompt.md
                            # Remove category prefix (develop/, project/, skills/) and add .prompt.md
                            rest_of_path=$(echo "$relative_path" | cut -d/ -f2-)
                            base_name=$(basename "$rest_of_path" .md)
                            subdir=$(dirname "$rest_of_path")
                            if [[ "$subdir" == "." ]]; then
                                target_file="$target_dir/${base_name}.prompt.md"
                            else
                                target_file="$target_dir/${subdir}/${base_name}.prompt.md"
                            fi
                        fi

                        # Create subdirectories if needed
                        target_subdir=$(dirname "$target_file")
                        mkdir -p "$target_subdir"

                        # Create symlink
                        ln -sf "$source_file" "$target_file"
                        log_debug "Created symlink: $(basename "$target_file") → $source_file"
                    done
                    log_info "Created individual symlinks with .prompt.md extension"
                else
                    log_dry_run "Would create individual symlinks with .prompt.md extension in: $target_dir"
                fi
                ;;
            copy)
                # For copy, create target directory first
                if [[ "$DRY_RUN" != true ]]; then
                    mkdir -p "$target_dir"
                fi
                # Copy individual files with .prompt.md extension
                if [[ "$DRY_RUN" != true ]]; then
                    find -L "$shared_commands" -name "*.md" -type f | while read -r source_file; do
                        # Get relative path from shared commands
                        relative_path="${source_file#$shared_commands/}"

                        # Count slashes to determine depth
                        slash_count=$(echo "$relative_path" | tr -cd '/' | wc -c | tr -d ' ')

                        if [[ $slash_count -eq 1 ]]; then
                            # Top-level command: develop/commit.md → commit.prompt.md
                            base_name=$(basename "$relative_path" .md)
                            target_file="$target_dir/${base_name}.prompt.md"
                        else
                            # Subdirectory: develop/commit/best-practices.md → commit/best-practices.prompt.md
                            # Remove category prefix (develop/, project/, skills/) and add .prompt.md
                            rest_of_path=$(echo "$relative_path" | cut -d/ -f2-)
                            base_name=$(basename "$rest_of_path" .md)
                            subdir=$(dirname "$rest_of_path")
                            if [[ "$subdir" == "." ]]; then
                                target_file="$target_dir/${base_name}.prompt.md"
                            else
                                target_file="$target_dir/${subdir}/${base_name}.prompt.md"
                            fi
                        fi

                        # Create subdirectories if needed
                        target_subdir=$(dirname "$target_file")
                        mkdir -p "$target_subdir"

                        cp "$source_file" "$target_file"
                        log_debug "Copied: $(basename "$target_file")"
                    done
                    log_info "Copied files with .prompt.md extension"
                else
                    log_dry_run "Would copy files from $shared_commands to $target_dir"
                fi
                ;;
            *)
                log_error "Invalid installation method: $method"
                return 1
                ;;
        esac
    else
        log_warn "Shared commands directory not found: $shared_commands_dir"
    fi

    # Install references (support documentation for commands)
    local shared_references="$DOTFILES_DIR/agents/_shared/references"
    if [[ -d "$shared_references" ]]; then
        local ref_target="$target_dir/../references"
        case $method in
            symlink)
                if [[ "$DRY_RUN" != true ]]; then
                    mkdir -p "$(dirname "$ref_target")"
                fi
                create_symlink "$shared_references" "$ref_target"
                ;;
            copy)
                if [[ "$DRY_RUN" != true ]]; then
                    mkdir -p "$(dirname "$ref_target")"
                fi
                copy_files "$shared_references" "$ref_target"
                ;;
        esac
    fi

    # Verify installation
    _verify_copilot_installation "$target_dir"

    return 0
}

# Verify Copilot installation
_verify_copilot_installation() {
    local target_dir="$1"

    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would verify Copilot installation at: $target_dir"
        return 0
    fi

    local errors=0

    # Check if target exists (could be symlink or directory)
    if [[ -e "$target_dir" ]]; then
        # Count .prompt.md files
        local prompt_count=$(find -L "$target_dir" -name "*.prompt.md" -type f 2>/dev/null | wc -l)
        if [[ $prompt_count -gt 0 ]]; then
            log_success "Prompts verified ($prompt_count prompt files found)"
        else
            log_warn "No .prompt.md files found in: $target_dir"
            ((errors++))
        fi
    else
        log_error "Target directory not found: $target_dir"
        ((errors++))
    fi

    if [[ $errors -eq 0 ]]; then
        log_success "GitHub Copilot installation verified at: $target_dir"
        return 0
    else
        log_error "GitHub Copilot installation verification failed ($errors errors)"
        return 1
    fi
}

# Show activation instructions for workspace installation
_show_copilot_activation_instructions() {
    if [[ "$DRY_RUN" == true ]]; then
        return 0
    fi

    echo ""
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_info "  GitHub Copilot Activation Required"
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "To enable prompt files in your workspace, add to .vscode/settings.json:"
    echo ""
    echo '  {'
    echo '    "chat.promptFiles": true'
    echo '  }'
    echo ""
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# List available Copilot prompts
list_copilot_prompts() {
    local target_dir="$1"

    if [[ ! -e "$target_dir" ]]; then
        log_warn "Prompts directory not found: $target_dir"
        return 1
    fi

    echo ""
    echo "Available GitHub Copilot prompts:"
    echo ""

    # Find all prompt files (follow symlinks with -L)
    while IFS= read -r -d '' file; do
        local prompt_name=$(basename "$file" .prompt.md)
        echo "  • $prompt_name"

        # Show first line as description (if available)
        local first_line=$(head -n 1 "$file" 2>/dev/null | sed 's/^[[:space:]]*//' | sed 's/^<!-- //' | sed 's/ -->$//')
        if [[ -n "$first_line" && "$first_line" != "<!--" ]]; then
            echo "    $first_line"
        fi
    done < <(find -L "$target_dir" -name "*.prompt.md" -type f -print0 2>/dev/null | sort -z)

    echo ""
}

# Uninstall GitHub Copilot
uninstall_copilot() {
    local mode="$1"

    log_info "Uninstalling GitHub Copilot..."

    if [[ "$mode" == "home" || "$mode" == "both" ]]; then
        local home_dir=$(_get_copilot_home_dir)
        if [[ -n "$home_dir" ]]; then
            _uninstall_copilot_from_target "$home_dir"
        fi
    fi

    if [[ "$mode" == "workspace" || "$mode" == "both" ]]; then
        _uninstall_copilot_from_target "$(pwd)/.github/prompts"
    fi

    log_success "GitHub Copilot uninstalled"
}

# Internal function to uninstall from target
_uninstall_copilot_from_target() {
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
export -f install_copilot uninstall_copilot list_copilot_prompts
