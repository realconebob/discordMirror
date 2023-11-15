#!/bin/bash

# === debUpdate.bash ===
# Update the debian package archive for the local debs folder

DEBS_LOC="../debs/"

debUpdate() {
    # This is a shitty, hacky solution, but IDC
    SOMEWHAT_REALDIR="$(realpath $0)"
    FILENAME="${SOMEWHAT_REALDIR##*/}"
    PATHTO="${SOMEWHAT_REALDIR/$FILENAME/}"
    if [[ "$(pwd)/" != "$PATHTO" ]]; then
            (cd $PATHTO && bash $FILENAME)
            exit $?
    fi

    cd $DEBS_LOC

    dpkg-scanpackages . > "Release" && \
        dpkg-scanpackages . | gzip -9c > "Packages.gz"
}

debUpdate