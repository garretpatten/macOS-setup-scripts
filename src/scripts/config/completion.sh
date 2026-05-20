#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

APPLE_ART="$PROJECT_ROOT/src/assets/apple.txt"
if [[ -f "$APPLE_ART" ]]; then
    echo
    printf '  %s\n' \
        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf '  %s\n' "macOS setup run complete."
    printf '  %s\n' \
        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    cat "$APPLE_ART"
    echo
    printf '  %s\n' \
        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf '  %s\n' "What to do next"
    printf '  %s\n' \
        " • Open a new Terminal window or tab so your login shell picks up PATH and tooling."
    printf '  %s\n' " • If anything looked off, inspect the error log (last 80 lines):"
    error_log_tail_cmd="$(printf 'tail -n 80 %q' "$ERROR_LOG_FILE")"
    printf '     %s\n' "${error_log_tail_cmd}"
    printf '  %s\n' " • Full docs: https://github.com/garretpatten/macOS-setup-scripts#readme"
    printf '  %s\n' \
        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
fi
