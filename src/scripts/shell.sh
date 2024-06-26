#!/bin/bash

# Install Zsh
if [[!  -d "usr/local/cellar/zsh/" ]]; then
    brew install zsh
fi

# Change User Shells to Zsh
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

### Install fonts ###

# TODO: Install Awesome Terminal Fonts
brew install --cask font-awesome-terminal-fonts

# TODO: Install Fira Code Fonts
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

# TODO: Install Meslo Nerd Fonts
brew install --cask font-meslo-lg-nerd-font

# TODO: Install Powerline Fonts
brew tap homebrew/cask-fonts
brew cask install font-powerline-symbols

### TODO: Install oh-my-posh ###
brew install jandedobbeleer/oh-my-posh/oh-my-posh

### Zsh Plugins ###
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

### Terminal Configuration ###

# Configure Alacritty
if [[ ! -d "$HOME/.config/alacritty/" ]]; then
    mkdir -p "$HOME/.config/alacritty"
    git clone https://github.com/alacritty/alacritty-theme "$HOME/.config/alacritty/"
    touch "$HOME/.config/alacritty/alacritty.toml"
    cp "$(pwd)/src/dotfiles/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
fi

# Update ~/.zshrc
cp "$(pwd)/src/dotfiles/oh-my-posh/.zshrc" "$HOME/.zshrc"
