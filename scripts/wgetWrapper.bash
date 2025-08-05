#!/usr/bin/env -S bash

# === wgetWrapper.bash ===
# Simple wrapper to make using wget in other files easier

LOC_WGETBIN="/usr/bin/wget"
LOC_WGETRC="./wgetrc"

function grabRSS() {
    # Check if there's a system install of wget
    if [ -x "$LOC_WGETBIN" ]; then
        loc_wget="$LOC_WGETBIN"
    else
        echo "No system install of wget found. Please install wget"
        return 1
    fi

    wget="$loc_wget --config $LOC_WGETRC $2 $1"
    echo "${wget}" && $wget
    
    return $?
}

# TODO: Figure out if this is actually necessary
function doOpts() {
    if (( $# == 1 )); then
        url="$1"
        grabRSS "$url"
        return $?

    elif (( $# > 1 )); then
        eval "url=\$$(($#))"

        extrasettings=""
        for ((i=1;i<$#;i++)); do
            eval "extrasettings+=\ \$$i"
        done

        grabRSS "$url" "$extrasettings"
        return $?

    else
        echo "Please enter the url to an RSS feed"
    
    fi

    return 1
}

doOpts "$@"