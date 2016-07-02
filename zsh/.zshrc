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

# znap source marlonrichert/zsh-autocomplete # Bug: https://github.com/marlonrichert/zsh-autocomplete/issues/571
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-history-substring-search
znap source ohmyzsh/ohmyzsh lib/git plugins/git

znap eval z 'zoxide init zsh'

# Execute bash_profile
source ~/.bash_profile

fpath=(~/.zsh.d/ $fpath)
