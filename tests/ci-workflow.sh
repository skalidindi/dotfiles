#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
workflow="$root_dir/.github/workflows/verify.yml"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

[[ -f "$workflow" ]] || fail "the CI verification workflow should exist"

for required in \
  'push:' \
  'pull_request:' \
  'branches: [main]' \
  'permissions:' \
  'contents: read' \
  'runs-on: macos-14' \
  'actions/checkout@fbc6f3992d24b796d5a048ff273f7fcc4a7b6c09' \
  'DeterminateSystems/nix-installer-action@ef8a148080ab6020fd15196c2084a2eea5ff2d25' \
  'for test in tests/*.sh; do bash "$test" || exit 1; done' \
  "nix --extra-experimental-features 'nix-command flakes' flake check"; do
  grep -Fq "$required" "$workflow" ||
    fail "the CI verification workflow should contain $required"
done

for prohibited in 'darwin-rebuild' 'scripts/bootstrap' 'scripts/update' 'brew' 'flake check --all-systems'; do
  if grep -Fq "$prohibited" "$workflow"; then
    fail "the CI verification workflow should not run $prohibited"
  fi
done

printf 'PASS: CI workflow validates the Apple Silicon Nix configuration without activation\n'
