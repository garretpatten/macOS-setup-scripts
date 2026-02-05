#!/bin/bash

source "$(dirname "$0")/utils.sh"

brew install node python@3.12 colima docker docker-compose gh neovim podman semgrep shellcheck tree-sitter angular-cli 2>>"$ERROR_LOG_FILE" || true
brew install --cask postman visual-studio-code 2>>"$ERROR_LOG_FILE" || true
brew install sourcegraph/app/sourcegraph 2>>"$ERROR_LOG_FILE" || true
brew install src-cli 2>>"$ERROR_LOG_FILE" || true

curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash 2>>"$ERROR_LOG_FILE" || true

if [[ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
    git clone https://github.com/wbthomason/packer.nvim "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" 2>>"$ERROR_LOG_FILE" || true
fi

if [[ ! -d "$HOME/.config/nvim" ]] && [[ -d "$PROJECT_ROOT/src/dotfiles/nvim" ]]; then
    mkdir -p "$HOME/.config" 2>>"$ERROR_LOG_FILE" || true
    cp -r "$PROJECT_ROOT/src/dotfiles/nvim" "$HOME/.config/nvim" 2>>"$ERROR_LOG_FILE" || true
fi

if [[ ! -f "$HOME/.vimrc" ]] && [[ -f "$PROJECT_ROOT/src/dotfiles/vim/.vimrc" ]]; then
    copy_file_safe "$PROJECT_ROOT/src/dotfiles/vim/.vimrc" "$HOME/.vimrc"
fi

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
