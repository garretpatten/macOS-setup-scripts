#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

chsh -s "$(command -v zsh)" 2>>"$ERROR_LOG_FILE" || true
sudo chsh -s "$(command -v zsh)" 2>>"$ERROR_LOG_FILE" || true
