#!/bin/bash

source "$(dirname "$0")/utils.sh"

brew update 2>>"$ERROR_LOG_FILE" || true
brew upgrade 2>>"$ERROR_LOG_FILE" || true
brew cleanup 2>>"$ERROR_LOG_FILE" || true

if [[ -f "$PROJECT_ROOT/src/assets/wolf.txt" ]]; then
    cat "$PROJECT_ROOT/src/assets/wolf.txt"
    echo
fi
