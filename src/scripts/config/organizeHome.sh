#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

rmdir "$HOME/Music" 2>>"$ERROR_LOG_FILE" || true
rmdir "$HOME/Public" 2>>"$ERROR_LOG_FILE" || true
rmdir "$HOME/Templates" 2>>"$ERROR_LOG_FILE" || true
mkdir -p "$HOME/AppImages" "$HOME/Books" "$HOME/Games" "$HOME/Hacking" "$HOME/Projects/opensource" "$HOME/Projects/personal" 2>>"$ERROR_LOG_FILE" || true
if [[ -d "$HOME/Scripts" ]]; then
    chmod 755 "$HOME/Scripts" 2>>"$ERROR_LOG_FILE" || true
fi
if [[ -d "$HOME/Hacking" ]]; then
    chmod 700 "$HOME/Hacking" 2>>"$ERROR_LOG_FILE" || true
fi
