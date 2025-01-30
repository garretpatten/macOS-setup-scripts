#!/bin/bash

### Configuration ###

# Git config
if [[ ! -f "$HOME/.gitconfig" ]]; then
    git config --global credential.helper store
    git config --global http.postBuffer 157286400
    git config --global pack.window 1
    git config --global user.email "garret.patten@proton.me"
    git config --global user.name "Garret Patten"
    git config --global pull.rebase false
fi

### Runtimes ###

# Node and npm
if [[ ! -d "/usr/local/cellar/node/" ]]; then
    brew install node
fi

# Node Version Manager
if [[ ! -d "/usr/local/cellar/nvm/" ]]; then
    brew install nvm
fi

# Python and pip
if [[ ! -d "/opt/homebrew/bin/python3/" ]]; then
    brew install python@3.12
fi

### Frameworks ###

# TODO: Install Angular

# TODO: Install Vue.js

### Dev Tools ###

# Docker
if [[ ! -d "/opt/homebrew/bin/docker/" ]]; then
    brew install docker
fi

# Docker Compose
if [[ ! -d "/opt/homebrew/bin/docker/" ]]; then
    brew install docker
fi

# GitHub CLI
if [[ ! -d "/usr/local/cellar/gh/" ]]; then
    brew install gh
fi

# Postman
if [[ ! -d "/usr/local/Caskroom/postman/" ]]; then
    brew install --cask postman
fi

# Semgrep
if [[ ! -d "/usr/local/cellar/semgrep/" ]]; then
    brew install semgrep
fi

# Shellcheck
if [[ ! -d "/usr/local/cellar/shellcheck/" ]]; then
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

# VS Code
if [[ ! -d "/usr/local/Caskroom/visual-studio-code/" ]]; then
    brew install --cask "$app"
    cp "$(pwd)/src/dotfiles/vs-code/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
fi
