# Navigation in tmux works better with this
bindkey -e

# Download antigen, if it's not there yet.
if [ ! -d "${ZDOTDIR:-$HOME}/.antidote" ]; then
  echo "Antidote not found. Cloning Antidote..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "${ZDOTDIR:-$HOME}/.antidote"
fi

eval $(/opt/homebrew/bin/brew shellenv)

# Source antidote at the start of your .zshrc file.
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

# Load Plugins from .zsh_plugins.txt
antidote load

# znap eval fnm 'fnm env --use-on-cd'
autoload -Uz promptinit && promptinit
prompt pure

# Execute bash_profile
source ~/.bash_profile

# Update function path
fpath+=("~/.zsh.d")

# Zoxide
eval "$(zoxide init zsh)"

# FNM
eval "$(fnm env --use-on-cd --shell zsh)"

# Bun
eval "$(bun completions zsh)"

# Rust
. "$HOME/.cargo/env"

# Load API keys
source ~/.env-secrets

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
