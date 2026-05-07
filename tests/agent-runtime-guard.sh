#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
guard="$root_dir/bin/.local/bin/agent-runtime-guard"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

make_sandbox() {
  mktemp -d "${TMPDIR:-/tmp}/dotfiles-runtime-guard.XXXXXXXX"
}

test_runtime_guard_passes_current_repo() {
  local listed_paths

  "$guard" --quiet ||
    fail "runtime guard should pass in the current repo"

  listed_paths="$("$guard" --list)"
  [[ "$listed_paths" == *"codex/.codex/auth.json"* ]] ||
    fail "runtime guard should list representative Codex auth state"
}

test_runtime_guard_fails_for_unignored_paths() {
  local sandbox status
  sandbox="$(make_sandbox)"
  trap 'rm -rf "$sandbox"' RETURN

  git -C "$sandbox" init -q

  set +e
  AGENT_RUNTIME_GUARD_ROOT="$sandbox" "$guard" --quiet
  status=$?
  set -e

  [[ "$status" -eq 1 ]] ||
    fail "runtime guard should fail when paths are not ignored"
}

test_runtime_guard_fails_for_tracked_paths() {
  local sandbox status
  sandbox="$(make_sandbox)"
  trap 'rm -rf "$sandbox"' RETURN

  git -C "$sandbox" init -q
  "$guard" --list >"$sandbox/.gitignore"
  mkdir -p "$sandbox/env"
  : >"$sandbox/env/.env-secrets"
  git -c core.fsmonitor=false -C "$sandbox" add -f env/.env-secrets

  set +e
  AGENT_RUNTIME_GUARD_ROOT="$sandbox" "$guard" --quiet
  status=$?
  set -e

  [[ "$status" -eq 1 ]] ||
    fail "runtime guard should fail when an ignored runtime path is tracked"
}

test_runtime_guard_passes_current_repo
test_runtime_guard_fails_for_unignored_paths
test_runtime_guard_fails_for_tracked_paths

printf 'PASS: agent runtime guard tests\n'
