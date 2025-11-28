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
        log_error "PostgreSQL installation failed. Check the error above."
    fi
    exit $exit_code
}

trap cleanup EXIT

# Install PostgreSQL
log_info "Installing PostgreSQL..."
if ! yay -S --noconfirm --needed postgresql; then
    log_error "Failed to install PostgreSQL via yay"
    exit 1
fi

# Check if data directory already exists and is initialized
if [ ! -d "/var/lib/postgres/data" ] || [ -z "$(ls -A /var/lib/postgres/data 2>/dev/null)" ]; then
    log_info "Initializing PostgreSQL database..."
    if ! sudo -u postgres initdb -D /var/lib/postgres/data --locale=C.UTF-8 --encoding=UTF8 --data-checksums; then
        log_error "Failed to initialize PostgreSQL database"
        exit 1
    fi
else
    log_info "PostgreSQL data directory already initialized, skipping..."
fi

# Start and enable PostgreSQL service
log_info "Starting PostgreSQL service..."
if ! sudo systemctl start postgresql; then
    log_error "Failed to start PostgreSQL service"
    exit 1
fi

if ! sudo systemctl enable postgresql; then
    log_error "Failed to enable PostgreSQL service"
    exit 1
fi

# Wait for PostgreSQL to be ready
sleep 2

# Create a database user matching the current user if it doesn't exist
log_info "Setting up PostgreSQL user..."
if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_user WHERE usename='$USER'" | grep -q 1; then
    if ! sudo -u postgres createuser --superuser "$USER"; then
        log_error "Failed to create PostgreSQL user: $USER"
        exit 1
    fi
    log_success "Created PostgreSQL user: $USER"
else
    log_info "PostgreSQL user $USER already exists"
fi

# Create a default database for the user if it doesn't exist
if ! sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw "$USER"; then
    if ! createdb "$USER"; then
        log_error "Failed to create database: $USER"
        exit 1
    fi
    log_success "Created default database: $USER"
else
    log_info "Database $USER already exists"
fi

log_success "PostgreSQL installation and setup complete!"
log_info "You can now connect to PostgreSQL using: psql"