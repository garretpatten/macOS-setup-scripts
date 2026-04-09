#!/bin/bash

source "$(dirname "$0")/utils.sh"

run_dotfiles_setup
sync_dotfiles_config_tree
sync_dotfiles_home_files

[[ -d "$HOME/Templates" ]] && rmdir "$HOME/Templates" 2>>"$ERROR_LOG_FILE" || true
mkdir -p "$HOME/Books" "$HOME/Games" "$HOME/Hacking" "$HOME/Projects" 2>>"$ERROR_LOG_FILE" || true
