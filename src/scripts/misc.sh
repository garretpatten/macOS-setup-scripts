#!/bin/bash

# Install Balena Etcher, Zoom
caskApps=("balenaetcher" "chatgpt" "zoom")
for caskApp in ${caskApps[@]}; do
    if [[ ! -d "usr/local/Caskroom/$caskApp/" ]]; then
        brew install --cask "$caskApp"
    fi
done
