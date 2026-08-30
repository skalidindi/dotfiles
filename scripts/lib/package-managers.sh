#!/usr/bin/env bash

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

find_nix() {
  if [[ -n "${NIX_BIN:-}" ]]; then
    [[ -x "$NIX_BIN" ]] || return 1
    printf '%s\n' "$NIX_BIN"
    return 0
  fi

  if command -v nix >/dev/null 2>&1; then
    command -v nix
    return 0
  fi

  if [[ -x /nix/var/nix/profiles/default/bin/nix ]]; then
    printf '%s\n' /nix/var/nix/profiles/default/bin/nix
    return 0
  fi

  return 1
}
