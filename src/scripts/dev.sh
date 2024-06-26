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

# TODO: Python and pip
brew install python@3.12

### Frameworks ###

# TODO: Install Angular

# TODO: Install Vue.js

### Dev Tools ###

# TODO: Install Docker and Docker-Compose

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
fi
