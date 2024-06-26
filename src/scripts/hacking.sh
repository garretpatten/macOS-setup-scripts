#!/bin/bash

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
