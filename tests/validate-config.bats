#!/usr/bin/env bats
# Unit tests for src/scripts/config/validate-config.sh, run against a sandbox
# project tree with fixture dotfiles sources, manifest, and provisioned $HOME
# copies. Each @test runs in its own subshell, so per-test mutations are fine.
# shellcheck disable=SC2030,SC2031

setup() {
    load helpers/setup
    common_setup

    # The script resolves ${XDG_CONFIG_HOME:-$HOME/.config}; pin it to the
    # sandbox home so the host environment cannot leak in.
    export XDG_CONFIG_HOME="$HOME/.config"

    # Sandbox project tree with the real utils.sh and validate-config.sh so
    # PROJECT_ROOT and ERROR_LOG_FILE resolve inside $SANDBOX.
    FIXTURE_SCRIPTS_DIR="$SANDBOX/project/src/scripts"
    FIXTURE_ERROR_LOG="$SANDBOX/project/setup_errors.log"
    export FIXTURE_SCRIPTS_DIR FIXTURE_ERROR_LOG
    DOTFILES_DIR="$SANDBOX/project/src/dotfiles"
    export DOTFILES_DIR
    mkdir -p "$FIXTURE_SCRIPTS_DIR/config" \
        "$DOTFILES_DIR/home/.cargo" "$DOTFILES_DIR/config/pip" "$DOTFILES_DIR/config/uv"
    cp "$REAL_SCRIPTS_DIR/utils.sh" "$FIXTURE_SCRIPTS_DIR/utils.sh"
    cp "$REAL_SCRIPTS_DIR/config/validate-config.sh" \
        "$FIXTURE_SCRIPTS_DIR/config/validate-config.sh"

    # All four cooldown sources, matching the real dotfiles content.
    printf 'min-release-age=7\n' > "$DOTFILES_DIR/home/.npmrc"
    printf '[registry]\nglobal-min-publish-age = "7 days"\n' \
        > "$DOTFILES_DIR/home/.cargo/config.toml"
    printf '[global]\nuploaded-prior-to = P7D\n' > "$DOTFILES_DIR/config/pip/pip.conf"
    printf 'exclude-newer = "7 days"\n' > "$DOTFILES_DIR/config/uv/uv.toml"

    # Manifest declaring the home-file copies.
    cat > "$FIXTURE_SCRIPTS_DIR/config/dotfiles.manifest" <<'MANIFEST'
# File copies only; XDG config dirs are symlinked via link_dotfiles_xdg_config_dirs in dotfiles.sh

file home/.vimrc ~/.vimrc
file home/.npmrc ~/.npmrc
file home/.cargo/config.toml ~/.cargo/config.toml
MANIFEST

    # Provisioned copies: manifest file copies and the XDG config symlinks.
    mkdir -p "$HOME/.cargo" "$HOME/.config"
    cp "$DOTFILES_DIR/home/.npmrc" "$HOME/.npmrc"
    cp "$DOTFILES_DIR/home/.cargo/config.toml" "$HOME/.cargo/config.toml"
    ln -s "$DOTFILES_DIR/config/pip" "$HOME/.config/pip"
    ln -s "$DOTFILES_DIR/config/uv" "$HOME/.config/uv"
}

teardown() {
    common_teardown
}

run_validate() {
    run --separate-stderr bash "$FIXTURE_SCRIPTS_DIR/config/validate-config.sh"
}

@test "passes when all cooldown configs are present" {
    run_validate
    assert_success
    # 2>> creates the log, but nothing should be written to it.
    assert_file_empty "$FIXTURE_ERROR_LOG"
}

@test "fails when a source cooldown config is missing" {
    rm "$DOTFILES_DIR/config/uv/uv.toml"
    run_validate
    assert_failure
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] uv cooldown config in src/dotfiles is missing: .*/src/dotfiles/config/uv/uv.toml$"
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] Package supply-chain cooldown validation failed (2 check(s))$"
}

@test "fails when a source config drops the cooldown key" {
    printf '[registry]\n# cooldown removed\n' > "$DOTFILES_DIR/home/.cargo/config.toml"
    run_validate
    assert_failure
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] cargo cooldown config in src/dotfiles does not enable the cooldown (no 'global-min-publish-age')"
}

@test "fails when the manifest does not copy a home cooldown file" {
    grep -v '^file home/.cargo/config.toml ' \
        "$FIXTURE_SCRIPTS_DIR/config/dotfiles.manifest" > "$SANDBOX/manifest.tmp"
    mv "$SANDBOX/manifest.tmp" "$FIXTURE_SCRIPTS_DIR/config/dotfiles.manifest"
    run_validate
    assert_failure
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] config/dotfiles.manifest does not copy home/.cargo/config.toml$"
}

@test "fails when a provisioned copy is missing" {
    rm "$HOME/.npmrc"
    run_validate
    assert_failure
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] npm cooldown config (~/.npmrc) is missing: .*/\.npmrc$"
}

@test "fails when the whole ~/.cargo tree is symlinked" {
    rm -rf "$HOME/.cargo"
    ln -s "$DOTFILES_DIR/home/.cargo" "$HOME/.cargo"
    run_validate
    assert_failure
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] .*/\.cargo is a symlink; rustup owns its bin, env, and registry"
}

@test "reports every gap in one run" {
    rm "$DOTFILES_DIR/config/pip/pip.conf"
    grep -v '^file home/.npmrc ' \
        "$FIXTURE_SCRIPTS_DIR/config/dotfiles.manifest" > "$SANDBOX/manifest.tmp"
    mv "$SANDBOX/manifest.tmp" "$FIXTURE_SCRIPTS_DIR/config/dotfiles.manifest"
    run_validate
    assert_failure
    # Source, its dangling provisioned copy, and the manifest entry: 3 checks.
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] pip cooldown config in src/dotfiles is missing"
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] pip cooldown config (~/.config/pip/pip.conf) is missing"
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] config/dotfiles.manifest does not copy home/.npmrc$"
    assert_file_contains "$FIXTURE_ERROR_LOG" \
        "\[ERROR\] Package supply-chain cooldown validation failed (3 check(s))$"
}
