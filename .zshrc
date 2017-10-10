#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Execute bash_profile
source ~/.bash_profile

# Custom binds
bindkey -e
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

# Overwrite Prezto defaults (Live dangerously)
unalias rm
unalias cp
unalias mv

# jEnv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init - --no-rehash)"
(jenv rehash &) 2> /dev/null
