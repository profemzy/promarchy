#!/bin/bash

# Check if mise is installed
if ! command -v mise &>/dev/null; then
    echo "mise is not installed. Please run ./install-asdf.sh first."
    exit 1
fi

# Install nodejs build dependencies
yay -S --noconfirm --needed base-devel openssl zlib

# Install nodejs version from .tool-versions if it exists
if [ -f ~/.tool-versions ] && grep -q "nodejs" ~/.tool-versions; then
    echo "Installing Node.js from .tool-versions..."
    mise install nodejs
else
    echo "Installing latest LTS Node.js (v22)..."
    mise install nodejs@22
    mise use -g nodejs@22
fi

echo "Node.js installation complete!"
