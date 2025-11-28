#!/bin/bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Flags
DRY_RUN=false
VERBOSE=false

# Track what would be/was installed
declare -a WILL_INSTALL=()
declare -a WILL_SKIP=()
declare -a INSTALLED=()
declare -a FAILED=()

# Cleanup function for trap
cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo ""
        echo -e "${RED}==================================${NC}"
        echo -e "${RED}Installation failed!${NC}"
        echo -e "${RED}==================================${NC}"
        if [ ${#INSTALLED[@]} -gt 0 ]; then
            echo -e "${GREEN}Successfully installed before failure:${NC}"
            printf '  - %s\n' "${INSTALLED[@]}"
        fi
        if [ ${#FAILED[@]} -gt 0 ]; then
            echo -e "${RED}Failed components:${NC}"
            printf '  - %s\n' "${FAILED[@]}"
        fi
        echo ""
        echo "Check the error message above for details."
        echo "You can re-run this script after fixing the issue."
    fi
    exit $exit_code
}

trap cleanup EXIT

# Usage information
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Omarchy Supplement Installation Script

OPTIONS:
    -n, --dry-run    Show what would be installed without making changes
    -v, --verbose    Show detailed output during installation
    -h, --help       Show this help message

EXAMPLES:
    $(basename "$0")              # Run full installation
    $(basename "$0") --dry-run    # Preview what would be installed
    $(basename "$0") -n -v        # Verbose dry-run

EOF
    exit 0
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                usage
                ;;
            *)
                echo -e "${RED}Error: Unknown option: $1${NC}"
                usage
                ;;
        esac
    done
}

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[$1]${NC} $2"
}

log_dry_run() {
    echo -e "${YELLOW}[DRY-RUN]${NC} $1"
}

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

    log_step "$step_num" "$step_name..."

    local needs_install=true
    if [ -n "$check_cmd" ] && eval "$check_cmd" 2>/dev/null; then
        needs_install=false
    fi

    if [ "$needs_install" = false ]; then
        log_success "Already installed, skipping"
        WILL_SKIP+=("$step_name")
    else
        if [ "$DRY_RUN" = true ]; then
            log_dry_run "Would run: ./$script"
            WILL_INSTALL+=("$step_name")
        else
            if [ "$VERBOSE" = true ]; then
                log_info "Running: ./$script"
            fi
            
            if ! "${SCRIPT_DIR}/${script}"; then
                log_error "Failed to install: $step_name"
                FAILED+=("$step_name")
                return 1
            fi
            
            INSTALLED+=("$step_name")
            log_success "$step_name installed successfully"
        fi
    fi
    echo ""
}

# Main installation
main() {
    parse_args "$@"

    echo "==================================="
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}Omarchy Supplement - DRY RUN${NC}"
        echo "No changes will be made"
    else
        echo "Omarchy Supplement Installation"
    fi
    echo "==================================="
    echo ""

    # Verify we're in the correct directory
    if [ ! -f "${SCRIPT_DIR}/install-zsh.sh" ]; then
        log_error "Cannot find installation scripts. Please run from the omarchy-supplement directory."
        exit 1
    fi

    # Check prerequisites
    if ! command_exists yay; then
        log_error "yay (AUR helper) is not installed. Please install Omarchy first."
        exit 1
    fi

    if ! command_exists git; then
        log_error "git is not installed. Please install git first."
        exit 1
    fi

    # Install all packages in order
    run_if_needed "install-zsh.sh" "command_exists zsh" "1/12" "Zsh"

    run_if_needed "install-mise.sh" "command_exists mise" "2/12" "mise (version manager)"

    run_if_needed "install-nodejs.sh" "command_exists node" "3/12" "Node.js"

    run_if_needed "install-ruby.sh" "command_exists ruby" "4/12" "Ruby"

    run_if_needed "install-postgresql.sh" "command_exists psql" "5/12" "PostgreSQL"

    run_if_needed "install-ghostty.sh" "command_exists ghostty" "6/12" "Ghostty terminal"

    run_if_needed "install-tmux.sh" "command_exists tmux" "7/12" "tmux"

    run_if_needed "install-stow.sh" "command_exists stow" "8/12" "stow"

    run_if_needed "install-dotfiles.sh" "[ -d ~/dotfiles ]" "9/12" "Dotfiles"

    run_if_needed "install-hyprland-overrides.sh" "" "10/12" "Hyprland info"

    run_if_needed "install-devops-tools.sh" "" "11/12" "DevOps tools"

    run_if_needed "set-shell.sh" "[ \"\$SHELL\" = \"\$(which zsh 2>/dev/null)\" ]" "12/12" "Set default shell"

    # Summary
    echo "==================================="
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}DRY RUN SUMMARY${NC}"
        echo "==================================="
        echo ""
        if [ ${#WILL_INSTALL[@]} -gt 0 ]; then
            echo -e "${BLUE}Would install:${NC}"
            printf '  - %s\n' "${WILL_INSTALL[@]}"
            echo ""
        fi
        if [ ${#WILL_SKIP[@]} -gt 0 ]; then
            echo -e "${GREEN}Already installed (would skip):${NC}"
            printf '  - %s\n' "${WILL_SKIP[@]}"
            echo ""
        fi
        echo "Run without --dry-run to perform the installation."
    else
        echo -e "${GREEN}Installation complete!${NC}"
        echo "==================================="
        echo ""
        if [ ${#INSTALLED[@]} -gt 0 ]; then
            echo -e "${GREEN}Newly installed:${NC}"
            printf '  - %s\n' "${INSTALLED[@]}"
            echo ""
        fi
        if [ ${#WILL_SKIP[@]} -gt 0 ]; then
            echo -e "${BLUE}Already installed:${NC}"
            printf '  - %s\n' "${WILL_SKIP[@]}"
            echo ""
        fi
        echo "Please log out and log back in for all changes to take effect."
    fi
}

main "$@"
