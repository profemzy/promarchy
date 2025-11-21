#!/bin/bash

set -e  # Exit on error

echo "==================================="
echo "Omarchy Supplement Installation"
echo "==================================="
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Function to run script only if needed
run_if_needed() {
    local script=$1
    local check_cmd=$2
    local step_num=$3
    local step_name=$4

    echo "[$step_num] $step_name..."

    if [ -n "$check_cmd" ] && eval "$check_cmd"; then
        echo "  ✓ Already installed, skipping..."
    else
        ./"$script"
    fi
    echo ""
}

# Install all packages in order
run_if_needed "install-zsh.sh" "command_exists zsh" "1/12" "Installing Zsh"

run_if_needed "install-asdf.sh" "command_exists mise" "2/12" "Installing mise (version manager)"

run_if_needed "install-nodejs.sh" "command_exists node" "3/12" "Installing Node.js"

run_if_needed "install-ruby.sh" "command_exists ruby" "4/12" "Installing Ruby"

run_if_needed "install-postgresql.sh" "command_exists psql" "5/12" "Installing PostgreSQL"

run_if_needed "install-ghostty.sh" "command_exists ghostty" "6/12" "Installing Ghostty terminal"

run_if_needed "install-tmux.sh" "command_exists tmux" "7/12" "Installing tmux"

run_if_needed "install-stow.sh" "command_exists stow" "8/12" "Installing stow"

run_if_needed "install-dotfiles.sh" "[ -d ~/dotfiles ]" "9/12" "Installing dotfiles"

run_if_needed "install-hyprland-overrides.sh" "" "10/12" "Installing Hyprland overrides"

run_if_needed "install-devops-tools.sh" "" "11/12" "Installing DevOps tools"

run_if_needed "set-shell.sh" "[ \"\$SHELL\" = \"\$(which zsh)\" ]" "12/12" "Setting default shell"

echo "==================================="
echo "Installation complete!"
echo "==================================="
echo ""
echo "Installed components:"
echo "  ✓ Zsh shell"
echo "  ✓ mise version manager"
echo "  ✓ Node.js & Ruby"
echo "  ✓ PostgreSQL database"
echo "  ✓ Ghostty terminal"
echo "  ✓ tmux with TPM"
echo "  ✓ Dotfiles configuration"
echo "  ✓ Hyprland customizations"
echo "  ✓ DevOps tools (kubectl, helm, terraform, etc.)"
echo ""
echo "Please log out and log back in for all changes to take effect."
