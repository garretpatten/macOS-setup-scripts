#!/bin/bash

source "$(dirname "$0")/utils.sh"

[[ -d "$HOME/Templates" ]] && rmdir "$HOME/Templates" 2>>"$ERROR_LOG_FILE" || true
mkdir -p "$HOME/Books" "$HOME/Games" "$HOME/Hacking" "$HOME/Projects" 2>>"$ERROR_LOG_FILE" || true
