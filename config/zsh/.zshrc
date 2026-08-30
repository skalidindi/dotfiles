# Navigation in tmux works better with this
bindkey -e

# Keep tools that execute $SHELL -c on the POSIX-compatible login shell.
export SHELL=/bin/zsh

# Keep local completion definitions available before plugins initialize.
fpath=("$HOME/.zsh.d" $fpath)

# ez-compinit initializes completions at the first prompt and reuses the dump
# for 20 hours, which keeps new shells responsive without losing completions.
zstyle ':plugin:ez-compinit' 'use-cache' 'yes'

# Keep a larger persistent history while retaining zsh's native history format.
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=32768
setopt APPEND_HISTORY HIST_IGNORE_DUPS

# Source antidote at the start of your .zshrc file.
if [[ -r /opt/homebrew/opt/antidote/share/antidote/antidote.zsh ]]; then
  source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
elif [[ -r /usr/local/opt/antidote/share/antidote/antidote.zsh ]]; then
  source /usr/local/opt/antidote/share/antidote/antidote.zsh
fi

# Load Plugins from .zsh_plugins.txt
if [[ "$TERM" != dumb ]] && (( $+functions[antidote] )); then
  antidote load
fi

# Execute bash_profile
source ~/.bash_profile

# Starship
export STARSHIP_CACHE="${STARSHIP_CACHE:-$HOME/Library/Caches/starship}"
mkdir -p "$STARSHIP_CACHE"
eval "$(starship init zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# Rust
. "$HOME/.cargo/env"

# Load API keys when available.
if [[ -r "$HOME/.env-secrets" ]]; then
  source "$HOME/.env-secrets"
fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

if (( $+commands[wt] )) && (( $+functions[zsh-defer] )); then
  zsh-defer -c 'eval "$(command wt config shell init zsh)"'
elif (( $+commands[wt] )); then
  eval "$(command wt config shell init zsh)"
fi
# >>> XP ENV BEGIN >>>
export PATH="$HOME/xp-env/bin:$PATH"
# <<< XP ENV END <<<
