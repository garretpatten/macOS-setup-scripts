#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

brew install bat btop curl eza fastfetch fd git htop jq ripgrep vim wget 2>>"$ERROR_LOG_FILE" || true
