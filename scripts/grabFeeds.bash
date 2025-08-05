#!/usr/bin/env -S bash

# === grabFeeds.bash ===
# Run wget on each line of the urls file

# Read a file, then recursively run the wget wrapper to fetch feeds
URLFILE="./urls"
WRAPPER_LOC="./scripts/wgetWrapper.bash"

function callWrapper() {
    retstat=0

    while IFS='' read -r line || [[ -n "${line}" ]]; do
        if [[ "${line}" == \#* ]] || [ -z "${line}" ]; then
            continue
        fi
        
        if ! $WRAPPER_LOC "$line"; then
            retstat=1
        fi

    done < $URLFILE
    return $((retstat))
}

callWrapper
exit $?