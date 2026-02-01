#!/bin/bash

source "$(dirname "$0")/utils.sh"

if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>>"$ERROR_LOG_FILE" || true
fi

brew update 2>>"$ERROR_LOG_FILE" || true
brew upgrade 2>>"$ERROR_LOG_FILE" || true
brew cleanup 2>>"$ERROR_LOG_FILE" || true
brew analytics off 2>>"$ERROR_LOG_FILE" || true

sudo rm -rf /Library/Developer/CommandLineTools/ 2>>"$ERROR_LOG_FILE" || true
sudo xcode-select --install 2>>"$ERROR_LOG_FILE" || true
sudo xcodebuild -license accept 2>>"$ERROR_LOG_FILE" || true
softwareupdate --all --install --force 2>>"$ERROR_LOG_FILE" || true
