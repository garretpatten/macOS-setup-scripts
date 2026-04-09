#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
DOTFILES_ROOT="${PROJECT_ROOT}/src/dotfiles"
ERROR_LOG_FILE="${PROJECT_ROOT}/setup_errors.log"

mkdir -p "$(dirname "$ERROR_LOG_FILE")"

log_error() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "\033[0;31m[ERROR]\033[0m $message" >&2
    echo "[$timestamp] [ERROR] $message" >> "$ERROR_LOG_FILE"
}

ensure_directory() {
    local dir="$1"
    mkdir -p "$dir" 2>>"$ERROR_LOG_FILE" || true
}

copy_file_safe() {
    local source="$1"
    local destination="$2"

    if [[ ! -f "$source" ]] || [[ -f "$destination" ]]; then
        return 0
    fi

    local dest_dir=$(dirname "$destination")
    ensure_directory "$dest_dir"

    cp "$source" "$destination" 2>>"$ERROR_LOG_FILE" || true
}

copy_directory_safe() {
    local source="$1"
    local destination="$2"

    if [[ ! -d "$source" ]] || [[ -d "$destination" ]]; then
        return 0
    fi

    local dest_dir=$(dirname "$destination")
    ensure_directory "$dest_dir"

    cp -r "$source" "$destination" 2>>"$ERROR_LOG_FILE" || true
}

# Nested git submodules inside the dotfiles repo (e.g. taskwarrior themes).
run_dotfiles_setup() {
    local setup="$DOTFILES_ROOT/setup.sh"
    if [[ -f "$setup" ]]; then
        bash "$setup" 2>>"$ERROR_LOG_FILE" || true
    fi
}

# Copy each top-level directory from dotfiles config/ into XDG config (only if missing).
sync_dotfiles_config_tree() {
    local cfg="$DOTFILES_ROOT/config"
    if [[ ! -d "$cfg" ]]; then
        return 0
    fi
    local xdg="${XDG_CONFIG_HOME:-$HOME/.config}"
    ensure_directory "$xdg"
    local d name
    for d in "$cfg"/*; do
        [[ -d "$d" ]] || continue
        name=$(basename "$d")
        copy_directory_safe "$d" "$xdg/$name"
    done
}

# Home-directory dotfiles (new layout: home/ at repo root).
sync_dotfiles_home_files() {
    local h="$DOTFILES_ROOT/home"
    if [[ ! -d "$h" ]]; then
        return 0
    fi
    copy_file_safe "$h/.zshrc" "$HOME/.zshrc"
    copy_file_safe "$h/.tmux.conf" "$HOME/.tmux.conf"
    copy_file_safe "$h/.vimrc" "$HOME/.vimrc"
    copy_file_safe "$h/.bashrc" "$HOME/.bashrc"
    # Let shell startup resolve DOTFILES without scanning; path matches this submodule checkout.
    if [[ -f "$h/.zshrc" ]] && [[ ! -f "$HOME/.dotfiles_path" ]]; then
        printf '%s\n' "$DOTFILES_ROOT" >"$HOME/.dotfiles_path" 2>>"$ERROR_LOG_FILE" || true
    fi
}

download_file_safe() {
    local url="$1"
    local destination="$2"

    curl -sSL --connect-timeout 30 --max-time 300 --fail --show-error "$url" -o "$destination" || {
        log_error "Failed to download $url"
        rm -f "$destination" 2>/dev/null || true
        return 1
    }

    if [[ ! -f "$destination" ]] || [[ ! -s "$destination" ]]; then
        log_error "Downloaded file is empty or missing: $destination"
        rm -f "$destination" 2>/dev/null || true
        return 1
    fi
}

export SCRIPT_DIR PROJECT_ROOT DOTFILES_ROOT ERROR_LOG_FILE
export -f log_error ensure_directory copy_file_safe copy_directory_safe run_dotfiles_setup \
    sync_dotfiles_config_tree sync_dotfiles_home_files download_file_safe

