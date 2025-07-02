export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/dev/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/dev/.lmstudio/bin"
# End of LM Studio CLI section

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

export ANDROID_HOME=$HOME/Library/Android/sdk && export PATH=$PATH:$ANDROID_HOME/emulator && export PATH=$PATH:$ANDROID_HOME/platform-tools

# Added by Windsurf
export PATH="/Users/dev/.codeium/windsurf/bin:$PATH"

eval "$(starship init zsh)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# Warp-like autosuggestions & syntax colors
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source <(fzf --zsh)

eval "$(zoxide init zsh)"
alias cd="z"

eval "$(thefuck --alias)"
eval $(thefuck --alias fk)

alias ls="eza -la --icons=always"

source $HOME/.local/bin/env
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
export VCPKG_ROOT="$HOME/vcpkg"
