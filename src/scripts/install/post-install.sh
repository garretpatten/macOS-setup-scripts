#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

brew update 2>>"$ERROR_LOG_FILE" || true
brew upgrade 2>>"$ERROR_LOG_FILE" || true
brew cleanup 2>>"$ERROR_LOG_FILE" || true
