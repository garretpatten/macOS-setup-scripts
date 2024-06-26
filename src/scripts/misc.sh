#!/bin/bash

# Install Balena Etcher, Zoom
caskApps=("balenaetcher" "zoom")
for caskApp in ${caskApps[@]}; do
	if [[ -d "usr/local/Caskroom/$caskApp/" ]]; then
		echo "$caskApp is already installed."
	else
		brew install --cask "$caskApp"
	fi
done
