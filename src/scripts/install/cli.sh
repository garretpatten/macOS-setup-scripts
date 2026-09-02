#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if ! command -v tldr >/dev/null 2>&1; then
    brew install tealdeer 2>>"$ERROR_LOG_FILE" || true
fi

brew install bat btop curl eza fastfetch fd git htop jq lazygit ripgrep vim wget \
  yazi ffmpeg-full sevenzip poppler fzf zoxide resvg imagemagick-full \
  whois make unzip gcc pkgconf gstreamer \
  2>>"$ERROR_LOG_FILE" || true
brew link ffmpeg-full imagemagick-full -f --overwrite 2>>"$ERROR_LOG_FILE" || true
