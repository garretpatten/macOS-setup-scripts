#!/bin/bash

# Balena-Etcher
if [[ ! -d "usr/local/Caskroom/balena-etcher/" ]]; then
    brew install --cask balena-etcher
fi

# Chat GPT
if [[ ! -d "usr/local/Caskroom/chatgpt/" ]]; then
    brew install --cask chatgpt
fi

# Notion
if [[ ! -d "usr/local/Caskroom/notion/" ]]; then
    brew install --cask notion
fi

# Proton Drive
if [[ ! -d "usr/local/Caskroom/proton-drive/" ]]; then
    brew install --cask proton-drive
fi

# Proton Mail
if [[ ! -d "usr/local/Caskroom/proton-mail/" ]]; then
    brew install --cask proton-mail
fi

# Raycast
if [[ ! -d "usr/local/cellar/raycast/" ]]; then
    brew install raycast
fi

# Zoom
if [[ ! -d "usr/local/Caskroom/zoom/" ]]; then
    brew install --cask zoom
fi
