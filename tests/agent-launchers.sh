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

write_fake_agent_awake() {
  local path="$1"
  cat >"$path" <<'SH'
#!/usr/bin/env bash
printf 'agent-awake:'
printf ' %s' "$@"
printf '\n'
SH
  chmod +x "$path"
}

test_agent_wrapper_resolves_real_command_and_calls_agent_awake_for_tty() {
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
  write_fake_agent_awake "$wrappers/agent-awake"

  cat >"$sandbox/run-agent" <<SH
#!/usr/bin/env bash
unset AGENT_AWAKE_ACTIVE AGENT_AWAKE_DISABLE
PATH="$wrappers:$real:/usr/bin:/bin" exec "$wrappers/$agent" --version
SH
  chmod +x "$sandbox/run-agent"

  set +e
  output="$(script -q /dev/null "$sandbox/run-agent" 2>&1)"
  set -e

  [[ "$output" == *"agent-awake: $real/$agent --version"* ]] ||
    fail "$agent wrapper should call agent-awake with the real command for TTY runs; got: $output"
}

test_agent_wrapper_runs_real_command_directly_when_not_interactive() {
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
  write_fake_agent_awake "$wrappers/agent-awake"

  output="$(PATH="$wrappers:$real:/usr/bin:/bin" "$wrappers/$agent" --version 2>&1)"

  [[ "$output" == *"real-agent:$real/$agent"* ]] ||
    fail "$agent wrapper should run the real command directly without a TTY; got: $output"
  [[ "$output" == *"args: --version"* ]] ||
    fail "$agent wrapper should preserve args when running directly; got: $output"
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

for agent in codex claude; do
  test_agent_wrapper_resolves_real_command_and_calls_agent_awake_for_tty "$agent"
  test_agent_wrapper_runs_real_command_directly_when_not_interactive "$agent"
  test_agent_wrapper_reports_missing_real_command "$agent"
done

printf 'PASS: agent launcher tests\n'
