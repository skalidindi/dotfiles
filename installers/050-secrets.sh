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

  # Older Stow runs could leave ~/.env-secrets linked into the repository.
  # Remove only that legacy link before installing the real home-owned file.
  if [[ -L "$destination" ]]; then
    linked_path="$(readlink "$destination")"
    case "$linked_path" in
      */env/.env-secrets|*/oss/dotfiles/env/.env-secrets)
        rm -f "$destination"
        ;;
      *)
        echo "Refusing to replace unexpected symlink: $destination" >&2
        exit 1
        ;;
    esac
  fi

  mv -f "$temporary" "$destination"
  trap - EXIT
else
  echo "Encrypted file env/.env-secrets.gpg not found."
fi
