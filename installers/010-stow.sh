#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$repo_root"

find_brew() {
  local candidate

  if [[ -n "${HOMEBREW_PREFIX:-}" && -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
    printf '%s\n' "$HOMEBREW_PREFIX/bin/brew"
    return 0
  fi

  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  command -v brew 2>/dev/null
}

if ! command -v stow >/dev/null 2>&1; then
  if brew_bin="$(find_brew)"; then
    eval "$(\"$brew_bin\" shellenv)"
  fi
fi

echo "Running stow for dotfiles..."
# Claude and Codex homes are mutable runtime directories. Their portable assets
# are applied by install-agent-assets and Home Manager; do not stow either home.
stow_dirs=(bin)

for dir in "${stow_dirs[@]}"; do
  if [[ -d "$dir" ]]; then
    echo "Stowing $dir"
    stow -t "$HOME" -R "$dir"
  fi
done
