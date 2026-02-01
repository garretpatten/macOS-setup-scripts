#!/bin/bash

source "$(dirname "$0")/utils.sh"

brew install jandedobbeleer/oh-my-posh/oh-my-posh 2>>"$ERROR_LOG_FILE" || true
brew install ghostty zsh tmux zsh-autosuggestions zsh-syntax-highlighting 2>>"$ERROR_LOG_FILE" || true
brew install --cask font-awesome-terminal-fonts font-fira-code font-meslo-lg-nerd-font font-powerline-symbols 2>>"$ERROR_LOG_FILE" || true

if [[ ! -f "$HOME/.config/ghostty/config" ]] && [[ -f "$PROJECT_ROOT/src/dotfiles/ghostty/config" ]]; then
    copy_file_safe "$PROJECT_ROOT/src/dotfiles/ghostty/config" "$HOME/.config/ghostty/config"
fi

if [[ ! -f "$HOME/.tmux.conf" ]] && [[ -f "$PROJECT_ROOT/src/dotfiles/tmux/.tmux.conf" ]]; then
    copy_file_safe "$PROJECT_ROOT/src/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

if [[ ! -f "$HOME/.zshrc" ]] && [[ -f "$PROJECT_ROOT/src/dotfiles/oh-my-posh/.zshrc" ]]; then
    copy_file_safe "$PROJECT_ROOT/src/dotfiles/oh-my-posh/.zshrc" "$HOME/.zshrc"
fi

chsh -s "$(command -v zsh)" 2>>"$ERROR_LOG_FILE" || true
sudo chsh -s "$(command -v zsh)" 2>>"$ERROR_LOG_FILE" || true
