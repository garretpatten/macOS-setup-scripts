#!/usr/bin/env bats
# Unit tests for src/scripts/master.sh orchestration with stubbed child scripts.
#
# master.sh defines run(), which would shadow bats' own run when sourced into
# the test shell, so master.sh is sourced inside a child bash instead.
# Each @test runs in its own subshell, so per-test variable changes are intentional.
# shellcheck disable=SC2030,SC2031

setup() {
    load helpers/setup
    common_setup
    build_scripts_fixture
}

teardown() {
    common_teardown
}

# Source master.sh in a child shell, pretend to be macOS, and call main "$@".
master_main() {
    bash -c 'source "$1"; shift; OSTYPE="darwin23"; main "$@"' \
        _ "$FIXTURE_SCRIPTS_DIR/master.sh" "$@"
}

# Source master.sh in a child shell and call its run() helper on one script.
master_run() {
    bash -c 'source "$1"; run "$2"' _ "$FIXTURE_SCRIPTS_DIR/master.sh" "$1"
}

@test "sourcing master.sh does not run any child scripts" {
    run bash -c 'source "$1"; type -t main; type -t run' _ "$FIXTURE_SCRIPTS_DIR/master.sh"
    assert_success
    assert_output "$(printf '%s\n' function function)"
    assert_file_not_exists "$CALL_LOG"
}

@test "main --ci runs install and config steps in the interleaved order" {
    run master_main --ci
    assert_success

    run cat "$CALL_LOG"
    assert_output "$(printf '%s\n' \
        config/system-config.sh \
        config/organizeHome.sh \
        install/cli.sh \
        install/media.sh \
        install/productivity.sh \
        install/dev.sh \
        config/dev.sh \
        install/security.sh \
        install/shell.sh \
        install/post-install.sh \
        config/shell.sh \
        config/tmux-plugins.sh \
        config/completion.sh)"
    # 2>> creates the log, but nothing should be written to it.
    assert_file_empty "$FIXTURE_ERROR_LOG"
}

@test "main without --ci runs pre-install.sh first" {
    run master_main
    assert_success
    run cat "$CALL_LOG"
    assert_line --index 0 install/pre-install.sh
    assert_line --index 1 config/system-config.sh
    assert_equal "${#lines[@]}" 14
}

@test "config/shell.sh is run with zsh" {
    run master_main --ci
    assert_success
    assert_file_contains "$STUB_CALL_LOG" "^zsh $FIXTURE_SCRIPTS_DIR/config/shell.sh$"
    assert_equal "$(grep -c '^zsh ' "$STUB_CALL_LOG")" 1
}

@test "main refuses to run outside macOS" {
    run bash -c 'source "$1"; OSTYPE="linux-gnu"; main --ci' _ "$FIXTURE_SCRIPTS_DIR/master.sh"
    assert_failure 1
    assert_file_not_exists "$CALL_LOG"
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "This script is designed for macOS only. Current OS: linux-gnu"
}

@test "a failing child script is logged and later steps still run" {
    export FIXTURE_FAIL="config/dev.sh"
    run master_main --ci
    assert_success

    assert_file_contains "$FIXTURE_ERROR_LOG" "^fixture failure: config/dev.sh$"
    assert_file_contains "$FIXTURE_ERROR_LOG" "\[ERROR\] Failed to execute .*/config/dev.sh$"
    run cat "$CALL_LOG"
    assert_line --index 7 install/security.sh
    assert_line --index 12 config/completion.sh
}

@test "a failing zsh config/shell.sh step is logged" {
    export FIXTURE_FAIL="config/shell.sh"
    run master_main --ci
    assert_success
    assert_file_contains "$FIXTURE_ERROR_LOG" "\[ERROR\] Failed to execute config/shell.sh$"
    run cat "$CALL_LOG"
    assert_line --index 12 config/completion.sh
}

@test "run() failure path writes to the error log" {
    run master_run "$FIXTURE_SCRIPTS_DIR/install/missing.sh"
    assert_success
    assert_file_contains "$FIXTURE_ERROR_LOG" "\[ERROR\] Failed to execute .*/install/missing.sh$"
}

@test "run() success leaves the error log untouched" {
    run master_run "$FIXTURE_SCRIPTS_DIR/install/cli.sh"
    assert_success
    assert_file_contains "$CALL_LOG" "^install/cli.sh$"
    # 2>> creates the log, but nothing should be written to it.
    assert_file_empty "$FIXTURE_ERROR_LOG"
}
