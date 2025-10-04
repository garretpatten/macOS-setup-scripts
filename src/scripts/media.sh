#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

# Check prerequisites
check_macos
check_homebrew

print_section "Installing Media Applications"

# Define media applications to install
media_apps=(
    "brave-browser"
    "duckduckgo"
    "spotify"
    "vlc"
)

# Install media applications in parallel
install_brew_casks_parallel "${media_apps[@]}"

print_completion "Media Applications Installation Complete"
