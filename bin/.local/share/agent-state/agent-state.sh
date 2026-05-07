#!/usr/bin/env bash

agent_count_lines() {
  local file="$1"

  if [ ! -f "$file" ]; then
    printf '0'
    return
  fi

  sed '/^[[:space:]]*$/d' "$file" | wc -l | tr -d ' '
}

agent_profile_file() {
  local dotfiles_dir="$1"
  local profile="$2"
  local suffix="$3"
  local candidate

  for candidate in \
    "$HOME/.agents/profiles/${profile}.${suffix}" \
    "$dotfiles_dir/agents/.agents/profiles/${profile}.${suffix}"; do
    if [ -f "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

agent_write_profile_items() {
  local dotfiles_dir="$1"
  local suffix="$2"
  local output="$3"
  shift 3

  : >"$output"
  local profile
  local file
  for profile in "$@"; do
    if ! file="$(agent_profile_file "$dotfiles_dir" "$profile" "$suffix")"; then
      printf 'unknown profile: %s\n' "$profile" >&2
      return 64
    fi
    sed '/^[[:space:]]*$/d; /^[[:space:]]*#/d' "$file" >>"$output"
  done

  sort -u "$output" -o "$output"
}

agent_write_profile_skills() {
  agent_write_profile_items "$1" skills "$2" "${@:3}"
}

agent_write_profile_mcps() {
  agent_write_profile_items "$1" mcp "$2" "${@:3}"
}

agent_write_active_skills() {
  local dir="$1"
  local output="$2"

  : >"$output"
  if [ ! -d "$dir" ]; then
    return 0
  fi

  find "$dir" -maxdepth 2 -name SKILL.md -print 2>/dev/null \
    | sed "s#^$dir/##; s#/SKILL.md\$##" \
    | sort -u >"$output"
}

agent_write_active_codex_mcps() {
  local file="$1"
  local output="$2"

  : >"$output"
  [ -f "$file" ] || return 0
  sed -n 's/^\[mcp_servers\.\([^].]*\).*/\1/p' "$file" | sort -u >"$output"
}

agent_write_active_json_mcps() {
  local file="$1"
  local output="$2"

  : >"$output"
  [ -f "$file" ] || return 0
  jq -r '.mcpServers // {} | keys[]' "$file" | sort -u >"$output"
}
