#!/bin/bash

# Run Homebrew installs, external installers, and repo clones (no defaults/dotfiles).
# Pass --ci to skip pre-install.sh (Homebrew bootstrap, Xcode CLT, softwareupdate).

# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"

if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "Install scripts require macOS. Current OS: $OSTYPE"
    exit 1
fi

SKIP_PRE_INSTALL=false
for arg in "$@"; do
    if [[ "$arg" == "--ci" ]]; then
        SKIP_PRE_INSTALL=true
    fi
done

IDIR="$SCRIPTS_DIR/install"

run_install() {
    bash "$1" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute $1"
}

if ! $SKIP_PRE_INSTALL; then
    run_install "$IDIR/pre-install.sh"
fi

run_install "$IDIR/cli.sh"
run_install "$IDIR/media.sh"
run_install "$IDIR/productivity.sh"
run_install "$IDIR/dev.sh"
run_install "$IDIR/security.sh"
run_install "$IDIR/shell.sh"
run_install "$IDIR/post-install.sh"
