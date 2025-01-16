#!/bin/bash

# Spotify
if [[ ! -d "usr/local/Caskroom/spotify/" ]]; then
    brew install --cask spotify
fi

# VLC
if [[ ! -d "usr/local/Caskroom/vlc/" ]]; then
    brew install --cask vlc
fi

# Zoom
if [[ ! -d "usr/local/Caskroom/zoom/" ]]; then
    brew install --cask zoom
fi
