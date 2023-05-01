#!/bin/bash

# Do a fresh install of Xcode Command Line Tools and accept license
sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install
sudo xcodebuild -license accept
