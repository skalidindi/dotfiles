#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./bootstrap.sh
  ./bootstrap.sh --profile base
  ./bootstrap.sh --list

Options:
  --profile base Run only portable configuration installers.
  --list     List bootstrap installer slices.
  -h, --help Show this help.
EOF
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
installer_dir="$repo_root/installers"
profile="full"

list_installers() {
  if [[ "$profile" == "base" ]]; then
    printf '%s\n' "$installer_dir/010-stow.sh" "$installer_dir/020-agent-assets.sh"
  else
    find "$installer_dir" -maxdepth 1 -type f -name '*.sh' | sort
  fi
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --profile)
      [[ "$#" -ge 2 && "$2" == "base" ]] || {
        printf 'bootstrap: --profile requires base\n' >&2
        exit 64
      }
      profile="$2"
      shift 2
      ;;
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
