#!/bin/bash

source "$(pwd)/src/scripts/utils.sh"

### Runtimes ###

# Node, npm, and nvm
if ! is_installed "node"; then
    brew install node
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash || {
        echo "Failed to install nvm." >> "$ERROR_FILE";
    }
fi

# Python and pip
if ! is_installed "python3"; then
    brew install python@3.12
fi

### Dev Tools ###

# Colima
if ! is_installed "colima"; then
    brew install colima
    colima start
fi

# Docker
if ! is_installed "docker"; then
    brew install docker
fi

# Docker Compose
if ! is_installed "docker-compose"; then
    brew install docker-compose
fi

# GitHub CLI
if ! is_installed "gh"; then
    brew install gh
fi

# Neovim
if ! is_installed "nvim"; then
    brew install neovim
fi

# Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" || {
    echo "Failed to clone https://github.com/wbthomason/packer.nvim" >> "$ERROR_FILE";
}

# Postman
if [[ ! -d "/usr/local/Caskroom/postman/" ]]; then
    brew install --cask postman
fi

# Semgrep
if ! is_installed "semgrep"; then
    brew install semgrep
fi

# Shellcheck
if ! is_installed "shellcheck"; then
    brew install shellcheck
fi

# Sourcegraph App
if [[ ! -d "/usr/local/cellar/sourcegraph/" ]]; then
    brew install sourcegraph/app/sourcegraph
fi

# Sourcegraph CLI
if [[ ! -d "/usr/local/cellar/src-cli/" ]]; then
    brew install src-cli
fi

# Tree Sitter
if ! is_installed "tree-sitter"; then
    brew install tree-sitter
fi

# VS Code
if [[ ! -d "/usr/local/Caskroom/visual-studio-code/" ]]; then
    brew install --cask visual-studio-code
    cp "$(pwd)/src/dotfiles/vs-code/settings.json" "$HOME/Library/Application Support/Code/User/settings.json" || {
        echo "Failed to configure VS Code settings." >> "$ERROR_FILE";
    }
fi

### Frameworks ###

# Angular CLI
if ! is_installed "ng"; then
    brew install angular-cli
fi

### Configuration ###

# Git
if [[ ! -f "$HOME/.gitconfig" ]]; then
    git config --global credential.helper store
    git config --global http.postBuffer 157286400
    git config --global pack.window 1
    git config --global user.email "garret.patten@proton.me"
    git config --global user.name "Garret Patten"
    git config --global pull.rebase false
fi

# Neovim
mkdir -p "$HOME/.config/nvim/"
cp -r "$(pwd)/src/dotfiles/nvim/" "$HOME/.config/nvim/" || {
    echo "Failed to configure Neovim settings." >> "$ERROR_FILE";
}

# Vim
if [[ ! -f "$HOME/.vimrc" ]]; then
    cp "$(pwd)/src/dotfiles/vim/.vimrc" "$HOME/.vimrc" || {
        echo "Failed to configure Vim settings." >> "$ERROR_FILE";
    }
fi
