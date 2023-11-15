#!/bin/bash

# === install.bash ===
# Installs discordMirror into /opt/, creates a crontab to update the file, and creates a .list so apt can 
# install the deb. This script should be run only once, and as root.

PATHTO_FOLDER="$(pwd)"
OPT_LOC="/opt/discordMirror"

checkRoot() {
    if [[ "$(whoami)" != "root" ]]; then
                echo "This script must be run as root"

                location="$(realpath $0)"
                sudo su root -c "bash $location"
                exit $?
        fi

    echo "Installing..."

    return 0
}

install() {
    # Move folder to /opt/ and make it owned by "nobody", a generic unprivileged user
    cp -rvf "$PATHTO_FOLDER" "$OPT_LOC" && \
        chown -R nobody:nogroup "$OPT_LOC" && \

        # Install a .list file into /etc/apt/sources.list.d/
        echo "deb [trusted=yes] file:/opt/discordMirror/debs ./" | tee "/etc/apt/sources.list.d/discordMirror.list" && \

        # Install a crontab for the nobody user to occasionally fetch packages
        (crontab -u nobody -l 2>/dev/null; echo "0 */3 * * * bash /opt/discordMirror/cron/cronUpdate.bash") | crontab -u nobody - && \

        echo "Installed!"
        
}

checkRoot && \
    install