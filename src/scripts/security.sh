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

# Firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

### Payloads ###

# Payloads All the Things
git clone https://github.com/swisskyrepo/PayloadsAllTheThings "$HOME/Hacking/"

# SecLists
git clone https://github.com/danielmiessler/SecLists "$HOME/Hacking/"

### Tools ###

# Burp Suite
if [[ ! -d "usr/local/Caskroom/burp-suite/" ]]; then
    brew install --cask burp-suite
fi

# Network Mapper
if [[ ! -d "usr/local/cellar/nmap/" ]]; then
    brew install nmap
fi

# ZAP
if [[ ! -d "usr/local/Caskroom/zap/" ]]; then
    brew install --cask zap
fi
