#!/bin/bash

# Brave
if [[ ! -d "usr/local/Caskroom/brave-browser/" ]]; then
    brew install --cask brave-browser
fi

# DuckDuckGo
if [[ ! -d "usr/local/Caskroom/duckduckgo/" ]]; then
    brew install --cask duckduckgo
fi

# Spotify
if [[ ! -d "usr/local/Caskroom/spotify/" ]]; then
    brew install --cask spotify
fi

# VLC
if [[ ! -d "usr/local/Caskroom/vlc/" ]]; then
    brew install --cask vlc
fi
