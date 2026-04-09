#!/bin/bash

# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"

brew install --cask brave-browser duckduckgo spotify vlc 2>>"$ERROR_LOG_FILE" || true
