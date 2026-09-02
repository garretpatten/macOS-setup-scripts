#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

bash "$(dirname "$0")/dotfiles.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute config/dotfiles.sh"

# Shared Git pre-commit hook (symlinked by dotfiles.sh)
if ! git config --global core.hooksPath >/dev/null 2>&1; then
    git config --global core.hooksPath "$HOME/.config/githooks" 2>>"$ERROR_LOG_FILE" || true
fi

if [[ ! -f "$HOME/.gitconfig" ]]; then
    git config --global credential.helper store 2>>"$ERROR_LOG_FILE" || true
    git config --global http.postBuffer 157286400 2>>"$ERROR_LOG_FILE" || true
    git config --global pack.window 1 2>>"$ERROR_LOG_FILE" || true
    git config --global user.email 'garret.patten@proton.me' 2>>"$ERROR_LOG_FILE" || true
    git config --global user.name 'Garret Patten' 2>>"$ERROR_LOG_FILE" || true
    git config --global pull.rebase false 2>>"$ERROR_LOG_FILE" || true
    git config --global init.defaultBranch main 2>>"$ERROR_LOG_FILE" || true
fi

colima start 2>>"$ERROR_LOG_FILE" || true
