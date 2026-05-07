#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$repo_root"

if ! command -v stow >/dev/null 2>&1; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

echo "Running stow for dotfiles..."
stow_dirs=(agents claude cmux bash bin env fastfetch gh ghostty git jj lazygit nushell nvim pi starship tmux yazi zellij zsh)

for dir in "${stow_dirs[@]}"; do
  if [[ -d "$dir" ]]; then
    echo "Stowing $dir"
    case "$dir" in
      agents|git|nushell)
        stow -t "$HOME" -R --no-folding "$dir"
        ;;
      *)
        stow -t "$HOME" -R "$dir"
        ;;
    esac
  fi
done
