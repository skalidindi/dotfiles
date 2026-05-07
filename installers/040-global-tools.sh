#!/usr/bin/env bash
set -euo pipefail

install_hunk_skill() {
  local skill_path
  local skill_dir
  local target

  if ! command -v hunk >/dev/null 2>&1; then
    return 0
  fi

  skill_path="$(hunk skill path 2>/dev/null || true)"
  if [[ -z "$skill_path" || ! -f "$skill_path" ]]; then
    echo "Hunk skill path unavailable, skipping Hunk agent skill."
    return 0
  fi

  skill_dir="$(cd "$(dirname "$skill_path")" && pwd)"
  target="$HOME/.agents/skills/hunk-review"
  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" ]]; then
    rm "$target"
  fi

  if [[ -e "$target" && ! -d "$target" ]]; then
    echo "Hunk agent skill path exists but is not a directory, skipping: $target"
    return 0
  fi

  mkdir -p "$target"
  cp -R "$skill_dir/." "$target/"
  echo "Synced Hunk agent skill."
}

export VOLTA_HOME="${VOLTA_HOME:-$HOME/.volta}"
export PATH="$VOLTA_HOME/bin:$PATH"

if command -v volta >/dev/null 2>&1; then
  echo "Installing the latest Node.js and pnpm with Volta..."
  volta install node
  volta install pnpm
else
  echo "Volta is not installed. Please ensure it is listed in your Brewfile."
fi

if command -v cargo >/dev/null 2>&1; then
  echo "Installing cargo packages..."
  cargo install flamegraph
else
  echo "Cargo is not installed. Please ensure Rust is installed via your Brewfile."
fi

if command -v npm >/dev/null 2>&1; then
  echo "Installing global npm packages..."
  npm install -g @anthropic-ai/claude-code
  npm install -g @openai/codex
  npm install -g @mariozechner/pi-coding-agent
  npm install -g hunkdiff
  install_hunk_skill
else
  echo "npm is not installed. Please ensure Node.js is installed."
fi

if command -v uv >/dev/null 2>&1; then
  echo "Installing global Python packages with uv..."
  uv tool install ruff
  uv tool install ty
else
  echo "uv is not installed. Please ensure brew tools are installed, then install uv with 'brew install uv'."
fi
