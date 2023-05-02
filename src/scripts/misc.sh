#!/bin/bash

# Install Thunderbird and VLC
apps=("thunderbird" "vlc")
for app in ${apps[@]}; do
	if [[ -d "usr/local/Caskroom/$app/" ]]; then
		echo "$app is already installed."
	else
		brew install --cask "$app"
	fi
done

# Install Balena Etcher, Burp Suite, Spotify, Signal, and Zoom
caskApps=("balenaetcher" "burp-suite" "spotify" "signal" "zoom")
for caskApp in ${caskApps[@]}; do
	if [[ -d "usr/local/Caskroom/$caskApp/" ]]; then
		echo "$caskApp is already installed."
	else
		brew install --cask "$caskApp"
	fi
done
