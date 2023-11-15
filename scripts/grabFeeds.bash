#!/usr/bin/env bash

# Read a file, then recursively run the wget wrapper to fetch feeds
urlfile="./urls"
WRAPPER_LOC="./scripts/wgetWrapper.bash"
retstat=0

while IFS='' read -r line || [[ -n "${line}" ]]; do
    if [[ "${line}" == \#* ]] || [ -z "${line}" ]; then
        continue
    fi
    
    $WRAPPER_LOC $line
    if (( $? != 0 )); then
        retstat=1
    fi

done < $urlfile

exit $retstat