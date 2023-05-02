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

# Option to change to Starship instead of pure
# eval "$(starship init zsh)"

# znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-history-substring-search
znap source ohmyzsh/ohmyzsh lib/git plugins/git

# znap eval brew '/opt/homebrew/bin/brew shellenv'
eval "$(/opt/homebrew/bin/brew shellenv)"

# znap eval z 'zoxide init zsh'
eval "$(zoxide init zsh)"

# znap eval fnm 'fnm env --use-on-cd'
eval "$(fnm env --use-on-cd)"

# Execute bash_profile
source ~/.bash_profile

# Update function path
fpath=(~/.zsh.d/ $fpath)
