#!/bin/bash

# Install bat, exa, exiftool, git, neofetch, and wget
cliTools=("bat" "exa" "exiftool" "git" "neofetch" "wget")
for tool in ${cliTools[@]}; do
	if [[ -d "/usr/local/cellar/$tool/" ]]; then
			echo "$tool is already installed."
	else
		brew install "$tool"
	fi
done
