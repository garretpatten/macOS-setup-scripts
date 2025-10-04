#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

# Check prerequisites
check_macos
check_homebrew

print_section "Post-Installation Cleanup"

# Final system updates
log_info "Performing final system updates..."
init_homebrew

# Display completion message
print_section "Installation Complete"

# Display wolf ASCII art
if file_exists "$PROJECT_ROOT/src/assets/wolf.txt"; then
    cat "$PROJECT_ROOT/src/assets/wolf.txt"
    echo
fi

# Display manual installation steps
log_info "Manual Installation Steps Required:"
echo
echo "Download the following apps from the App Store:"
echo "    - Kindle"
echo "    - Perplexity"
echo
echo "Download the following apps from the web:"
echo "    - Docker Desktop"
echo

print_completion "System setup is now complete!"
log_info "Log out and log back in to complete shell change."
