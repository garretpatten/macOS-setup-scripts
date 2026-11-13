#!/bin/bash
# Shared setup for the bats unit tests. Load with: load helpers/setup

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "$TESTS_DIR/.." && pwd)"
REAL_SCRIPTS_DIR="$REPO_ROOT/src/scripts"
export TESTS_DIR REPO_ROOT REAL_SCRIPTS_DIR

# bats-support, bats-assert and bats-file live in different places depending on
# how they were installed (bats-action, Homebrew, distro packages).
BATS_LIB_PATH="${BATS_LIB_PATH:+$BATS_LIB_PATH:}/usr/lib:/usr/local/lib:/opt/homebrew/lib"
export BATS_LIB_PATH

# Child scripts replaced by tests/fixtures/child-script.sh in the sandbox tree.
FIXTURE_INSTALL_SCRIPTS=(pre-install cli media productivity dev security shell post-install)
FIXTURE_CONFIG_SCRIPTS=(system-config organizeHome dev shell tmux-plugins completion)

common_setup() {
    # run --separate-stderr needs bats >= 1.5.0.
    bats_require_minimum_version 1.5.0
    bats_load_library bats-support
    bats_load_library bats-assert
    bats_load_library bats-file

    SANDBOX="$(mktemp -d "${BATS_TMPDIR:-/tmp}/macos-setup-tests.XXXXXX")"
    export SANDBOX
    export HOME="$SANDBOX/home"
    mkdir -p "$HOME"

    # Fake binaries (curl, zsh) shadow the real ones.
    export PATH="$TESTS_DIR/stubs:$PATH"
    export STUB_CALL_LOG="$SANDBOX/stub-calls.log"
    export CALL_LOG="$SANDBOX/child-calls.log"
    unset FIXTURE_FAIL CURL_STUB_MODE CURL_STUB_BODY
}

common_teardown() {
    if [[ -n "${SANDBOX:-}" && -d "$SANDBOX" ]]; then
        rm -rf "$SANDBOX"
    fi
}

# Build $SANDBOX/project/src/scripts with copies of the real utils.sh and
# orchestrators, and a recording fixture in place of every child script.
# utils.sh derives PROJECT_ROOT from its own location, so ERROR_LOG_FILE
# points at $SANDBOX/project/setup_errors.log.
build_scripts_fixture() {
    FIXTURE_SCRIPTS_DIR="$SANDBOX/project/src/scripts"
    FIXTURE_ERROR_LOG="$SANDBOX/project/setup_errors.log"
    export FIXTURE_SCRIPTS_DIR FIXTURE_ERROR_LOG

    mkdir -p "$FIXTURE_SCRIPTS_DIR/install" "$FIXTURE_SCRIPTS_DIR/config"
    cp "$REAL_SCRIPTS_DIR/utils.sh" \
        "$REAL_SCRIPTS_DIR/run-install.sh" \
        "$REAL_SCRIPTS_DIR/master.sh" \
        "$FIXTURE_SCRIPTS_DIR/"

    local name
    for name in "${FIXTURE_INSTALL_SCRIPTS[@]}"; do
        cp "$TESTS_DIR/fixtures/child-script.sh" "$FIXTURE_SCRIPTS_DIR/install/$name.sh"
    done
    for name in "${FIXTURE_CONFIG_SCRIPTS[@]}"; do
        cp "$TESTS_DIR/fixtures/child-script.sh" "$FIXTURE_SCRIPTS_DIR/config/$name.sh"
    done
}
