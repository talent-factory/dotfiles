#!/bin/bash
# Common functions for dotfiles installation

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
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

log_debug() {
    if [[ "${DEBUG:-false}" == "true" ]]; then
        echo -e "${CYAN}[DEBUG]${NC} $1"
    fi
}

# Backup existing file or directory
backup_existing() {
    local file="$1"
    local backup_dir="${2:-$BACKUP_DIR}"

    if [[ -e "$file" && ! -L "$file" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "Would backup existing $file to $backup_dir"
        else
            mkdir -p "$backup_dir"
            log_warn "Backing up existing $file to $backup_dir"
            mv "$file" "$backup_dir/"
        fi
        return 0
    elif [[ -L "$file" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "Would remove existing symlink $file"
        else
            log_info "Removing existing symlink $file"
            rm "$file"
        fi
        return 0
    fi

    return 1
}

# Create symlink
create_symlink() {
    local source="$1"
    local target="$2"

    if [[ ! -e "$source" ]]; then
        log_error "Source not found: $source"
        return 1
    fi

    backup_existing "$target"

    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would create symlink: $target -> $source"
    else
        mkdir -p "$(dirname "$target")"
        ln -sf "$source" "$target"
        log_info "Created symlink: $target -> $source"
    fi

    return 0
}

# Copy files/directories
copy_files() {
    local source="$1"
    local target="$2"

    if [[ ! -e "$source" ]]; then
        log_error "Source not found: $source"
        return 1
    fi

    backup_existing "$target"

    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would copy: $source -> $target"
    else
        mkdir -p "$(dirname "$target")"
        cp -r "$source" "$target"
        log_info "Copied: $source -> $target"
    fi

    return 0
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if directory is empty
is_empty_dir() {
    [[ -d "$1" && -z "$(ls -A "$1")" ]]
}

# Print header
print_header() {
    local title="$1"
    local width=66
    local text_width=$((width - 2))  # Subtract 2 for the "  " padding

    echo ""
    echo "╔$(printf '═%.0s' $(seq 1 $width))╗"
    printf "║  %-${text_width}s║\n" "$title"
    echo "╚$(printf '═%.0s' $(seq 1 $width))╝"
    echo ""
}

# Print section
print_section() {
    local title="$1"
    echo ""
    echo -e "${CYAN}▶ $title${NC}"
    echo ""
}

# Ask yes/no question
ask_yes_no() {
    local question="$1"
    local default="${2:-n}"
    local prompt="[y/N]"

    if [[ "$default" == "y" ]]; then
        prompt="[Y/n]"
    fi

    while true; do
        read -p "$question $prompt: " answer
        answer="${answer:-$default}"

        case "$answer" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Validate installation target
validate_target() {
    local target="$1"

    if [[ "$target" == "home" ]]; then
        return 0
    elif [[ "$target" == "workspace" ]]; then
        if [[ ! -d "$(pwd)/.git" ]]; then
            log_warn "Current directory is not a git repository"
            log_warn "Workspace installation is recommended for project directories"
            if ! ask_yes_no "Continue anyway?"; then
                return 1
            fi
        fi
        return 0
    else
        log_error "Invalid installation target: $target"
        return 1
    fi
}

# Export functions for use in other scripts
export -f log_info log_warn log_error log_success log_dry_run log_debug
export -f backup_existing create_symlink copy_files
export -f command_exists is_empty_dir
export -f print_header print_section ask_yes_no validate_target
