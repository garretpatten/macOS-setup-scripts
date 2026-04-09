#!/bin/bash

source "$(dirname "$0")/utils.sh"

brew install jandedobbeleer/oh-my-posh/oh-my-posh 2>>"$ERROR_LOG_FILE" || true
brew install ghostty zsh tmux zsh-autosuggestions zsh-syntax-highlighting 2>>"$ERROR_LOG_FILE" || true
brew install --cask font-awesome-terminal-fonts font-fira-code font-meslo-lg-nerd-font font-powerline-symbols 2>>"$ERROR_LOG_FILE" || true

# Ghostty, tmux, zsh, and XDG app configs are synced from src/dotfiles (config/, home/) in organizeHome.sh.

chsh -s "$(command -v zsh)" 2>>"$ERROR_LOG_FILE" || true
sudo chsh -s "$(command -v zsh)" 2>>"$ERROR_LOG_FILE" || true
