#!/bin/bash

# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"

brew install jandedobbeleer/oh-my-posh/oh-my-posh 2>>"$ERROR_LOG_FILE" || true
brew install ghostty zsh tmux zsh-autosuggestions zsh-syntax-highlighting 2>>"$ERROR_LOG_FILE" || true
brew install --cask font-awesome-terminal-fonts font-fira-code font-meslo-lg-nerd-font font-powerline-symbols 2>>"$ERROR_LOG_FILE" || true

DOTFILES_ROOT="$PROJECT_ROOT/src/dotfiles"

if [[ -d "$DOTFILES_ROOT/config" ]]; then
    copy_directory_safe "$DOTFILES_ROOT/config/ghostty" "$HOME/.config/ghostty"
    copy_directory_safe "$DOTFILES_ROOT/config/oh-my-posh" "$HOME/.config/oh-my-posh"
    # home/.tmux.conf sources ~/.config/tmux/includes/base.conf (modular layout; see dotfiles README).
    copy_directory_safe "$DOTFILES_ROOT/config/tmux" "$HOME/.config/tmux"
fi

if [[ -d "$DOTFILES_ROOT/home" ]]; then
    copy_file_safe "$DOTFILES_ROOT/home/.tmux.conf" "$HOME/.tmux.conf"
    copy_file_safe "$DOTFILES_ROOT/home/.zshrc" "$HOME/.zshrc"
fi

# home/.zshrc reads this cache to resolve DOTFILES and source home/zsh/<os>.zsh.
if [[ -d "$DOTFILES_ROOT/home/zsh" ]]; then
    if [[ ! -f "$HOME/.dotfiles_path" ]]; then
        printf '%s\n' "$DOTFILES_ROOT" > "$HOME/.dotfiles_path"
    else
        existing_dotfiles_root=""
        IFS= read -r existing_dotfiles_root < "$HOME/.dotfiles_path" || true
        if [[ -z "$existing_dotfiles_root" ]] || [[ ! -d "$existing_dotfiles_root/home/zsh" ]]; then
            printf '%s\n' "$DOTFILES_ROOT" > "$HOME/.dotfiles_path"
        fi
    fi
fi

chsh -s "$(command -v zsh)" 2>>"$ERROR_LOG_FILE" || true
sudo chsh -s "$(command -v zsh)" 2>>"$ERROR_LOG_FILE" || true
