#!/bin/bash

# Install Brave and Firefox
caskApps=("brave-browser" "firefox")
for caskApp in ${caskApps[@]}; do
	if [[ -d "usr/local/Caskroom/$caskApp/" ]]; then
		echo "$caskApp is already installed."
	else
		brew install --cask "$caskApp"
	fi
done
