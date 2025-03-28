#!/bin/bash

source "$(pwd)/src/scripts/utils.sh"

### Authentication & Secrets Management ###

# 1Password and 1Password CLI
caskApps=("1password" "1password-cli")
for app in "${caskApps[@]}"; do
    if [[ ! -d "usr/local/Caskroom/$app/" ]]; then
        brew install --cask "$app"
    fi
done

### Defensive Security ###

# Clam AV
brew install clamav

# Firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Open VPN
if ! is_installed "openvpn"; then
    brew install openvpn
fi

# Proton VPN Client
if [[ ! -d "usr/local/Caskroom/protonvpn/" ]]; then
    brew install --cask protonvpn
fi

# TODO: Install Proton VPN CLI

# Signal Messenger
if [[ ! -d "usr/local/Caskroom/signal/" ]]; then
    brew install --cask signal
fi

### Offensive Security ###

# Burp Suite
if [[ ! -d "usr/local/Caskroom/burp-suite/" ]]; then
    brew install --cask burp-suite
fi

# EXIF Tool
if ! is_installed "exiftool"; then
    brew install exiftool
fi

# Network Mapper
if ! is_installed "nmap"; then
    brew install nmap
fi

# Payloads All the Things
if [[ ! -d "$HOME/Hacking/PayloadsAllTheThings" ]]; then
    git clone https://github.com/swisskyrepo/PayloadsAllTheThings "$HOME/Hacking/" || {
        echo "Failed to clone https://github.com/swisskyrepo/PayloadsAllTheThings" >> "$ERROR_FILE";
    }
fi

# SecLists
if [[ ! -d "$HOME/Hacking/PayloadsAllTheThings" ]]; then
    git clone https://github.com/danielmiessler/SecLists "$HOME/Hacking/" || {
        echo "https://github.com/danielmiessler/SecLists" >> "$ERROR_FILE";
    }
fi

# ZAP
if [[ ! -d "usr/local/Caskroom/zap/" ]]; then
    brew install --cask zap
fi
