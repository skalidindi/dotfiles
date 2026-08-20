#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
config_file="$root_dir/nushell/Library/Application Support/nushell/config.nu"

assert_agent_launcher_sets_herdr_hint() {
  local agent="$1"
  local sandbox output

  sandbox="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-herdr-agent.XXXXXXXX")"
  trap 'rm -rf "$sandbox"' RETURN

  cat >"$sandbox/$agent" <<'EOF'
#!/usr/bin/env bash
printf '%s' "${HERDR_AGENT:-}"
EOF
  chmod +x "$sandbox/$agent"

  output="$(nu --no-config-file -c "source '$config_file'; \$env.PATH = ['$sandbox', ...\$env.PATH]; $agent")"
  [[ "$output" == "$agent" ]] || {
    printf 'FAIL: %s should set HERDR_AGENT=%s; got %s\n' "$agent" "$agent" "$output" >&2
    exit 1
  }
}

if ! "$root_dir/bootstrap.sh" --profile base --list >/dev/null; then
  printf 'FAIL: bootstrap should accept the base profile\n' >&2
  exit 1
fi

if ! nu --no-config-file -c "source '$config_file'" >/dev/null 2>&1; then
  printf 'FAIL: Nushell config should parse without a runtime source path\n' >&2
  exit 1
fi

assert_agent_launcher_sets_herdr_hint claude
assert_agent_launcher_sets_herdr_hint codex
assert_agent_launcher_sets_herdr_hint pi

printf 'PASS: Nushell configuration tests\n'
