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

for setup_doc in config/agents/README.md config/nvim/README.md; do
  if grep -Fq './bootstrap.sh' "$root_dir/$setup_doc"; then
    fail "$setup_doc should refer to scripts/bootstrap, not the retired root entrypoint"
  fi
  grep -Fq './scripts/bootstrap' "$root_dir/$setup_doc" ||
    fail "$setup_doc should document the current bootstrap entrypoint"
done

agent_setup="$(tr '\n' ' ' <"$root_dir/config/agents/README.md")"
if grep -Eiq 'bootstrap[^.]*followed by[^.]*activation' <<<"$agent_setup"; then
  fail "agent setup should not advertise a separate Home Manager activation step"
fi

printf 'PASS: declarative source layout\n'
