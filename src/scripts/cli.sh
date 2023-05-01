#!/bin/bash

cliTools=("bat" "exa" "exiftool" "gh" "git" "neofetch" "wget")

for tool in ${cliTools[@]}; do
	if [[ -d "/usr/local/cellar/$tool/" ]]
		then
			echo "$tool is already installed."
	else
		brew install "$tool"
	fi
done
