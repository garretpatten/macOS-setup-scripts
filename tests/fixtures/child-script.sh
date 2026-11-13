#!/bin/bash
# Fixture stand-in for an install/ or config/ child script.
# Appends "<dir>/<name>.sh" to $CALL_LOG and fails when that name is listed in
# the space-separated $FIXTURE_FAIL.

name="$(basename "$(dirname "$0")")/$(basename "$0")"
echo "$name" >>"${CALL_LOG:?CALL_LOG must be set}"

if [[ " ${FIXTURE_FAIL:-} " == *" $name "* ]]; then
    echo "fixture failure: $name" >&2
    exit 1
fi
