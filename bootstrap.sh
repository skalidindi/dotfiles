#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./bootstrap.sh
  ./bootstrap.sh --list

Options:
  --list     List bootstrap installer slices.
  -h, --help Show this help.
EOF
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
installer_dir="$repo_root/installers"

list_installers() {
  find "$installer_dir" -maxdepth 1 -type f -name '*.sh' | sort
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --list)
      list_installers
      exit 0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'bootstrap: unknown option: %s\n' "$1" >&2
      usage >&2
      exit 64
      ;;
  esac
done

cd "$repo_root"

while IFS= read -r installer; do
  [ -n "$installer" ] || continue
  printf 'Running %s\n' "${installer#$repo_root/}"
  bash "$installer"
done < <(list_installers)

echo "Bootstrap completed!"
