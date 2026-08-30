#!/usr/bin/env bash

# Load the shell dotfiles:
for file in ~/.{path,exports,aliases,functions}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

if [ -d "$HOME/.config/dotfiles/shell" ]; then
  for file in "$HOME"/.config/dotfiles/shell/*.sh; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
  done
  unset file
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section
