#!/bin/bash

# Update ~/.vimrc
if [[ ! -f "$HOME/.vimrc" ]]; then
    cp "$(pwd)/src/dotfiles/vim/.vimrc" "$HOME/.vimrc"
fi

# Neovim setup
if [[ ! -d "$HOME/.config/nvim/" ]]; then
    mkdir -p "$HOME/.config/"
    cp -r "$(pwd)/src/dotfiles/nvim/" "$HOME/.config/nvim/"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    brew install tree-sitter
fi

