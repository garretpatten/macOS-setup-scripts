#!/bin/bash

# Runs after config/shell.sh so ~/.zshrc from dotfiles is in place before appending PATH.
# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Literal `$PATH` for ~/.zshrc (expand when the shell reads the file, not here).
# shellcheck disable=SC2016
path_line='export PATH="/Users/garret/.local/bin:$PATH"'
if [[ -f "$HOME/.zshrc" ]] && ! grep -qF "$path_line" "$HOME/.zshrc" 2>/dev/null; then
    echo "$path_line" >>"$HOME/.zshrc" 2>>"$ERROR_LOG_FILE" || true
fi
