#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

brew install --cask balenaetcher google-gemini notion proton-drive proton-mail zoom 2>>"$ERROR_LOG_FILE" || true
brew install raycast 2>>"$ERROR_LOG_FILE" || true
