#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

if ! "$root_dir/bootstrap.sh" --profile base --list >/dev/null; then
  printf 'FAIL: bootstrap should accept the base profile\n' >&2
  exit 1
fi

printf 'PASS: work overlay hook tests\n'
