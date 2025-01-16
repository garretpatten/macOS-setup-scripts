#!/bin/bash

# Notion
if [[ ! -d "/opt/homebrew/Caskroom/notion/" ]]; then
    brew install --cask notion
fi

# Raycast
if [[ ! -d "usr/local/cellar/raycast/" ]]; then
    brew install raycast
fi

# Todoist
if [[ -d "/opt/homebrew/Caskroom/todoist/" ]]; then
    brew install --cask todoist
fi
