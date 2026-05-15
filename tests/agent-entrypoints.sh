#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_not_tracked() {
  local path="$1"

  if git -C "$root_dir" ls-files --error-unmatch "$path" >/dev/null 2>&1; then
    fail "$path should not be tracked; agent CLIs are installer-managed"
  fi
}

assert_not_allowlisted() {
  local path="$1"

  if grep -Fxq "!$path" "$root_dir/.gitignore"; then
    fail "$path should not be allowlisted in .gitignore"
  fi
}

assert_not_present() {
  local path="$1"

  if [ -e "$root_dir/$path" ]; then
    fail "$path should not exist"
  fi
}

assert_line() {
  local file="$1"
  local line="$2"

  grep -Fxq "$line" "$root_dir/$file" ||
    fail "$file should contain: $line"
}

assert_not_tracked "bin/.local/bin/codex"
assert_not_tracked "bin/.local/bin/claude"
assert_not_allowlisted "bin/.local/bin/codex"
assert_not_allowlisted "bin/.local/bin/claude"

removed_awake_path="bin/.local/bin/agent-""awake"
assert_not_present "$removed_awake_path"
assert_not_allowlisted "$removed_awake_path"

assert_line "bin/.local/bin/zellij-sessionizer" '    zellij attach "$session_name" --create'
assert_line "nushell/Library/Application Support/nushell/config.nu" '        ^zellij attach $session_name --create'

printf 'PASS: agent entrypoint tests\n'
