#!/bin/bash

# Git config
if [[ ! -f "$HOME/.gitconfig" ]]; then
	git config --global credential.helper store
	git config --global user.email "garret.patten@proton.me"
	git config --global user.name "Garret Patten"
	git config pull.rebase false
fi

# Vim config
cat "$(pwd)/src/artifacts/vim/vimrc.txt" >> ~/.vimrc

# Install GitHub CLI and Sourcegraph CLI
apps=("gh" "src-cli")
for app in ${apps[@]}; do
	if [[ -d "/usr/local/cellar/$app/" ]]; then
		echo "$app is already installed."
	else
		brew install "$app"
	fi
done

# Install Sourcegraph App
if [[ -d "/usr/local/cellar/sourcegraph/" ]]; then
	echo "Sourcegraph app is already installed."
else
	brew install sourcegraph/app/sourcegraph
fi

# Install Postman and VS Code
caskApps=("postman" "visual-studio-code")
for app in ${caskApps[@]}; do
	if [[ -d "/usr/local/Caskroom/$app/" ]]; then
		echo "$app is already installed."
	else
		brew install --cask "$app"
	fi
done
