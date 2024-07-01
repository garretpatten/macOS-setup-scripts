#!/bin/bash

# Install Zsh
if [[!  -d "usr/local/cellar/zsh/" ]]; then
    brew install zsh
fi

# Change User Shells to Zsh
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

### Install fonts ###

# Awesome Terminal Fonts
if [[ ! -f "$HOME/Library/Fonts/SourceCodePro+Powerline+Awesome+Regular.ttf" ]]; then
    brew install --cask font-awesome-terminal-fonts
fi

# Fira Code Fonts
if [[ ! -f "$HOME/Library/Fonts/FiraCode-Regular.ttf" ]]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-fira-code
fi

# Meslo Nerd Fonts
if [[ ! -f "$HOME/Library/Fonts/MesloLFMNerdFont-Regular.ttf" ]]; then
    brew install --cask font-meslo-lg-nerd-font
fi

# Powerline Fonts\
if [[ ! -f "$HOME/Library/Fonts/PowerlineSymbols.otf" ]]; then
    brew cask install font-powerline-symbols
fi

### oh-my-posh ###
if [[ ! -f "/opt/homebrew/bin/oh-my-posh" ]]; then
    brew install jandedobbeleer/oh-my-posh/oh-my-posh
fi

### Zsh Plugins ###

# Autosuggestions
if [[ ! -d "/opt/homebrew/share/zsh-autosuggestions/" ]]; then
    brew install zsh-autosuggestions
fi

# Syntax Highlighting
if [[ ! -d "/opt/homebrew/share/zsh-syntax-highlighting/" ]]; then
    brew install zsh-syntax-highlighting
fi

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
