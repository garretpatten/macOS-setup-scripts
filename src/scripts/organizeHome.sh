#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

# Check prerequisites
check_macos

print_section "Organizing Home Directory"

# Remove unneeded directories
log_info "Removing unneeded directories..."
directories_to_remove=("Public" "Templates")

for directory in "${directories_to_remove[@]}"; do
    if directory_exists "$HOME/$directory"; then
        log_info "Removing directory: $directory"
        execute_command "rmdir '$HOME/$directory'" "Remove $directory directory"
    else
        log_debug "Directory $directory does not exist, skipping"
    fi
done

# Create needed directories
log_info "Creating needed directories..."
directories_to_create=("Books" "Games" "Hacking" "Projects")

for directory in "${directories_to_create[@]}"; do
    ensure_directory "$HOME/$directory" "$directory directory"
done

print_completion "Home Directory Organization Complete"
