#!/bin/bash

# Apply macOS defaults, home layout, dotfiles, and related configuration (no brew installs).

# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"

if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "Config scripts require macOS. Current OS: $OSTYPE"
    exit 1
fi

CDIR="$SCRIPTS_DIR/config"

run_config() {
    bash "$1" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute $1"
}

run_config "$CDIR/system-config.sh"
run_config "$CDIR/organizeHome.sh"
run_config "$CDIR/dev.sh"
zsh "$CDIR/shell.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute config/shell.sh"
run_config "$CDIR/completion.sh"
