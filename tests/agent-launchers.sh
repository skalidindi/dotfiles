#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

make_sandbox() {
  mktemp -d "${TMPDIR:-/tmp}/dotfiles-agent-launchers.XXXXXXXX"
}

write_fake_real_agent() {
  local path="$1"
  cat >"$path" <<'SH'
#!/usr/bin/env bash
printf 'real-agent:%s\n' "$0"
printf 'args:'
printf ' %s' "$@"
printf '\n'
SH
  chmod +x "$path"
}

test_agent_wrapper_resolves_real_command_and_calls_zrun() {
  local agent="$1"
  local sandbox wrappers real output

  sandbox="$(make_sandbox)"
  trap 'rm -rf "$sandbox"' RETURN
  wrappers="$sandbox/wrappers"
  real="$sandbox/real"
  mkdir -p "$wrappers" "$real"

  cp "$root_dir/bin/.local/bin/$agent" "$wrappers/$agent"
  chmod +x "$wrappers/$agent"
  write_fake_real_agent "$real/$agent"

  cat >"$wrappers/zrun" <<'SH'
#!/usr/bin/env bash
printf 'zrun:'
printf ' %s' "$@"
printf '\n'
SH
  chmod +x "$wrappers/zrun"

  output="$(PATH="$wrappers:$real:/usr/bin:/bin" "$wrappers/$agent" --version 2>&1)"

  [[ "$output" == "zrun: $real/$agent --version" ]] ||
    fail "$agent wrapper should call zrun with the real command; got: $output"
}

test_agent_wrapper_reports_missing_real_command() {
  local agent="$1"
  local sandbox wrappers output status

  sandbox="$(make_sandbox)"
  trap 'rm -rf "$sandbox"' RETURN
  wrappers="$sandbox/wrappers"
  mkdir -p "$wrappers"

  cp "$root_dir/bin/.local/bin/$agent" "$wrappers/$agent"
  chmod +x "$wrappers/$agent"

  set +e
  output="$(PATH="$wrappers:/usr/bin:/bin" "$wrappers/$agent" 2>&1)"
  status=$?
  set -e

  [[ "$status" -eq 69 ]] ||
    fail "$agent wrapper should exit 69 when the real command is missing"
  [[ "$output" == *"$agent wrapper: could not find real $agent binary on PATH"* ]] ||
    fail "$agent wrapper should explain missing real command"
}

for agent in codex claude pi; do
  test_agent_wrapper_resolves_real_command_and_calls_zrun "$agent"
  test_agent_wrapper_reports_missing_real_command "$agent"
done

printf 'PASS: agent launcher tests\n'
