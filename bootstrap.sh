#!/usr/bin/env bash
set -euo pipefail

# Ensure ~/.config exists
mkdir -p "${HOME}/.config"

# Symlink Neovim config (idempotent: -sf overwrites existing symlink)
ln -sf "${HOME}/dotfiles/nvim" "${HOME}/.config/nvim"

# Example: install basic tools if missing (feel free to extend)
if ! command -v nvim >/dev/null 2>&1; then
  echo "Neovim not found in this environment; install it in the devcontainer image."
fi
