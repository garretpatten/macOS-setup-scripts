#!/bin/bash

# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"

if [[ -d "$HOME/Templates" ]]; then
    rmdir "$HOME/Templates" 2>>"$ERROR_LOG_FILE" || true
fi
mkdir -p "$HOME/Books" "$HOME/Games" "$HOME/Hacking" "$HOME/Projects" 2>>"$ERROR_LOG_FILE" || true
