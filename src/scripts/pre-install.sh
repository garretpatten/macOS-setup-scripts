#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

# Check prerequisites
check_macos

print_section "Pre-Installation Setup"

# Install Homebrew if not present
if ! command_exists "brew"; then
    log_info "Installing Homebrew..."
    execute_command "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" "Homebrew installation"
else
    log_info "Homebrew is already installed"
fi

# Initialize Homebrew
init_homebrew

# Xcode Command Line Tools
log_info "Setting up Xcode Command Line Tools..."

xcode_path="/Library/Developer/CommandLineTools/"

if directory_exists "$xcode_path"; then
    log_info "Removing existing Command Line Tools..."
    execute_command "sudo rm -rf '$xcode_path'" "Remove existing Command Line Tools"
fi

log_info "Installing Xcode Command Line Tools..."
execute_command "sudo xcode-select --install" "Install Command Line Tools"
execute_command "sudo xcodebuild -license accept" "Accept Xcode license"

# System updates
log_info "Installing system updates..."
execute_command "softwareupdate --all --install --force" "System updates"

print_completion "Pre-Installation Setup Complete"
