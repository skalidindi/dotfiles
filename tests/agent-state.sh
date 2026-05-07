#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

# shellcheck source=../bin/.local/share/agent-state/agent-state.sh
source "$root_dir/bin/.local/share/agent-state/agent-state.sh"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

make_sandbox() {
  mktemp -d "${TMPDIR:-/tmp}/dotfiles-agent-state.XXXXXXXX"
}

test_profile_items_ignore_blanks_comments_and_sort() {
  local sandbox output actual

  sandbox="$(make_sandbox)"
  trap 'rm -rf "$sandbox"' RETURN
  mkdir -p "$sandbox/agents/.agents/profiles"
  output="$sandbox/output"

  cat >"$sandbox/agents/.agents/profiles/core.skills" <<'EOF'
# comment
zeta

alpha
EOF

  HOME="$sandbox/home" agent_write_profile_skills "$sandbox" "$output" core
  actual="$(tr '\n' ' ' <"$output" | sed 's/[[:space:]]*$//')"

  [[ "$actual" == "alpha zeta" ]] ||
    fail "profile items should be cleaned and sorted; got: $actual"
}

test_active_skill_inventory() {
  local sandbox output actual

  sandbox="$(make_sandbox)"
  trap 'rm -rf "$sandbox"' RETURN
  output="$sandbox/output"

  mkdir -p "$sandbox/skills/foo"
  : >"$sandbox/skills/foo/SKILL.md"

  agent_write_active_skills "$sandbox/skills" "$output"
  actual="$(tr '\n' ' ' <"$output" | sed 's/[[:space:]]*$//')"

  [[ "$actual" == "foo" ]] ||
    fail "active skill inventory should use skill-relative names; got: $actual"
}

test_active_mcp_inventory() {
  local sandbox output actual

  sandbox="$(make_sandbox)"
  trap 'rm -rf "$sandbox"' RETURN
  output="$sandbox/output"

  cat >"$sandbox/config.toml" <<'EOF'
[mcp_servers.alpha]
command = "a"
[mcp_servers.beta.env]
X = "1"
[mcp_servers.beta]
command = "b"
EOF

  agent_write_active_codex_mcps "$sandbox/config.toml" "$output"
  actual="$(tr '\n' ' ' <"$output" | sed 's/[[:space:]]*$//')"

  [[ "$actual" == "alpha beta" ]] ||
    fail "Codex MCP inventory should collapse nested server tables; got: $actual"

  cat >"$sandbox/mcp.json" <<'EOF'
{"mcpServers":{"beta":{},"alpha":{}}}
EOF
  agent_write_active_json_mcps "$sandbox/mcp.json" "$output"
  actual="$(tr '\n' ' ' <"$output" | sed 's/[[:space:]]*$//')"

  [[ "$actual" == "alpha beta" ]] ||
    fail "JSON MCP inventory should list keys; got: $actual"
}

test_profile_items_ignore_blanks_comments_and_sort
test_active_skill_inventory
test_active_mcp_inventory

printf 'PASS: agent state tests\n'
