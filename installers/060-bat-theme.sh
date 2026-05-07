#!/usr/bin/env bash
set -euo pipefail

if ! command -v bat >/dev/null 2>&1; then
  echo "bat is not installed. Please ensure it is listed in your Brewfile."
  exit 0
fi

bat_config_dir="$(bat --config-dir)"
theme_dir="$bat_config_dir/themes"

if [[ ! -d "$theme_dir" ]]; then
  mkdir -p "$theme_dir"
  wget -P "$theme_dir" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
  wget -P "$theme_dir" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
  wget -P "$theme_dir" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
  wget -P "$theme_dir" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
  bat cache --build
else
  echo "bat themes already installed."
fi
