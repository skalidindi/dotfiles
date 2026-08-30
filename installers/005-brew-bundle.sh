#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

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

if [[ ! -f "$repo_root/Brewfile" ]]; then
  echo "No Brewfile found, skipping brew bundle."
  exit 0
fi

if brew_bin="$(find_brew)"; then
  eval "$("$brew_bin" shellenv)"
else
  printf 'bootstrap: brew not found; skipping Brewfile\n' >&2
  exit 0
fi

echo "Running brew bundle..."
brew bundle --file="$repo_root/Brewfile"
