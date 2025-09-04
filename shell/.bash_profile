### Added by Codeium. These lines cannot be automatically removed if modified
if command -v termium > /dev/null 2>&1; then
  eval "$(termium shell-hook show pre)"
fi
### End of Codeium integration

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/daniel/.sdkman"
[[ -s "/Users/daniel/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/daniel/.sdkman/bin/sdkman-init.sh"

# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"

source /Users/daniel/.docker/init-bash.sh || true # Added by Docker Desktop
. "$HOME/.cargo/env"

# >>> coursier install directory >>>
export PATH="$PATH:/Users/daniel/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/Users/daniel/.juliaup/bin:*)
        ;;

    *)
        export PATH=/Users/daniel/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<

### Added by Codeium. These lines cannot be automatically removed if modified
if command -v termium > /dev/null 2>&1; then
  eval "$(termium shell-hook show post)"
fi
### End of Codeium integration