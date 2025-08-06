#!/usr/bin/env -S bash

# === cronUpdate.bash ===
# Small script that cron will run. This is done because cron assumes the system its running on is always online, which is not always
# true for PCs and laptops. cronUpdate.bash can be ran any number of times in a day, but will only update once daily, assuming no
# one is manually messing with the timestamp file

TIMESTAMP_NAME="update.timestamp"
CHECKTIME="$((60*24))"
FINDSTAMP="find . -maxdepth 1 -iname $TIMESTAMP_NAME -mmin +$((CHECKTIME))"
UPDATEFEEDS_LOC="../updateFeeds.bash"


SOMEWHAT_REALDIR="$(realpath "$0")"
FILENAME="${SOMEWHAT_REALDIR##*/}"
PATHTO="${SOMEWHAT_REALDIR/$FILENAME/}"

function runInLocal() {
    if [[ "$(pwd)/" != "$PATHTO" ]]; then
        (cd "$PATHTO" && bash "$FILENAME" "$@")
        exit $?
    fi

    return 0
}

function asNobody() {
    if [[ "$(whoami)" != "nobody" ]]; then
        sudo -u nobody /usr/bin/env -S bash "$FILENAME" "$@"
        exit $?
    fi

    return 0;
}

# Check to see if there's an old timestamp, any timestamp, or if the user is forcing an update
function checkTimestamp() {
    if [ -n "$($FINDSTAMP)" ] || [ ! -f $TIMESTAMP_NAME ] || [[ "$1" =~ -[fF] ]]; then
        TSCONTENTS="Discord deb check STATUS on: $(date +'%A, %b %d (%D) @ %T')"
        retval=0

        if ! $UPDATEFEEDS_LOC; then
            TSCONTENTS="${TSCONTENTS/STATUS/FAILURE}"
            retval=1
        else
            TSCONTENTS="${TSCONTENTS/STATUS/SUCCESS}"
        fi

        echo "$TSCONTENTS" | tee -a $TIMESTAMP_NAME
    fi

    return $((retval))
}

runInLocal "$@" && \
    asNobody "$@" && \
    checkTimestamp "$@"