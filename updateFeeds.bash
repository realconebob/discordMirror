#!/usr/bin/env bash

# === updateFeeds.bash ===
# Originally designed to update rss feeds, now updates deb files. Downloads the latest discord.deb file 
# and updates the trivial repo in /debs/


# Update feeds
GRABFEEDS_LOC="./scripts/grabFeeds.bash"
DEBUPDATE_LOC="./scripts/debUpdate.bash"

# Move to this directory if it's not the working dir
SOMEWHAT_REALDIR="$(realpath $0)"
FILENAME="${SOMEWHAT_REALDIR##*/}"
PATHTO="${SOMEWHAT_REALDIR/$FILENAME/}"
if [[ "$(pwd)/" != "$PATHTO" ]]; then
    (cd $PATHTO && bash $FILENAME)
    exit $?
fi

# Grab feeds & generate index
bash "$GRABFEEDS_LOC" && bash "$DEBUPDATE_LOC"