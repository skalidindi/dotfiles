#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$root_dir"

if ! command -v nix >/dev/null 2>&1; then
  printf '%s\n' 'SKIP: Nix is not installed; install it manually before running the OSS pilot.'
  exit 77
fi

if [[ ! -f flake.nix || ! -f flake.lock ]]; then
  printf '%s\n' 'FAIL: flake.nix and flake.lock are required for the OSS Nix pilot.' >&2
  exit 1
fi

nix flake check

expected_commands=(
  bat
  cargo
  curl
  delta
  eza
  fd
  fzf
  git
  jq
  node
  nvim
  python3
  rg
  rustc
  starship
  stow
  tree-sitter
  uv
  wget
  yazi
  zellij
  zoxide
)

nix develop --command bash -lc '
  set -euo pipefail
  for command_name in "$@"; do
    command -v "$command_name" >/dev/null || {
      printf "FAIL: expected command is missing from the Nix shell: %s\\n" "$command_name" >&2
      exit 1
    }
  done
' bash "${expected_commands[@]}"

printf '%s\n' 'PASS: OSS Nix pilot evaluation and shell command checks'
