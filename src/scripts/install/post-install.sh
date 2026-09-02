#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

brew update 2>>"$ERROR_LOG_FILE" || true
brew upgrade 2>>"$ERROR_LOG_FILE" || true
brew cleanup 2>>"$ERROR_LOG_FILE" || true

if command -v tldr >/dev/null 2>&1; then
    tldr --update 2>>"$ERROR_LOG_FILE" || true
fi
