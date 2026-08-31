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
  if git -C "$root_dir" ls-files --error-unmatch "$legacy_path/*" >/dev/null 2>&1; then
    fail "$legacy_path should not contain tracked source files"
  fi

  if [[ -e "$root_dir/$legacy_path" || -L "$root_dir/$legacy_path" ]]; then
    git -C "$root_dir" check-ignore -q "$legacy_path" ||
      fail "$legacy_path should be absent or ignored runtime state"
  fi
done

for setup_doc in config/nvim/README.md; do
  if grep -Fq './bootstrap.sh' "$root_dir/$setup_doc"; then
    fail "$setup_doc should refer to scripts/bootstrap, not the retired root entrypoint"
  fi
  grep -Fq './scripts/bootstrap' "$root_dir/$setup_doc" ||
    fail "$setup_doc should document the current bootstrap entrypoint"
done

grep -Fq "nix run '.#darwin-rebuild'" "$root_dir/README.md" ||
  fail "the zsh-facing Darwin activation example should quote its flake reference"

printf 'PASS: declarative source layout\n'
