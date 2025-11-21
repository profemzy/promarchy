#!/bin/bash

# Check if mise is installed
if ! command -v mise &>/dev/null; then
    echo "mise is not installed. Installing mise..."
    curl https://mise.run | sh
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
fi

# Install Ruby build dependencies
echo "Installing Ruby build dependencies..."
yay -S --noconfirm --needed base-devel gcc make openssl readline zlib libyaml libffi

# Install ruby version from .tool-versions if it exists
if [ -f ~/.tool-versions ] && grep -q "ruby" ~/.tool-versions; then
    echo "Installing Ruby from .tool-versions..."
    mise install ruby
else
    echo "Installing latest Ruby..."
    mise install ruby@latest
    mise use -g ruby@latest
fi

echo "Ruby installation complete!"
