#!/bin/bash

# Install iTerm2
if [[ -d "usr/local/Caskroom/iterm2/" ]]; then
	echo "iTerm2 is already installed."
else
	brew install --cask iterm2
fi

# Install Zsh
if [[ -d "usr/local/cellar/zsh/" ]]; then
	echo "Zsh is already installed."
else
	brew install zsh
fi

# Change User Shells to Zsh
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install plugins
currentPath=$(pwd)

cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

# Configure zshrc
cd && cat "$(pwd)/src/artifacts/zsh/zshrc.txt" > ~/.zshrc

cd $currentPath
