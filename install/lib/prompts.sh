#!/bin/bash
# Interactive prompts for dotfiles installation

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Prompt for installation target (home vs workspace)
prompt_installation_target() {
    print_section "Installation Target"

    cat >&2 << 'EOF'
Where do you want to install AI agent configurations?

  1) Home directory (~/.claude, ~/.augment, etc.)
     • Available globally for all projects
     • Persists across terminal sessions

  2) Current workspace (project-specific)
     • Only available in this project
     • Can be committed to version control

  3) Both
     • Install in both locations

EOF

    while true; do
        read -p "Select option [1-3]: " choice
        case $choice in
            1) echo "home"; return 0;;
            2) echo "workspace"; return 0;;
            3) echo "both"; return 0;;
            *) echo "Invalid choice. Please select 1, 2, or 3." >&2;;
        esac
    done
}

# Prompt for AI agents to install
prompt_agent_selection() {
    print_section "AI Agent Selection"

    echo "Which AI agents do you use?" >&2
    echo "" >&2

    local agents=("augment" "claude" "copilot" "windsurf" "antigravity")
    local agent_names=("Augment Code" "Claude Code" "GitHub Copilot" "Windsurf" "Antigravity")
    local agent_dirs=("~/.augment" "~/.claude" ".github/prompts" "~/.codeium/windsurf" "~/.gemini/windsurf")
    local selected=()

    # Default: Claude is pre-selected
    selected[1]=true

    # Simple checkbox implementation
    local current=0

    # For non-interactive mode or if tput not available, use simple prompt
    if [[ ! -t 0 ]] || ! command_exists tput; then
        for i in "${!agents[@]}"; do
            local default="n"
            [[ "${selected[$i]}" == "true" ]] && default="y"

            echo -n "[${selected[$i]:+ }] ${agent_names[$i]} (${agent_dirs[$i]}) - Install? [y/N]: " >&2
            read -r answer
            answer="${answer:-$default}"

            if [[ "$answer" =~ ^[Yy]$ ]]; then
                selected[$i]=true
            else
                selected[$i]=false
            fi
        done
    else
        # Interactive mode with visual selection
        echo "Instructions: Toggle by number (comma-separated, e.g., 1,2,5)" >&2
        echo "" >&2

        for i in "${!agents[@]}"; do
            local mark=" "
            [[ "${selected[$i]}" == "true" ]] && mark="✓"
            printf "  [%s] %d) %s\n" "$mark" "$((i+1))" "${agent_names[$i]}" >&2
        done
        echo "" >&2

        read -p "Toggle selections: " choices

        IFS=',' read -ra CHOICE_ARRAY <<< "$choices"
        for choice in "${CHOICE_ARRAY[@]}"; do
            choice=$(echo "$choice" | xargs) # trim whitespace
            if [[ "$choice" =~ ^[1-5]$ ]]; then
                local idx=$((choice - 1))
                if [[ "${selected[$idx]}" == "true" ]]; then
                    selected[$idx]=false
                else
                    selected[$idx]=true
                fi
            fi
        done
    fi

    # Return selected agents as space-separated string
    local result=()
    for i in "${!agents[@]}"; do
        if [[ "${selected[$i]}" == "true" ]]; then
            result+=("${agents[$i]}")
        fi
    done

    echo "${result[@]}"
}

# Prompt for installation method (symlink vs copy)
prompt_installation_method() {
    print_section "Installation Method"

    cat >&2 << 'EOF'
How do you want to install?

  1) Symlink (recommended)
     • Changes to dotfiles repository immediately reflected
     • Best for active development

  2) Copy files
     • Independent copy of configurations
     • Safer for production use

EOF

    while true; do
        read -p "Select option [1-2]: " choice
        case $choice in
            1) echo "symlink"; return 0;;
            2) echo "copy"; return 0;;
            *) echo "Invalid choice. Please select 1 or 2." >&2;;
        esac
    done
}

# Display installation plan
display_installation_plan() {
    local target="$1"
    local agents="$2"
    local method="$3"

    print_section "Installation Plan"

    echo "Target: $target" >&2
    echo "Method: $method" >&2
    echo "Agents: $agents" >&2
    echo "" >&2

    for agent in $agents; do
        case $agent in
            augment)
                if [[ "$target" == "home" || "$target" == "both" ]]; then
                    echo "  ✓ Augment Code → ~/.augment/commands/" >&2
                fi
                if [[ "$target" == "workspace" || "$target" == "both" ]]; then
                    echo "  ✓ Augment Code → ./.augment/commands/" >&2
                fi
                ;;
            claude)
                if [[ "$target" == "home" || "$target" == "both" ]]; then
                    echo "  ✓ Claude Code → ~/.claude/commands/ & ~/.claude/agents/" >&2
                fi
                if [[ "$target" == "workspace" || "$target" == "both" ]]; then
                    echo "  ✓ Claude Code → ./.claude/commands/ & ./.claude/agents/" >&2
                fi
                ;;
            copilot)
                if [[ "$target" == "home" || "$target" == "both" ]]; then
                    echo "  ✓ GitHub Copilot → ~/Library/Application Support/Code/User/prompts" >&2
                fi
                if [[ "$target" == "workspace" || "$target" == "both" ]]; then
                    echo "  ✓ GitHub Copilot → ./.github/prompts/" >&2
                fi
                ;;
            windsurf)
                if [[ "$target" == "home" || "$target" == "both" ]]; then
                    echo "  ✓ Windsurf → ~/.codeium/windsurf/global_workflows" >&2
                fi
                if [[ "$target" == "workspace" || "$target" == "both" ]]; then
                    echo "  ✓ Windsurf → ./.windsurf/workflows/" >&2
                fi
                ;;
            antigravity)
                if [[ "$target" == "home" || "$target" == "both" ]]; then
                    echo "  ✓ Antigravity → ~/.gemini/windsurf/global_workflows" >&2
                fi
                if [[ "$target" == "workspace" || "$target" == "both" ]]; then
                    echo "  ✓ Antigravity → ./.windsurf/workflows/" >&2
                fi
                ;;
        esac
    done

    echo "" >&2
}

# Confirm installation
confirm_installation() {
    ask_yes_no "Proceed with installation?" "y"
}

# Export functions
export -f prompt_installation_target prompt_agent_selection
export -f prompt_installation_method display_installation_plan
export -f confirm_installation
