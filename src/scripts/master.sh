#!/bin/bash

# Master script for macOS setup
# This script orchestrates the entire setup process with proper error handling and logging

# Source common functions
source "$(dirname "$0")/common.sh"

# Check prerequisites
check_macos

# Start logging
log_info "Starting macOS setup process..."

# Print welcome message
print_section "macOS Setup Scripts"
log_info "Welcome to the macOS setup process!"
log_info "This script will install and configure your development environment."
echo

# Pre-installation setup (must run first)
log_info "Running pre-installation setup..."
if ! bash "$(dirname "$0")/pre-install.sh"; then
    log_error "Pre-installation failed. Exiting."
    exit 1
fi

# Home directory organization (can run in parallel with other tasks)
log_info "Organizing home directory..."
if ! bash "$(dirname "$0")/organizeHome.sh"; then
    log_error "Home directory organization failed."
fi

# Install packages in parallel where possible
log_info "Installing packages in parallel..."

# Start parallel installation processes
pids=()

# CLI tools (lightweight, can run in parallel)
bash "$(dirname "$0")/cli.sh" &
pids+=($!)

# Media applications (can run in parallel)
bash "$(dirname "$0")/media.sh" &
pids+=($!)

# Productivity applications (can run in parallel)
bash "$(dirname "$0")/productivity.sh" &
pids+=($!)

# Wait for parallel installations to complete
log_info "Waiting for parallel installations to complete..."
for pid in "${pids[@]}"; do
    wait "$pid"
    if [[ $? -ne 0 ]]; then
        log_warn "One or more parallel installations failed, but continuing..."
    fi
done

# Sequential installations (dependencies or system changes)
log_info "Running sequential installations..."

# Development tools (has dependencies and system changes)
log_info "Installing development tools..."
if ! bash "$(dirname "$0")/dev.sh"; then
    log_error "Development tools installation failed."
fi

# Security tools (has system changes)
log_info "Installing security tools..."
if ! bash "$(dirname "$0")/security.sh"; then
    log_error "Security tools installation failed."
fi

# Shell setup (changes default shell, must run last)
log_info "Setting up shell environment..."
if ! zsh "$(dirname "$0")/shell.sh"; then
    log_error "Shell setup failed."
fi

# Post-installation cleanup
log_info "Running post-installation cleanup..."
if ! bash "$(dirname "$0")/post-install.sh"; then
    log_error "Post-installation cleanup failed."
fi

# Final status
print_completion "macOS Setup Complete!"
log_info "Setup process completed. Check logs for any errors:"
log_info "  - Errors: $ERROR_LOG"
log_info "  - Installation log: $INSTALL_LOG"
log_info "  - Debug log: $DEBUG_LOG"

# Display any errors that occurred
if file_exists "$ERROR_LOG" && [[ -s "$ERROR_LOG" ]]; then
    log_warn "Some errors occurred during installation. Check $ERROR_LOG for details."
fi
