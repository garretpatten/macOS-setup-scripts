#!/bin/bash

# Brave
if [[ ! -d "usr/local/Caskroom/brave-browser/" ]]; then
    brew install --cask brave-browser
fi

# DuckDuckGo
if [[ ! -d "usr/local/Caskroom/duckduckgo/" ]]; then
    brew install --cask duckduckgo
fi
