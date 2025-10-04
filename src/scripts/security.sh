#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

# Check prerequisites
check_macos
check_homebrew

print_section "Installing Security Tools"

### Authentication & Secrets Management ###
log_info "Installing authentication and secrets management tools..."

auth_casks=(
    "1password"
    "1password-cli"
)

install_brew_casks_parallel "${auth_casks[@]}"

### Defensive Security ###
log_info "Installing defensive security tools..."

defensive_formulas=(
    "clamav"
    "openvpn"
)

defensive_casks=(
    "protonvpn"
    "signal"
)

install_brew_formulas_parallel "${defensive_formulas[@]}"
install_brew_casks_parallel "${defensive_casks[@]}"

# Configure firewall
log_info "Configuring macOS firewall..."
execute_command "sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on" "Enable macOS firewall"

### Offensive Security ###
log_info "Installing offensive security tools..."

offensive_formulas=(
    "exiftool"
    "nmap"
)

offensive_casks=(
    "burp-suite"
    "zap"
)

install_brew_formulas_parallel "${offensive_formulas[@]}"
install_brew_casks_parallel "${offensive_casks[@]}"

### Security Repositories ###
log_info "Cloning security repositories..."

# Ensure Hacking directory exists
ensure_directory "$HOME/Hacking" "Hacking directory"

# Clone security repositories
clone_repository "https://github.com/swisskyrepo/PayloadsAllTheThings" "$HOME/Hacking/PayloadsAllTheThings" "PayloadsAllTheThings"
clone_repository "https://github.com/danielmiessler/SecLists" "$HOME/Hacking/SecLists" "SecLists"

print_completion "Security Tools Installation Complete"
