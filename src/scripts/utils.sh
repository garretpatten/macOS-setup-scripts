#!/bin/bash

is_installed() {
    local application="$1"
    [[ command -v "$application" ]] && return 0 || return 1
}

ERROR_FILE="errors.log"
