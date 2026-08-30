#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
nix_bin="$(command -v nix 2>/dev/null || true)"

if [[ -z "$nix_bin" && -x /nix/var/nix/profiles/default/bin/nix ]]; then
  nix_bin=/nix/var/nix/profiles/default/bin/nix
fi

if [[ -z "$nix_bin" ]]; then
  echo "Nix not found; skipping Home Manager activation."
  exit 0
fi

echo "Activating Home Manager..."
cd "$repo_root"
NIX_CONFIG="extra-experimental-features = nix-command flakes" \
  "$nix_bin" run .#home-manager -- switch --flake .#oss
