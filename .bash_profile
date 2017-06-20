#!/usr/bin/env bash

# Load Bash aliases
if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

# Cask
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Default editor for git
export EDITOR='atom -wn'

# .profile
if [ -n "$BASH" ] && [ -r ~/.bashrc ]; then
    . ~/.bashrc
fi
