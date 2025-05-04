source ~/znap/zsh-snap/znap.zsh
# Download Znap, if it's not there yet.
[[ -f ~/znap/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/znap/zsh-snap

##
# Source Znap at the start of your .zshrc file.
#
source ~/znap/zsh-snap/znap.zsh

# Navigation in tmux works better with this
bindkey -e

# Plugins
# `znap prompt` makes your prompt visible in just 15-40ms!
znap prompt sindresorhus/pure

znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-history-substring-search
znap source ohmyzsh/ohmyzsh lib/git plugins/git

## temp fix for https://github.com/marlonrichert/zsh-snap/issues/211
znap eval brew '/opt/homebrew/bin/brew shellenv'

eval "$(zoxide init zsh)"
znap eval zoxide '$(zoxide init zsh)'

znap eval fnm 'fnm env --use-on-cd'

eval "$(pyenv init -)"

# Execute bash_profile
source ~/.bash_profile

# Update function path
fpath=(~/.zsh.d/ $fpath)

# bun completions
[ -s "/Users/skalidindi/.bun/_bun" ] && source "/Users/skalidindi/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Load API keys
source ~/.env-secrets

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# pnpm
export PNPM_HOME="/Users/skalidindi/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
