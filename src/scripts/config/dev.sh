#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

DOTFILES_ROOT="$PROJECT_ROOT/src/dotfiles"

if [[ -d "$DOTFILES_ROOT/config" ]]; then
    copy_directory_safe "$DOTFILES_ROOT/config/nvim" "$HOME/.config/nvim"
    copy_directory_safe "$DOTFILES_ROOT/config/fastfetch" "$HOME/.config/fastfetch"
    copy_directory_safe "$DOTFILES_ROOT/config/btop" "$HOME/.config/btop"
    copy_directory_safe "$DOTFILES_ROOT/config/alacritty" "$HOME/.config/alacritty"
    copy_directory_safe "$DOTFILES_ROOT/config/kitty" "$HOME/.config/kitty"
    copy_directory_safe "$DOTFILES_ROOT/config/zellij" "$HOME/.config/zellij"
fi

if [[ -d "$DOTFILES_ROOT/home" ]]; then
    copy_file_safe "$DOTFILES_ROOT/home/.vimrc" "$HOME/.vimrc"
fi

if [[ ! -f "$HOME/Library/Application Support/Code/User/settings.json" ]] && [[ -f "$DOTFILES_ROOT/vs-code/settings.json" ]]; then
    copy_file_safe "$DOTFILES_ROOT/vs-code/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
fi

git config --global credential.helper store 2>>"$ERROR_LOG_FILE" || true
git config --global http.postBuffer 157286400 2>>"$ERROR_LOG_FILE" || true
git config --global pack.window 1 2>>"$ERROR_LOG_FILE" || true
git config --global user.email 'garret.patten@proton.me' 2>>"$ERROR_LOG_FILE" || true
git config --global user.name 'Garret Patten' 2>>"$ERROR_LOG_FILE" || true
git config --global pull.rebase false 2>>"$ERROR_LOG_FILE" || true

colima start 2>>"$ERROR_LOG_FILE" || true
