#!/bin/bash

# Full provisioning: same chronological order as the original master script —
# system defaults and home layout early, category installs, dev configuration
# right after dev installs, shell configuration after brew maintenance.

# shellcheck source=utils.sh
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

ROOT="$(dirname "${BASH_SOURCE[0]}")"
IDIR="$ROOT/install"
CDIR="$ROOT/config"

run() {
    bash "$1" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute $1"
}

main() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script is designed for macOS only. Current OS: $OSTYPE"
        exit 1
    fi

    local skip_pre_install=false
    local arg
    for arg in "$@"; do
        if [[ "$arg" == "--ci" ]]; then
            skip_pre_install=true
        fi
    done

    if ! $skip_pre_install; then
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
    run "$CDIR/tmux-plugins.sh"
    run "$CDIR/completion.sh"
}

# Only run when executed directly, so tests can source this file safely.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
