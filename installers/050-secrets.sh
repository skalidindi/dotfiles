#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$repo_root"

if [[ -f env/.env-secrets.gpg ]]; then
  destination="$HOME/.env-secrets"
  temporary="$(mktemp "${destination}.tmp.XXXXXX")"
  trap 'rm -f "$temporary"' EXIT

  echo "Decrypting env/.env-secrets.gpg..."
  umask 077
  gpg --decrypt env/.env-secrets.gpg > "$temporary"
  chmod 600 "$temporary"
  mv -f "$temporary" "$destination"
  trap - EXIT
else
  echo "Encrypted file env/.env-secrets.gpg not found."
fi
