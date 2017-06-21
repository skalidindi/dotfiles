#!/usr/bin/env bash

# Load Bash aliases
if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

# Cask
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# .profile
if [ -n "$BASH" ] && [ -r ~/.bashrc ]; then
    . ~/.bashrc
fi
