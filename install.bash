#!/usr/bin/env -S bash

# === install.bash ===
# Installs discordMirror into /opt/, creates a crontab to update the file, and creates a .list so apt can 
# install the deb. This script should be run as root

OPT_LOC="/opt/discordMirror"
ENV_LOC="/usr/bin/env"


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

function checkInstalled() {
    if [ -d "$OPT_LOC" ]; then
        echo "DiscordMirror is already installed"
        return 1
    fi

    return 0
}

function checkRoot() {
    if [[ "$(whoami)" != "root" ]]; then
        echo "This script must be ran as root"

        sudo -u root "$ENV_LOC" bash "$FILENAME"
        exit $?
    fi

    return 0
}

function install() {
    # Move folder to /opt/ and make it owned by "nobody", a generic unprivileged user
    cp -rvf "$PATHTO_FOLDER" "$OPT_LOC" && \
        chown -R nobody:nogroup "$OPT_LOC" && \

        # Install a .list file into /etc/apt/sources.list.d/
        echo "deb [trusted=yes] file:/opt/discordMirror/debs ./" | tee "/etc/apt/sources.list.d/discordMirror.list" && \

        # Install a crontab for the nobody user to occasionally fetch packages
        (crontab -u nobody -l 2>/dev/null; echo "0 */3 * * * /usr/bin/bash -S bash /opt/discordMirror/cron/cronUpdate.bash") | crontab -u nobody - && \
        echo "Installed!";

    return 0
}

runInLocal && \
    checkInstalled && \
    checkRoot && \
    install;
exit $?