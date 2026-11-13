#!/usr/bin/env bats
# Unit tests for src/scripts/run-install.sh, run against a sandbox
# src/scripts fixture tree whose child scripts only record that they ran.
# Each @test runs in its own subshell, so per-test variable changes are intentional.
# shellcheck disable=SC2030,SC2031

setup() {
    load helpers/setup
    common_setup
    build_scripts_fixture

    # shellcheck source=../src/scripts/run-install.sh
    source "$FIXTURE_SCRIPTS_DIR/run-install.sh"
}

teardown() {
    common_teardown
}

@test "sourcing run-install.sh defines functions without running installs" {
    assert_equal "$(type -t main)" "function"
    assert_equal "$(type -t run_install)" "function"
    assert_file_not_exists "$CALL_LOG"
}

@test "sourced run-install.sh writes errors to the sandbox log" {
    assert_equal "$ERROR_LOG_FILE" "$FIXTURE_ERROR_LOG"
    assert_equal "$IDIR" "$FIXTURE_SCRIPTS_DIR/install"
}

@test "main --ci skips pre-install.sh and runs installs in order" {
    OSTYPE="darwin23"
    run main --ci
    assert_success

    run cat "$CALL_LOG"
    assert_output "$(printf '%s\n' \
        install/cli.sh \
        install/media.sh \
        install/productivity.sh \
        install/dev.sh \
        install/security.sh \
        install/shell.sh \
        install/post-install.sh)"
    refute_line install/pre-install.sh
    # 2>> creates the log, but nothing should be written to it.
    assert_file_empty "$FIXTURE_ERROR_LOG"
}

@test "main without --ci runs pre-install.sh first" {
    OSTYPE="darwin23"
    run main
    assert_success

    run cat "$CALL_LOG"
    assert_line --index 0 install/pre-install.sh
    assert_line --index 1 install/cli.sh
    assert_line --index 7 install/post-install.sh
    assert_equal "${#lines[@]}" 8
}

@test "main ignores unrelated arguments" {
    OSTYPE="darwin23"
    run main --verbose
    assert_success
    run cat "$CALL_LOG"
    assert_line --index 0 install/pre-install.sh
}

@test "main refuses to run outside macOS" {
    OSTYPE="linux-gnu"
    run --separate-stderr main --ci
    assert_failure 1
    assert_file_not_exists "$CALL_LOG"
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] Install scripts require macOS. Current OS: linux-gnu"
}

@test "run_install failure logs to the error log and the run continues" {
    OSTYPE="darwin23"
    export FIXTURE_FAIL="install/security.sh"
    run --separate-stderr main --ci
    assert_success

    # Child stderr and the log_error line both land in ERROR_LOG_FILE.
    assert_file_contains "$FIXTURE_ERROR_LOG" "^fixture failure: install/security.sh$"
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] Failed to execute $FIXTURE_SCRIPTS_DIR/install/security.sh$"
    assert_equal "$(grep -c 'Failed to execute' "$FIXTURE_ERROR_LOG")" 1

    # Later scripts still ran.
    run cat "$CALL_LOG"
    assert_line --index 5 install/shell.sh
    assert_line --index 6 install/post-install.sh
}

@test "run_install on a missing script logs a failure" {
    run --separate-stderr run_install "$FIXTURE_SCRIPTS_DIR/install/nope.sh"
    assert_success
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] Failed to execute $FIXTURE_SCRIPTS_DIR/install/nope.sh$"
}

@test "executing run-install.sh directly calls main with its arguments" {
    run --separate-stderr bash "$FIXTURE_SCRIPTS_DIR/run-install.sh" --ci
    if [[ "$OSTYPE" == "darwin"* ]]; then
        assert_success
        run cat "$CALL_LOG"
        refute_line install/pre-install.sh
        assert_line install/post-install.sh
    else
        assert_failure 1
        assert_file_contains "$FIXTURE_ERROR_LOG" "Install scripts require macOS"
    fi
}
