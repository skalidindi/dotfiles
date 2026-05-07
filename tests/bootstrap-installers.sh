#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

expected="$(
  cat <<EOF
$root_dir/installers/000-homebrew.sh
$root_dir/installers/010-stow.sh
$root_dir/installers/020-agent-assets.sh
$root_dir/installers/030-brew-bundle.sh
$root_dir/installers/040-global-tools.sh
$root_dir/installers/050-secrets.sh
$root_dir/installers/060-bat-theme.sh
EOF
)"

actual="$(cd "$root_dir" && ./bootstrap.sh --list)"

[[ "$actual" == "$expected" ]] ||
  fail "bootstrap --list should expose the numbered installer order"

./bootstrap.sh --help >/dev/null

printf 'PASS: bootstrap installer tests\n'
