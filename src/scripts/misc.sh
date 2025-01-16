#!/bin/bash

# Install Balena Etcher, Zoom
caskApps=("balenaetcher" "zoom")
for caskApp in ${caskApps[@]}; do
    if [[ ! -d "usr/local/Caskroom/$caskApp/" ]]; then
        brew install --cask "$caskApp"
    fi
done
