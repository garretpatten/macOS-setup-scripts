#!/bin/bash

# TODO: Install Office suite

# TODO: Install Spectacle
apps=("spectacle" "task")
for app in ${apps[@]}; do
	if [[ -d "usr/local/cellar/$app/" ]]; then
		echo "$app is already installed."
	else
		brew install "$app"
	fi
done

# Taskwarrior config
cat "$(pwd)/src/artifacts/taskwarrior/taskrcUpdates.txt" >> ~/.taskrc

# Add directory for custom themes
if [[ -d "~/.task/themes/" ]]; then
	echo "Taskwarrior themes directory already exists."
else
	mkdir ~/.task/themes/
fi

# TODO: Add custom themes to directory
# cp ./src/artifacts/taskwarrior/themes/ ~/.task/themes/

# Install Simplenote and Todoist
caskApps=("simplenote" "todoist")
for caskApp in ${caskApps[@]}; do
	if [[ -d "usr/local/Caskroom/$caskApp" ]]; then
		echo "$caskApp is already installed."
	else
		brew install --cask "$caskApp"
	fi
done
