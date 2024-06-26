#!/bin/bash

# Xcode Command Line Tools Fresh Install
xcodePath="/Library/Developer/CommandLineTools/"

if [[ -d "$xcodePath" ]]; then
    sudo rm -rf "$xcodePath"
fi

sudo xcode-select --install
sudo xcodebuild -license accept

# Homebrew package manager
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

# System updates
brew update && brew upgrade && brew cleanup
