#!/bin/bash

# Install mise (modern replacement for asdf)
# mise is faster and more user-friendly than asdf

if command -v mise &>/dev/null; then
    echo "mise is already installed."
    exit 0
fi

echo "Installing mise..."
curl https://mise.run | sh

# Add mise to shell configs if not already present
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"

if [ -f "$BASHRC" ] && ! grep -q 'mise activate' "$BASHRC"; then
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> "$BASHRC"
    echo "Added mise activation to .bashrc"
fi

if [ -f "$ZSHRC" ] && ! grep -q 'mise activate' "$ZSHRC"; then
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> "$ZSHRC"
    echo "Added mise activation to .zshrc"
fi

echo "mise installation complete!"
echo "Note: Restart your shell or run 'source ~/.zshrc' to use mise"
