#!/bin/bash

# Enable Firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Install 1Password, 1Password CLI, Proton VPN Client
caskApps=("1password" "1password-cli" "protonvpn")
for app in ${caskApps[@]}; do
	if [[ -d "usr/local/Caskroom/$app/" ]]; then
		echo "$app is already installed."
	else
		brew install --cask "$app"
	fi
done

## TODO: Install Proton VPN CLI

# Install Clam AV
brew install clamav
