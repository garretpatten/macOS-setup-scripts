#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

brew install bat btop curl eza fastfetch fd git htop jq lazygit ripgrep vim wget \
  yazi ffmpeg-full sevenzip poppler fzf zoxide resvg imagemagick-full \
  2>>"$ERROR_LOG_FILE" || true
brew link ffmpeg-full imagemagick-full -f --overwrite 2>>"$ERROR_LOG_FILE" || true
