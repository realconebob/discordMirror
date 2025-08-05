#!/usr/bin/env -S bash

# === updateFeeds.bash ===
# Originally designed to update rss feeds, now updates deb files. Downloads the latest discord.deb file 
# and updates the trivial repo in /debs/


# Update feeds
GRABFEEDS_LOC="./scripts/grabFeeds.bash"
DEBUPDATE_LOC="./scripts/debUpdate.bash"

SOMEWHAT_REALDIR="$(realpath "$0")"
FILENAME="${SOMEWHAT_REALDIR##*/}"
PATHTO="${SOMEWHAT_REALDIR/$FILENAME/}"

function runInLocal() {
    if [[ "$(pwd)/" != "$PATHTO" ]]; then
        (cd "$PATHTO" && bash "$FILENAME")
        exit $?
    fi

    return 0
}

function asNobody() {
    if [[ "$(whoami)" != "root" ]]; then
        sudo -u nobody /usr/bin/env -S bash "$FILENAME"
        exit $?
    fi

    return 0;
}

# Grab feeds & generate index
runInLocal && \
    asNobody && \
    bash "$GRABFEEDS_LOC" && \
    bash "$DEBUPDATE_LOC";
exit $?