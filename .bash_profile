#!/usr/bin/env bash

# Load Bash aliases
if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

# .profile
if [ -n "$BASH" ] && [ -r ~/.bashrc ]; then
    . ~/.bashrc
fi
