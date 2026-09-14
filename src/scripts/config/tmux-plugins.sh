#!/bin/bash

tpm_dir="${HOME}/.tmux/plugins/tpm"
plugins_dir="${HOME}/.tmux/plugins"
conf="${HOME}/.config/tmux/tmux.conf"

if ! command -v git >/dev/null 2>&1; then
    log_error "git unavailable; skipping tmux plugin install"
    exit 0
fi

if [[ ! -f "$conf" ]]; then
    log_error "tmux.conf not found at $conf; skipping tmux plugin install"
    exit 0
fi

ensure_directory "$plugins_dir"
if [[ ! -x "$tpm_dir/tpm" ]]; then
    GIT_TERMINAL_PROMPT=0 git clone --depth=1 https://github.com/tmux-plugins/tpm "$tpm_dir" 2>>"$ERROR_LOG_FILE" || true
fi
if [[ ! -x "$tpm_dir/tpm" ]]; then
    log_error "failed to clone tpm to $tpm_dir"
    exit 0
fi

clone_plugin() {
    local plugin="$1"
    local name="${plugin%%#*}"
    local dest="${plugins_dir}/${name##*/}"
    echo "Installing \"$name\""
    if [[ -d "$dest" ]]; then
        echo "  \"$name\" already installed"
        return 0
    fi
    GIT_TERMINAL_PROMPT=0 git clone --depth=1 --single-branch "https://github.com/${name}" "$dest" 2>>"$ERROR_LOG_FILE"
    if [[ -d "$dest" ]]; then
        echo "  \"$name\" download success"
    else
        log_error "\"$name\" download fail"
    fi
}

while IFS= read -r plugin; do
    [[ -n "$plugin" ]] || continue
    clone_plugin "$plugin"
done < <(sed -n "s/^set -g @plugin '\([^']*\)'.*/\1/p" "$conf")
