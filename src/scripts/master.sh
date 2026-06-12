#!/bin/bash

# Full provisioning: same chronological order as the original master script —
# system defaults and home layout early, category installs, dev configuration
# right after dev installs, shell configuration after brew maintenance.

# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"

if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only. Current OS: $OSTYPE"
    exit 1
fi

ROOT="$(dirname "$0")"
IDIR="$ROOT/install"
CDIR="$ROOT/config"

run() {
    bash "$1" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute $1"
}

SKIP_PRE_INSTALL=false
for arg in "$@"; do
    if [[ "$arg" == "--ci" ]]; then
        SKIP_PRE_INSTALL=true
    fi
done

if ! $SKIP_PRE_INSTALL; then
    run "$IDIR/pre-install.sh"
fi

run "$CDIR/system-config.sh"
run "$CDIR/organizeHome.sh"

run "$IDIR/cli.sh"
run "$IDIR/media.sh"
run "$IDIR/productivity.sh"
run "$IDIR/dev.sh"
run "$CDIR/dev.sh"
run "$IDIR/security.sh"
run "$IDIR/shell.sh"
run "$IDIR/post-install.sh"

zsh "$CDIR/shell.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute config/shell.sh"
run "$CDIR/completion.sh"
