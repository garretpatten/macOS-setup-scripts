#!/bin/bash

source "$(dirname "$0")/utils.sh"

if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only. Current OS: $OSTYPE"
    exit 1
fi

bash "$(dirname "$0")/pre-install.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute pre-install.sh"
bash "$(dirname "$0")/organizeHome.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute organizeHome.sh"
bash "$(dirname "$0")/cli.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute cli.sh"
bash "$(dirname "$0")/media.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute media.sh"
bash "$(dirname "$0")/productivity.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute productivity.sh"
bash "$(dirname "$0")/dev.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute dev.sh"
bash "$(dirname "$0")/security.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute security.sh"
zsh "$(dirname "$0")/shell.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute shell.sh"
bash "$(dirname "$0")/post-install.sh" 2>>"$ERROR_LOG_FILE" || log_error "Failed to execute post-install.sh"
