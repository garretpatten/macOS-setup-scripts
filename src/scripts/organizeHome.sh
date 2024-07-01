#!/bin/bash

# Remove unneeded directories
directoriesToRemove=("Music" "Public" "Templates" "Videos")
for directoryToRemove in ${directoriesToRemove[@]}; do
    if [[ ! -d "$HOME/$directoryToRemove/" ]]; then
        rmdir "$HOME/$directoryToRemove"
    fi
done

# Add needed directories
directoriesToCreate=("Books" "Hacking" "Projects")
for directoryToCreate in ${directoriesToCreate[@]}; do
    if [[ ! -d "$HOME/$directoryToCreate/" ]]; then
        mkdir "$HOME/$directoryToCreate"
    fi
done
