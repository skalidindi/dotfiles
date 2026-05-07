#!/usr/bin/env bash
set -euo pipefail

if [[ -x "$HOME/.local/bin/install-agent-assets" ]]; then
  echo "Installing agent runtime assets..."
  "$HOME/.local/bin/install-agent-assets"
fi

if [[ -x "$HOME/.local/bin/configure-oss-git" ]]; then
  echo "Configuring OSS Git profile..."
  "$HOME/.local/bin/configure-oss-git"
fi
