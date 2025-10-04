#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

# Check prerequisites
check_macos
check_homebrew

print_section "Installing CLI Tools"

# Define CLI tools to install
cli_tools=(
    "bat"
    "curl"
    "eza"
    "fastfetch"
    "fd"
    "git"
    "htop"
    "jq"
    "ripgrep"
    "vim"
    "wget"
)

# Install CLI tools in parallel
install_brew_formulas_parallel "${cli_tools[@]}"

print_completion "CLI Tools Installation Complete"
