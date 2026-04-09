#!/bin/bash

source "$(dirname "$0")/utils.sh"

brew install node python@3.12 colima docker docker-compose gh neovim podman semgrep shellcheck tree-sitter angular-cli 2>>"$ERROR_LOG_FILE" || true
brew install --cask postman visual-studio-code 2>>"$ERROR_LOG_FILE" || true
brew install sourcegraph/app/sourcegraph 2>>"$ERROR_LOG_FILE" || true
brew install src-cli 2>>"$ERROR_LOG_FILE" || true

curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash 2>>"$ERROR_LOG_FILE" || true

# Neovim config lives under dotfiles config/nvim; lazy.nvim is bootstrapped from init.lua (see organizeHome.sh).

if [[ ! -f "$HOME/Library/Application Support/Code/User/settings.json" ]] && [[ -f "$PROJECT_ROOT/src/dotfiles/vs-code/settings.json" ]]; then
    copy_file_safe "$PROJECT_ROOT/src/dotfiles/vs-code/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
fi

git config --global credential.helper store 2>>"$ERROR_LOG_FILE" || true
git config --global http.postBuffer 157286400 2>>"$ERROR_LOG_FILE" || true
git config --global pack.window 1 2>>"$ERROR_LOG_FILE" || true
git config --global user.email 'garret.patten@proton.me' 2>>"$ERROR_LOG_FILE" || true
git config --global user.name 'Garret Patten' 2>>"$ERROR_LOG_FILE" || true
git config --global pull.rebase false 2>>"$ERROR_LOG_FILE" || true

colima start 2>>"$ERROR_LOG_FILE" || true
