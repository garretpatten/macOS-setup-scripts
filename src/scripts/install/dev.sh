#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

brew install node python@3.12 ruby go colima docker docker-compose gh neovim podman \
  semgrep shellcheck tree-sitter tree-sitter-cli angular-cli \
  bash-language-server lua-language-server pyright typescript-language-server yaml-language-server \
  php composer lua luarocks openjdk julia containerd lazydocker \
  2>>"$ERROR_LOG_FILE" || true
brew install --cask ollama postman visual-studio-code 2>>"$ERROR_LOG_FILE" || true
brew install sourcegraph/app/sourcegraph 2>>"$ERROR_LOG_FILE" || true
brew install src-cli 2>>"$ERROR_LOG_FILE" || true

if [[ ! -e /Library/Java/JavaVirtualMachines/openjdk.jdk ]]; then
    sudo ln -sfn "$(brew --prefix openjdk)/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk 2>>"$ERROR_LOG_FILE" || true
fi

curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash 2>>"$ERROR_LOG_FILE" || true

npm install -g @vue/cli 2>>"$ERROR_LOG_FILE" || true

if [[ ! -f "$HOME/.cargo/env" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 2>>"$ERROR_LOG_FILE" || true
fi

if ! command -v cursor >/dev/null 2>&1; then
    curl -fsSL https://cursor.com/install | bash 2>>"$ERROR_LOG_FILE" || true
fi

if command -v gem >/dev/null 2>&1; then
    gem install --user-install solargraph 2>>"$ERROR_LOG_FILE" || true
fi

if [[ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
    git clone https://github.com/wbthomason/packer.nvim "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" 2>>"$ERROR_LOG_FILE" || true
fi
