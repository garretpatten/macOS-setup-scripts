#!/bin/bash

source "$(dirname "$0")/utils.sh"

brew install --cask 1password 1password-cli 2>>"$ERROR_LOG_FILE" || true
brew install openvpn 2>>"$ERROR_LOG_FILE" || true
brew install --cask protonvpn signal 2>>"$ERROR_LOG_FILE" || true
brew install exiftool nmap 2>>"$ERROR_LOG_FILE" || true
brew install --cask burp-suite zap 2>>"$ERROR_LOG_FILE" || true

# Install Proton Pass CLI
curl -fsSL https://proton.me/download/pass-cli/install.sh | bash 2>>"$ERROR_LOG_FILE" || true
export PATH="/Users/garret/.local/bin:$PATH"
# Add PATH to .zshrc if not already present
if ! grep -q 'export PATH="/Users/garret/.local/bin:$PATH"' "$HOME/.zshrc" 2>/dev/null; then
    echo 'export PATH="/Users/garret/.local/bin:$PATH"' >> "$HOME/.zshrc" 2>>"$ERROR_LOG_FILE" || true
fi

sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on 2>>"$ERROR_LOG_FILE" || true

if [[ ! -d "$HOME/Hacking/PayloadsAllTheThings" ]]; then
    git clone https://github.com/swisskyrepo/PayloadsAllTheThings "$HOME/Hacking/PayloadsAllTheThings" 2>>"$ERROR_LOG_FILE" || true
fi

if [[ ! -d "$HOME/Hacking/SecLists" ]]; then
    git clone https://github.com/danielmiessler/SecLists "$HOME/Hacking/SecLists" 2>>"$ERROR_LOG_FILE" || true
fi
