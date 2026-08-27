#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$repo_root"

if ! command -v stow >/dev/null 2>&1; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

echo "Running stow for dotfiles..."
# Claude and Codex homes are mutable runtime directories. Their portable assets are
# applied by install-agent-assets; do not stow either whole home directory.
stow_dirs=(agents cmux bash bin env fastfetch gh ghostty git herdr lazygit nvim starship tmux worktrunk yazi zellij zsh)

migrate_work_agent_prompt_fallback() {
  local target="$HOME/.agents/prompts/pull-request.md"
  local source="$repo_root/agents/.agents/prompts/pull-request.md"
  local linked_path

  [[ -L "$target" ]] || return 0
  linked_path="$(readlink "$target")"

  case "$linked_path" in
    */stow/agents/.agents/prompts/pull-request.md)
      ;;
    *)
      return 0
      ;;
  esac

  if [[ -e "$target" ]] && ! cmp -s "$target" "$source"; then
    printf 'Work agent prompt fallback differs from the OSS source: %s\n' "$target" >&2
    return 1
  fi

  rm -f "$target"
  printf 'Migrated Work agent prompt fallback to OSS Stow ownership: %s\n' "$target"
}

migrate_work_agent_prompt_fallback

for dir in "${stow_dirs[@]}"; do
  if [[ -d "$dir" ]]; then
    echo "Stowing $dir"
    case "$dir" in
      agents|git|herdr|worktrunk)
        stow -t "$HOME" -R --no-folding "$dir"
        ;;
      *)
        stow -t "$HOME" -R "$dir"
        ;;
    esac
  fi
done
