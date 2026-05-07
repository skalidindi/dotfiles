#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./bootstrap.sh

Options:
  -h, --help Show this help.
EOF
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'bootstrap: unknown option: %s\n' "$1" >&2
      usage >&2
      exit 64
      ;;
  esac
done

# Check if brew is installed, install if missing
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for this shell session (Apple Silicon / Intel compatible)
  if [[ -d /opt/homebrew/bin ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -d /usr/local/bin ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "Homebrew already installed."
fi

# Run GNU Stow for all config directories in the current folder
echo "Running stow for dotfiles..."
STOW_DIRS=( agents claude cmux bash bin env fastfetch gh ghostty git jj lazygit nushell nvim pi starship tmux yazi zellij zsh )
for dir in "${STOW_DIRS[@]}"
do
  if [[ -d "$dir" ]]; then
    echo "Stowing $dir"
    if [[ "$dir" == "agents" || "$dir" == "git" || "$dir" == "nushell" ]]; then
      stow -t ~/ -R --no-folding "$dir"
    else
      stow -t ~/ -R "$dir"
    fi
  fi
done

if [[ -x "$HOME/.local/bin/install-agent-assets" ]]; then
  echo "Installing agent runtime assets..."
  "$HOME/.local/bin/install-agent-assets"
fi

if [[ -x "$HOME/.local/bin/configure-oss-git" ]]; then
  echo "Configuring OSS Git profile..."
  "$HOME/.local/bin/configure-oss-git"
fi

install_hunk_skill() {
  local skill_path
  local skill_dir
  local target

  if ! command -v hunk &>/dev/null; then
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

# Check if Brewfile exists and run brew bundle
if [[ -f Brewfile ]]; then
  echo "Running brew bundle..."
  brew bundle --file=Brewfile
else
  echo "No Brewfile found, skipping brew bundle."
fi

# Install the latest Node.js version using Volta
export VOLTA_HOME="${VOLTA_HOME:-$HOME/.volta}"
export PATH="$VOLTA_HOME/bin:$PATH"
if command -v volta &>/dev/null; then
  echo "Installing the latest Node.js and pnpm with Volta..."
  volta install node
  volta install pnpm
else
  echo "Volta is not installed. Please ensure it is listed in your Brewfile."
fi

# Install flamegraph using cargo
if command -v cargo &>/dev/null; then
  echo "Installing cargo packages..."
  cargo install flamegraph
else
  echo "Cargo is not installed. Please ensure Rust is installed via your Brewfile."
fi

# Install global npm packages
if command -v npm &>/dev/null; then
  echo "Installing global npm. packages.."
  npm install -g @anthropic-ai/claude-code
  npm install -g @openai/codex
  npm install -g @mariozechner/pi-coding-agent
  npm install -g hunkdiff
  install_hunk_skill
else
  echo "npm is not installed. Please ensure Node.js is installed."
fi

# Install global Python packages using uv
if command -v uv &>/dev/null; then
  echo "Installing global Python packages with uv..."
  uv tool install ruff
  uv tool install ty
else
  echo "uv is not installed. Please ensure brew are installed, then install uv with 'brew install uv'."
fi

# Decrypt .env-secrets.gpg file
if [[ -f env/.env-secrets.gpg ]]; then
  echo "Decrypting env/.env-secrets.gpg..."
  gpg --decrypt env/.env-secrets.gpg > env/.env-secrets
else
  echo "Encrypted file env/.env-secrets.gpg not found."
fi

# Bat theme setup
if [ ! -d "$(bat --config-dir)" ]; then
  mkdir -p "$(bat --config-dir)/themes"
  wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
  wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
  wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
  wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
  bat cache --build
else
  echo "The bat configuration directory does not exist."
fi

echo "Bootstrap completed!"
