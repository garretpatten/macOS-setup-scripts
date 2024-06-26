#!/bin/bash

# Balena-Etcher
if [[ ! -d "usr/local/Caskroom/balena-etcher/" ]]; then
    brew install --cask balena-etcher
fi

# Spectacle
if [[ ! -d "usr/local/cellar/spectacle/" ]]; then
    brew install spectacle
fi

# Taskwarrior
if [[ ! -d "usr/local/cellar/task/" ]]; then
    brew install task

    # Handle first prompt (to create config file)
    echo "yes" | task

    # Update ~/.taskrc
    cat "$workingDirectory/src/dotfiles/taskwarrior/.taskrc-additions" >> "$HOME/.taskrc"

    # Add manual setup tasks
    task add Log in to iCloud project:mac priority:H
    task add Export GitHub PAT with 1Password project:dev priority:H
    task add Clean up .zshrc file project:setup priority:H

    task add Install Notion project:PWAs priority:M
    task add Install Proton Drive project:PWAs priority:M
    task add Install Proton Mail project:PWAs priority:M
    task add Sign into and sync Brave project:setup priority:M
    task add Configure 1Password project:setup priority:M

    task add Take a snapshot of system project:setup priority:L
    task add Download needed files from Proton Drive project:setup priority:L
    task add Configure VS Code settings project:dev priority:L
fi

# Create directory for custom taskwarrior themes
if [[ ! -d "$HOME/.task/themes/" ]]; then
    mkdir "$HOME/.task/themes/"
    cp "$(pwd)/src/dotfiles/taskwarrior/themes/" "$HOME/.task/themes/"
fi

# Todoist
if [[ -d "/usr/local/Caskroom/todoist/" ]]; then
    brew install --cask todoist
fi
