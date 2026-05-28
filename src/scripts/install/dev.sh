#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

brew install node python@3.12 ruby go colima docker docker-compose gh neovim podman \
  semgrep shellcheck tree-sitter tree-sitter-cli angular-cli \
  2>>"$ERROR_LOG_FILE" || true
brew install --cask postman visual-studio-code 2>>"$ERROR_LOG_FILE" || true
brew install sourcegraph/app/sourcegraph 2>>"$ERROR_LOG_FILE" || true
brew install src-cli 2>>"$ERROR_LOG_FILE" || true

curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash 2>>"$ERROR_LOG_FILE" || true

if [[ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
    git clone https://github.com/wbthomason/packer.nvim "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" 2>>"$ERROR_LOG_FILE" || true
fi
