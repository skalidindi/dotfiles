#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

if git -C "$root_dir" ls-files -s 'tmux/.config/tmux/plugins/*' | grep -q .; then
  printf 'FAIL: stale tmux .config plugin gitlinks remain\n' >&2
  exit 1
fi

git -C "$root_dir" submodule status --recursive >/dev/null

printf 'PASS: tmux submodule tests\n'
