#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

brew install jandedobbeleer/oh-my-posh/oh-my-posh 2>>"$ERROR_LOG_FILE" || true
brew install ghostty zsh tmux zsh-autosuggestions zsh-syntax-highlighting 2>>"$ERROR_LOG_FILE" || true
brew install --cask font-awesome-terminal-fonts font-fira-code font-meslo-lg-nerd-font font-powerline-symbols font-symbols-only-nerd-font 2>>"$ERROR_LOG_FILE" || true
