#!/bin/bash

source "$(pwd)/src/scripts/utils.sh"

### Shells ###

# Z Shell
if ! is_installed "zsh"; then
    brew install zsh
fi

### Fonts ###

# Awesome Terminal Fonts
brew install --cask font-awesome-terminal-fonts

# Fira Code Fonts
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

# Meslo Nerd Fonts
brew install --cask font-meslo-lg-nerd-font

# Powerline Fonts
brew tap homebrew/cask-fonts
brew cask install font-powerline-symbols

### Plugins ###

# Oh-my-posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Tmux
if ! is_installed "tmux"; then
    brew install tmux
fi

# Zsh Auto Suggestions
brew install zsh-autosuggestions

# Zsh Syntax Highlighting
brew install zsh-syntax-highlighting

### Configuration ###

# Alacritty
if [[ ! -d "$HOME/.config/alacritty/" ]]; then
    mkdir -p "$HOME/.config/alacritty"
    git clone https://github.com/alacritty/alacritty-theme "$HOME/.config/alacritty/"
    touch "$HOME/.config/alacritty/alacritty.toml"
    cp "$(pwd)/src/dotfiles/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
fi

# Ghostty
if [[ ! -d "$HOME/.config/ghostty/" ]]; then
    mkdir -p "$HOME/.config/ghostty"
    touch "$HOME/.config/ghostty/config"
    cp "$(pwd)/src/dotfiles/ghostty/config" "$HOME/.config/ghostty/config"
fi

# System
chsh -s "$(which zsh)"
sudo chsh -s "$(which zsh)"

# Tmux
if [[ ! -f "$HOME/.tmux.conf" ]]; then
    touch "$HOME/.tmux.conf"
    cp "$(pwd)/src/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

# Z Shell
if [[ ! -f "$HOME/.zshrc" ]]; then
    touch "$HOME/.zshrc"
    cp "$(pwd)/src/dotfiles/oh-my-posh/.zshrc" "$HOME/.zshrc"
fi
