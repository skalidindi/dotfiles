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
stow_dirs=(agents cmux bash bin env fastfetch gh ghostty git herdr jj lazygit nushell nvim starship tmux worktrunk yazi zellij zsh)

for dir in "${stow_dirs[@]}"; do
  if [[ -d "$dir" ]]; then
    echo "Stowing $dir"
    case "$dir" in
      agents|git|herdr|nushell|worktrunk)
        stow -t "$HOME" -R --no-folding "$dir"
        ;;
      *)
        stow -t "$HOME" -R "$dir"
        ;;
    esac
  fi
done

install_linux_nushell_config() {
  local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nushell"
  local config_target="$config_dir/config.nu"
  local config_source="$repo_root/nushell/Library/Application Support/nushell/config.nu"
  local backup_path="$config_target.work-generated.bak"

  [[ "$(uname -s)" == "Linux" ]] || return 0

  mkdir -p "$config_dir"
  if [[ -L "$config_target" ]]; then
    [[ "$(readlink "$config_target")" == "$config_source" ]] && return 0
    printf 'existing Nushell config symlink is not managed by dotfiles: %s\n' "$config_target" >&2
    return 1
  fi

  if [[ -e "$config_target" ]]; then
    if ! grep -Fqx '# >>> work-dotfiles generated vendor scripts >>>' "$config_target"; then
      printf 'existing Nushell config is not a generated Work config: %s\n' "$config_target" >&2
      return 1
    fi
    if [[ -e "$backup_path" ]]; then
      printf 'generated Work config backup already exists: %s\n' "$backup_path" >&2
      return 1
    fi
    mv "$config_target" "$backup_path"
  fi

  ln -s "$config_source" "$config_target"
}

install_linux_nushell_config
