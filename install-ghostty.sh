#!/bin/bash

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

log_info() { echo -e "[INFO] $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        log_error "Ghostty installation failed. Check the error above."
    fi
    exit $exit_code
}

trap cleanup EXIT

# Install ghostty terminal emulator
if command -v ghostty &>/dev/null; then
    log_success "Ghostty is already installed"
    exit 0
fi

log_info "Installing Ghostty terminal emulator..."
if ! yay -S --noconfirm --needed ghostty; then
    log_error "Failed to install Ghostty via yay"
    exit 1
fi

log_success "Ghostty installed successfully"