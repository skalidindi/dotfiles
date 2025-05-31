#!/usr/bin/env bash
set -euo pipefail

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
STOW_DIRS=( bash bat bin btop fastfetch gh ghostty git kitty lazygit misc nvim tmux yazi zellij zsh )
for dir in "${STOW_DIRS[@]}"
do
  if [[ -d "$dir" ]]; then
    echo "Stowing $dir"
    stow -t ~/ -R "$dir"
  fi
done

# Check if Brewfile exists and run brew bundle
if [[ -f Brewfile ]]; then
  echo "Running brew bundle..."
  brew bundle --file=Brewfile
else
  echo "No Brewfile found, skipping brew bundle."
fi

# Install the latest Node.js version using fnm
if command -v fnm &>/dev/null; then
  echo "Installing the latest Node.js with fnm..."
  fnm install --lts
  fnm use --lts
else
  echo "fnm is not installed. Please ensure it is listed in your Brewfile."
fi

# Enable corepack and install pnpm
if command -v corepack &>/dev/null; then
  echo "Enabling corepack and installing pnpm..."
  corepack enable
  corepack prepare pnpm@latest --activate
else
  echo "corepack is not installed. Please ensure Node.js is installed and corepack is available."
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

echo "Bootstrap completed!"
