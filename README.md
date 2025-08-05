# Discord Mirror

## Because Discord, a multi-BILLION (with a B!) dollar comapny, is INCAPABLE of running their own repository

Discord Mirror is built on top of a rss mirror, and retooled to "use" the Discord API to grab the lastest linux deb file occasionally (checks daily). If a new file is found, it is downloaded and made available in a local deb file repository for "download" and use with apt. No update hook is planned for now, just a daily check using cron

### DEPENDENCIES

- env: Makes sure that things passed to bash are done so in a sane manner
- bash: All the scripts are written for the bash shell
- wget: Grabs the current discord.deb file
- dpkg-dev: Supplies scripts used to generate Release and Packages.gz files
- cron: Periodically checks for new .deb files

### SECURITY

This script creates a folder (`/opt/discordMirror/debs/`) which is unconditionally trusted by apt. The root folder (`/opt/discordMirror`) is owned by the user "`nobody`", which has no permissions and can't be edited by anyone without root permissions. If someone were to get access to the nobody user, and then insert a url to a malicious deb package in the urls file in the discordMirror folder, they could potentially mimick another package and trick you into installing it. This is possible as some programs such as webservers run with the nobody user, however the average desktop linux user likely won't be vulnerable. Getting access to the nobody user is not as useful as getting access to an actual user, and it's definitely nowhere near as bad as getting root, but it could still be a hazard

### INSTALLING

```bash
git clone https://github.com/StrangestMan/discordMirror.git
cd discordMirror
sudo ./install.bash
sudo apt update && sudo apt install discord
```

Running `install.bash` as root clones this directory into `/opt/` and installs a .list file into `/etc/apt/sources.list.d/` so that apt can recognize the trivial repo, and adds an cron tab to check for new deb files. Once installed, everything should run in the background without the need to intervene.

### USAGE

```bash
# Note: This is optional, it is likely that you will never have to run these scripts
cd /opt/discordMirror
./updateFeeds.bash
./debUpdate.bash
```

`updateFeeds.bash` fetches the .deb file from Discord and places it in the '`debs`' folder, while `debUpdate.bash` creates a '`Release`' and '`Packages.gz`' file for apt. If an update fails for any reason, running these commands may provide insight as to why

None of the scripts in this project ever run apt. It simply provides the deb files for apt to use. It is on the user to update their package archive and install any new packages when they release
