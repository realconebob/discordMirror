#!/usr/bin/env bash

TIMESTAMP_NAME="update.timestamp"
CHECKTIME="$((60*24))"
FINDSTAMP="find . -maxdepth 1 -iname $TIMESTAMP_NAME -mmin +$(($CHECKTIME))"
UPDATEFEEDS_LOC="../updateFeeds.bash"

# Move to the local dir if elsewhere
SOMEWHAT_REALDIR="$(realpath $0)"
FILENAME="${SOMEWHAT_REALDIR##*/}"
PATHTO="${SOMEWHAT_REALDIR/$FILENAME/}"
if [[ "$(pwd)/" != "$PATHTO" ]]; then
    (cd $PATHTO && bash $FILENAME)
    exit $?
fi

# Check to see if there's an old timestamp, any timestamp, or if the user is forcing an update
if [ -n "$($FINDSTAMP)" ] || [ ! -f $TIMESTAMP_NAME ] || [[ "$1" =~ -[fF] ]]; then
    TSCONTENTS="Discord deb check STATUS on: $(date +'%A, %b %d (%D) @ %T')"
    
    $UPDATEFEEDS_LOC
    if [[ "$?" != "0" ]]; then
        TSCONTENTS="${TSCONTENTS/STATUS/FAILURE}"
    else
        TSCONTENTS="${TSCONTENTS/STATUS/SUCCESS}"
    fi

    echo "$TSCONTENTS" | tee $TIMESTAMP_NAME
fi