#!/bin/bash

# Remove unneeded directories
directoriesToRemove=("Public" "Templates")
for directoryToRemove in "${directoriesToRemove[@]}"; do
    if [[ ! -d "$HOME/$directoryToRemove/" ]]; then
        rmdir "$HOME/$directoryToRemove"
    fi
done

# Add needed directories
directoriesToCreate=("Books" "Games" "Hacking" "Projects")
for directoryToCreate in "${directoriesToCreate[@]}"; do
    if [[ ! -d "$HOME/$directoryToCreate/" ]]; then
        mkdir "$HOME/$directoryToCreate"
    fi
done
