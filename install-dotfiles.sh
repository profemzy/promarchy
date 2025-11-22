#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_URL="git@github.com:profemzy/dotfiles.git"
REPO_NAME="dotfiles"

is_stow_installed() {
  pacman -Qi "stow" &> /dev/null
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  echo "Preparing configs..."

  # Only remove configs if they're not already symlinks to dotfiles
  if [ -e ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
    echo "Removing old nvim config (not a symlink)"
    rm -rf ~/.config/nvim
  fi

  if [ -e ~/.config/starship.toml ] && [ ! -L ~/.config/starship.toml ]; then
    echo "Removing old starship config (not a symlink)"
    rm -rf ~/.config/starship.toml
  fi

  if [ -e ~/.config/ghostty/config ] && [ ! -L ~/.config/ghostty/config ]; then
    echo "Removing old ghostty config (not a symlink)"
    rm -rf ~/.config/ghostty/config
  fi

  # Always remove cache/data directories (should be regenerated)
  echo "Cleaning caches..."
  rm -rf ~/.local/share/nvim/ ~/.cache/nvim/

  cd "$REPO_NAME"
  echo "Applying dotfiles with stow..."
  stow zshrc
  stow ghostty
  stow tmux
  stow nvim
  stow starship
  echo "Dotfiles setup complete!"
else
  echo "Failed to clone the repository."
  exit 1
fi
