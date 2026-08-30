#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

for required_dir in config scripts/bin; do
  [[ -d "$root_dir/$required_dir" ]] ||
    fail "$required_dir should contain declarative source material"
done

for legacy_path in bin/.local/bin claude codex cursor; do
  [[ ! -e "$root_dir/$legacy_path" && ! -L "$root_dir/$legacy_path" ]] ||
    fail "$legacy_path should not exist"
done

printf 'PASS: declarative source layout\n'
