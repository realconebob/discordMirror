#!/usr/bin/env -S bash

# === debUpdate.bash ===
# Update the debian package archive for the local debs folder

DEBS_LOC="../debs/"

SOMEWHAT_REALDIR="$(realpath "$0")"
FILENAME="${SOMEWHAT_REALDIR##*/}"
PATHTO="${SOMEWHAT_REALDIR/$FILENAME/}"

function runInLocal() {    
    if [[ "$(pwd)/" != "$PATHTO" ]]; then
        (cd "$PATHTO" && bash "$FILENAME")
        return $?
    fi

    return 0
}

debUpdate() {
    cd "$DEBS_LOC" && \
        dpkg-scanpackages . > "Release" && \
        dpkg-scanpackages . | gzip -9c > "Packages.gz"

    return $?
}

runInLocal && \
    debUpdate