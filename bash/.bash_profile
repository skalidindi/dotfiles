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

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/skalidindi/.sdkman"
[[ -s "/Users/skalidindi/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/skalidindi/.sdkman/bin/sdkman-init.sh"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/skalidindi/.lmstudio/bin"
# End of LM Studio CLI section
