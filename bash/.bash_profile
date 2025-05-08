#!/usr/bin/env bash

# Load the shell dotfiles:
for file in ~/.{path,exports,aliases,functions,private_functions}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file
