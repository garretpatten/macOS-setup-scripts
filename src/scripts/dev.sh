#!/bin/bash

# Git config
git config --global credential.helper cache
git config --global user.email "garret.patten@proton.me"
git config --global user.name "Garret Patten"
git config pull.rebase false

# Vim config
cat "$(pwd)/src/artifacts/vim/vimrc.txt" >> ~/.vimrc

# Install GitHub CLI
brew install install gh

# Install Sourcegraph App & CLI
if [[ -d "/usr/local/cellar/sourcegraph/" ]]; then
	echo "Sourcegraph app is already installed."
else
	brew install sourcegraph/app/sourcegraph
fi

if [[ -d "/usr/local/cellar/src-cli/" ]]; then
	echo "Sourcegraph CLI is already installed."
else
	brew install sourcegraph/src-cli/src-cli
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
