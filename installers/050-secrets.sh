#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$repo_root"

if [[ -f env/.env-secrets.gpg ]]; then
  echo "Decrypting env/.env-secrets.gpg..."
  gpg --decrypt env/.env-secrets.gpg > env/.env-secrets
else
  echo "Encrypted file env/.env-secrets.gpg not found."
fi
