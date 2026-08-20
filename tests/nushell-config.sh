#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
config_file="$root_dir/nushell/Library/Application Support/nushell/config.nu"

if ! "$root_dir/bootstrap.sh" --profile base --list >/dev/null; then
  printf 'FAIL: bootstrap should accept the base profile\n' >&2
  exit 1
fi

if ! nu --no-config-file -c "source '$config_file'" >/dev/null 2>&1; then
  printf 'FAIL: Nushell config should parse without a runtime source path\n' >&2
  exit 1
fi

printf 'PASS: Nushell configuration tests\n'
