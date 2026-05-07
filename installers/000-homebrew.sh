#!/usr/bin/env bash
set -euo pipefail

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

if brew_bin="$(find_brew)"; then
  eval "$("$brew_bin" shellenv)"
  echo "Homebrew already installed."
  exit 0
fi

echo "Homebrew not found. Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if brew_bin="$(find_brew)"; then
  eval "$("$brew_bin" shellenv)"
else
  printf 'bootstrap: Homebrew installer completed but brew was not found\n' >&2
  exit 1
fi
