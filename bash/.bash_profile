#!/usr/bin/env bash

# Load the shell dotfiles:
for file in ~/.{path,exports,aliases,functions}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/skalidindi/.sdkman"
[[ -s "/Users/skalidindi/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/skalidindi/.sdkman/bin/sdkman-init.sh"
