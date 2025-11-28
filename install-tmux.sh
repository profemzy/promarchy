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
        log_error "tmux installation failed. Check the error above."
    fi
    exit $exit_code
}

trap cleanup EXIT

# Install tmux
log_info "Installing tmux..."
if ! yay -S --noconfirm --needed tmux; then
    log_error "Failed to install tmux via yay"
    exit 1
fi

# Verify tmux is installed
if ! command -v tmux &>/dev/null; then
    log_error "tmux installation verification failed"
    exit 1
fi

TPM_DIR="$HOME/.tmux/plugins/tpm"

# Check if TPM is already installed
if [ -d "$TPM_DIR" ]; then
    log_success "TPM is already installed in $TPM_DIR"
else
    log_info "Installing Tmux Plugin Manager (TPM)..."
    if ! git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
        log_error "Failed to clone TPM repository"
        exit 1
    fi
    log_success "TPM installed successfully"
fi

log_success "tmux installation complete!"