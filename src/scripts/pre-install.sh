#!/bin/bash

# Fresh Install of Xcode Command Line Tools
xcodePath="/Library/Developer/CommandLineTools/"

if [[ -d "$xcodePath"]]; then
	sudo rm -rf "$xcodePath"
fi

sudo xcode-select --install
sudo xcodebuild -license accept
