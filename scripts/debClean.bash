#!/usr/bin/env -S bash

# === debClean.bash ===
# Clean out the debian package archive

DEBS_LOC="../debs/"

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

debClean() {
    #cd "$DEBS_LOC" && \
    #    dpkg-scanpackages -m . > "Release" && \
    #    dpkg-scanpackages -m . | gzip -9c > "Packages.gz"

    cd "$DEBS_LOC" && \
        readarray -t ENTRIES <<< "$(ls | sort -)"
    NUM_ENTRIES=(${#ENTRIES[@]})

    if (( $NUM_ENTRIES > 7 )); then
	echo "DiscordMirror: Cleaning old deb entries"
        for (( i=0; i < $NUM_ENTRIES - 7; i++ )) do
            rm -v ${ENTRIES[i]}
        done
    fi

    return $?
}

runInLocal "$@" && \
    debClean "$@"
