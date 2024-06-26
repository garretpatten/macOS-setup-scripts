#!/bin/bash

cliTools=("bat" "curl" "exa" "exiftool" "eza" "fastfetch" "fd" "git" "htop" "jq" "neovim" "openvpn" "ripgrep" "tmux" "vim" "wget" "zsh")
for tool in ${cliTools[@]}; do
    if [[ ! -d "/usr/local/cellar/$tool/" ]]; then
        brew install "$tool"
    fi
done
