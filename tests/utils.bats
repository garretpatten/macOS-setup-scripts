#!/usr/bin/env bats
# Unit tests for src/scripts/utils.sh.
# Each @test runs in its own subshell, so per-test variable changes are intentional.
# shellcheck disable=SC2030,SC2031

setup() {
    load helpers/setup
    common_setup

    # shellcheck source=../src/scripts/utils.sh
    source "$REAL_SCRIPTS_DIR/utils.sh"
    # Keep every write inside the sandbox.
    ERROR_LOG_FILE="$SANDBOX/setup_errors.log"
    FILES="$TESTS_DIR/fixtures/files"
}

teardown() {
    common_teardown
}

# --- paths -------------------------------------------------------------------

@test "utils.sh exports repo paths relative to its own location" {
    assert_equal "$SCRIPTS_DIR" "$REAL_SCRIPTS_DIR"
    assert_equal "$SCRIPT_DIR" "$REAL_SCRIPTS_DIR"
    assert_equal "$PROJECT_ROOT" "$REPO_ROOT"
}

# --- log_error ---------------------------------------------------------------

@test "log_error writes a red [ERROR] line to stderr only" {
    run --separate-stderr log_error "something broke"
    assert_success
    assert_output ""
    # shellcheck disable=SC2154 # $stderr is set by run --separate-stderr
    assert_equal "$stderr" $'\033[0;31m[ERROR]\033[0m something broke'
}

@test "log_error appends a timestamped line to ERROR_LOG_FILE" {
    log_error "first" 2>/dev/null
    log_error "second" 2>/dev/null

    assert_file_exists "$ERROR_LOG_FILE"
    run cat "$ERROR_LOG_FILE"
    assert_line --index 0 --regexp '^\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\] \[ERROR\] first$'
    assert_line --index 1 --regexp '^\[[0-9-]+ [0-9:]+\] \[ERROR\] second$'
    assert_equal "${#lines[@]}" 2
}

# --- ensure_directory --------------------------------------------------------

@test "ensure_directory creates nested directories" {
    ensure_directory "$HOME/a/b/c"
    assert_dir_exists "$HOME/a/b/c"
}

@test "ensure_directory is a no-op for an existing directory" {
    mkdir -p "$HOME/existing"
    touch "$HOME/existing/keep"
    run ensure_directory "$HOME/existing"
    assert_success
    assert_file_exists "$HOME/existing/keep"
}

@test "ensure_directory never fails and logs mkdir errors" {
    touch "$HOME/blocker"
    run ensure_directory "$HOME/blocker/child"
    assert_success
    assert_file_not_exists "$HOME/blocker/child"
    assert_file_contains "$ERROR_LOG_FILE" "mkdir"
}

# --- copy_file_safe ----------------------------------------------------------

@test "copy_file_safe copies into a missing destination directory" {
    run copy_file_safe "$FILES/sample.txt" "$HOME/new/dir/sample.txt"
    assert_success
    assert_files_equal "$FILES/sample.txt" "$HOME/new/dir/sample.txt"
}

@test "copy_file_safe does not overwrite an existing destination" {
    echo "keep me" >"$HOME/sample.txt"
    run copy_file_safe "$FILES/sample.txt" "$HOME/sample.txt"
    assert_success
    assert_file_contains "$HOME/sample.txt" "^keep me$"
}

@test "copy_file_safe is idempotent across repeated runs" {
    copy_file_safe "$FILES/sample.txt" "$HOME/sample.txt"
    copy_file_safe "$FILES/sample.txt" "$HOME/sample.txt"
    assert_files_equal "$FILES/sample.txt" "$HOME/sample.txt"
}

@test "copy_file_safe skips a missing source without creating anything" {
    run copy_file_safe "$FILES/does-not-exist.txt" "$HOME/out/missing.txt"
    assert_success
    assert_not_exists "$HOME/out"
}

@test "copy_file_safe treats a directory source as missing" {
    run copy_file_safe "$FILES/sample-dir" "$HOME/sample-dir"
    assert_success
    assert_not_exists "$HOME/sample-dir"
}

# --- copy_directory_safe -----------------------------------------------------

@test "copy_directory_safe copies a tree recursively" {
    run copy_directory_safe "$FILES/sample-dir" "$HOME/parent/sample-dir"
    assert_success
    assert_files_equal "$FILES/sample-dir/top.txt" "$HOME/parent/sample-dir/top.txt"
    assert_files_equal "$FILES/sample-dir/nested/inner.txt" \
        "$HOME/parent/sample-dir/nested/inner.txt"
}

@test "copy_directory_safe does not touch an existing destination directory" {
    mkdir -p "$HOME/sample-dir"
    echo "mine" >"$HOME/sample-dir/top.txt"
    run copy_directory_safe "$FILES/sample-dir" "$HOME/sample-dir"
    assert_success
    assert_file_contains "$HOME/sample-dir/top.txt" "^mine$"
    # No nested copy (cp -r into an existing dir would create sample-dir/sample-dir).
    assert_not_exists "$HOME/sample-dir/sample-dir"
    assert_not_exists "$HOME/sample-dir/nested"
}

@test "copy_directory_safe is idempotent across repeated runs" {
    copy_directory_safe "$FILES/sample-dir" "$HOME/sample-dir"
    copy_directory_safe "$FILES/sample-dir" "$HOME/sample-dir"
    assert_not_exists "$HOME/sample-dir/sample-dir"
    assert_files_equal "$FILES/sample-dir/top.txt" "$HOME/sample-dir/top.txt"
}

@test "copy_directory_safe skips a missing source" {
    run copy_directory_safe "$FILES/no-such-dir" "$HOME/no-such-dir"
    assert_success
    assert_not_exists "$HOME/no-such-dir"
}

# --- download_file_safe (curl stubbed) ---------------------------------------

@test "download_file_safe saves the downloaded body on success" {
    export CURL_STUB_MODE=success CURL_STUB_BODY="hello"
    run download_file_safe "https://example.test/file" "$HOME/file"
    assert_success
    assert_file_contains "$HOME/file" "^hello$"
    assert_file_contains "$STUB_CALL_LOG" " --fail "
    assert_file_contains "$STUB_CALL_LOG" "https://example.test/file -o $HOME/file"
    assert_file_not_exists "$ERROR_LOG_FILE"
}

@test "download_file_safe returns 1, logs, and removes the file when curl fails" {
    export CURL_STUB_MODE=fail
    run download_file_safe "https://example.test/missing" "$HOME/missing"
    assert_failure 1
    assert_file_not_exists "$HOME/missing"
    assert_file_contains "$ERROR_LOG_FILE" "\[ERROR\] Failed to download https://example.test/missing"
}

@test "download_file_safe rejects an empty download" {
    export CURL_STUB_MODE=empty
    run download_file_safe "https://example.test/empty" "$HOME/empty"
    assert_failure 1
    assert_file_not_exists "$HOME/empty"
    assert_file_contains "$ERROR_LOG_FILE" "Downloaded file is empty or missing: $HOME/empty"
}

@test "download_file_safe short-circuits when the destination already exists" {
    echo "already here" >"$HOME/file"
    export CURL_STUB_MODE=fail
    run download_file_safe "https://example.test/file" "$HOME/file"
    assert_success
    assert_file_contains "$HOME/file" "^already here$"
    assert_file_not_exists "$STUB_CALL_LOG"
}

@test "download_file_safe re-downloads over an empty existing file" {
    : >"$HOME/file"
    export CURL_STUB_MODE=success CURL_STUB_BODY="fresh"
    run download_file_safe "https://example.test/file" "$HOME/file"
    assert_success
    assert_file_contains "$HOME/file" "^fresh$"
}
