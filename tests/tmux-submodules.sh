#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

if git -C "$root_dir" ls-files -s 'tmux/.tmux/plugins/*' | grep -q .; then
  printf 'FAIL: tmux TPM submodule should not remain\n' >&2
  exit 1
fi

if [[ -f "$root_dir/.gitmodules" ]]; then
  printf 'FAIL: .gitmodules should be removed after the TPM migration\n' >&2
  exit 1
fi

printf 'PASS: tmux submodule tests\n'
