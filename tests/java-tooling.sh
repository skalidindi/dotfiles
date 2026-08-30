#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

if rg -n -i 'sdkman' "$root_dir/bash" "$root_dir/Brewfile" >/dev/null; then
  printf 'FAIL: OSS shell configuration should not initialize SDKMAN\n' >&2
  exit 1
fi

grep -Fxq 'brew "gradle"' "$root_dir/Brewfile" || {
  printf 'FAIL: global Homebrew Gradle should remain declared\n' >&2
  exit 1
}

printf 'PASS: Java tooling ownership tests\n'
