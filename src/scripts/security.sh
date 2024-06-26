#!/bin/bash

### Authentication & Secrets Management ###

# 1Password and 1Password CLI
caskApps=("1password" "1password-cli")
for app in ${caskApps[@]}; do
    if [[ ! -d "usr/local/Caskroom/$app/" ]]; then
        brew install --cask "$app"
    fi
done

### Defensive Security ###

# Clam AV
brew install clamav

# Firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

### Privacy ###

# Proton VPN Client
if [[ ! -d "usr/local/Caskroom/protonvpn/" ]]; then
    brew install --cask protonvpn
fi

## TODO: Install Proton VPN CLI

# Signal Messenger
if [[ ! -d "usr/local/Caskroom/signal/" ]]; then
    brew install --cask signal
fi
