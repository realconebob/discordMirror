#!/usr/bin/env bash
LOC_WGETRC="./wgetrc"

grabRSS() {
    # Check if there's a system install of wget, use the bundled version if not
    if [ -x /usr/bin/wget ]; then
        loc_wget="/usr/bin/wget"    
    else
        echo "No system install of wget found. Please install wget"
        exit 1
    fi

    wget="$loc_wget --config $LOC_WGETRC $2 $1"
    echo "${wget}" && $wget && return 0

    return 1
}

if (( $# == 1 )); then
    url=$1
    grabRSS $url

elif (( $# > 1 )); then
    eval "url=\$$(($#))"

    extrasettings=""
    for ((i=1;i<$#;i++)); do
        eval "extrasettings+=\ \$$i"
    done

    grabRSS $url "$extrasettings"

else
    echo "Please enter the url to an RSS feed"
    exit 1
fi
