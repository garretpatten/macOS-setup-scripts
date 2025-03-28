#!/bin/bash

source "$(pwd)/src/scripts/utils.sh"

cliTools=("bat" "curl" "eza" "fastfetch" "fd" "git" "htop" "jq" "ripgrep" "tmux" "vim" "wget")
for tool in "${cliTools[@]}"; do
    if ! is_installed "$tool"; then
        brew install "$tool"
    fi
done
