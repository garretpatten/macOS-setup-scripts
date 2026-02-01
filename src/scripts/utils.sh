#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
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

export SCRIPT_DIR PROJECT_ROOT ERROR_LOG_FILE
export -f log_error ensure_directory copy_file_safe copy_directory_safe download_file_safe

