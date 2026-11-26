#!/bin/bash

# Assert the 7-day package supply-chain cooldown configs (garretpatten/dotfiles#51)
# are present: sources in the pinned src/dotfiles submodule, manifest entries so
# fresh installs provision them, and the provisioned copies in $HOME with the
# cooldown keys active. Reports every gap before exiting non-zero.

# shellcheck source=../utils.sh
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

FAILURES=0

# Every check appends a log_error and bumps FAILURES instead of exiting on the
# first miss, so one run reports the full set of gaps.
check_cooldown_file() {
    local description="$1" path="$2" key="$3"

    if [[ ! -f "$path" ]]; then
        log_error "$description is missing: $path"
        FAILURES=$((FAILURES + 1))
        return 0
    fi
    if ! grep -q -- "$key" "$path"; then
        log_error "$description does not enable the cooldown (no '$key'): $path"
        FAILURES=$((FAILURES + 1))
    fi
}

# The manifest rel_src is matched as an escaped regex after the "file" kind column.
check_manifest_copy() {
    local rel_src="$1" pattern="$2"

    if ! grep -Eq "^file[[:space:]]+${pattern}[[:space:]]" "$MANIFEST_FILE"; then
        log_error "config/dotfiles.manifest does not copy $rel_src"
        FAILURES=$((FAILURES + 1))
    fi
}

DOTFILES_DIR="$PROJECT_ROOT/src/dotfiles"
MANIFEST_FILE="$SCRIPT_DIR/config/dotfiles.manifest"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Sources in the pinned src/dotfiles submodule.
check_cooldown_file "npm cooldown config in src/dotfiles" "$DOTFILES_DIR/home/.npmrc" "min-release-age"
check_cooldown_file "cargo cooldown config in src/dotfiles" "$DOTFILES_DIR/home/.cargo/config.toml" "global-min-publish-age"
check_cooldown_file "pip cooldown config in src/dotfiles" "$DOTFILES_DIR/config/pip/pip.conf" "uploaded-prior-to"
check_cooldown_file "uv cooldown config in src/dotfiles" "$DOTFILES_DIR/config/uv/uv.toml" "exclude-newer"

# Manifest entries so fresh installs provision the home-file copies.
check_manifest_copy "home/.npmrc" "home/\.npmrc"
check_manifest_copy "home/.cargo/config.toml" "home/\.cargo/config\.toml"

# Provisioned copies. ~/.cargo must be a real directory (rustup owns
# ~/.cargo/bin, env, and the registry) — only config.toml is copied per file.
if [[ -L "$HOME/.cargo" ]]; then
    log_error "$HOME/.cargo is a symlink; rustup owns its bin, env, and registry — provision config.toml per file"
    FAILURES=$((FAILURES + 1))
fi
check_cooldown_file "npm cooldown config (~/.npmrc)" "$HOME/.npmrc" "min-release-age"
check_cooldown_file "cargo cooldown config (~/.cargo/config.toml)" "$HOME/.cargo/config.toml" "global-min-publish-age"
check_cooldown_file "pip cooldown config (~/.config/pip/pip.conf)" "$XDG_CONFIG_HOME/pip/pip.conf" "uploaded-prior-to"
check_cooldown_file "uv cooldown config (~/.config/uv/uv.toml)" "$XDG_CONFIG_HOME/uv/uv.toml" "exclude-newer"

if [[ "$FAILURES" -gt 0 ]]; then
    log_error "Package supply-chain cooldown validation failed ($FAILURES check(s))"
    exit 1
fi
