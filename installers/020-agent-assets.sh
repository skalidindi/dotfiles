#!/usr/bin/env bash
set -euo pipefail

ensure_nushell_work_overlay() {
  local overlay_dir="$HOME/.config/dotfiles/shell"
  local overlay_file="$overlay_dir/work.nu"

  mkdir -p "$overlay_dir"
  if [[ ! -e "$overlay_file" && ! -L "$overlay_file" ]]; then
    printf '%s\n' '# Optional work Nushell overlay.' > "$overlay_file"
  fi
}

ensure_nushell_work_overlay

if [[ -x "$HOME/.local/bin/install-agent-assets" ]]; then
  echo "Installing agent runtime assets..."
  "$HOME/.local/bin/install-agent-assets"
fi

if [[ -x "$HOME/.local/bin/configure-oss-git" ]]; then
  echo "Configuring OSS Git profile..."
  "$HOME/.local/bin/configure-oss-git"
fi
