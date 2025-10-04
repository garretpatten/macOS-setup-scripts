#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

# Check prerequisites
check_macos
check_homebrew

print_section "Installing Productivity Applications"

# Define productivity applications to install
productivity_casks=(
    "balenaetcher"
    "chatgpt"
    "notion"
    "proton-drive"
    "proton-mail"
    "zoom"
)

productivity_formulas=(
    "raycast"
)

# Install productivity applications in parallel
install_brew_casks_parallel "${productivity_casks[@]}"
install_brew_formulas_parallel "${productivity_formulas[@]}"

print_completion "Productivity Applications Installation Complete"
