#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ELEMENTARY_XFCE=$SCRIPT_DIR/elementary-xfce
MINIOS_ICONS=$SCRIPT_DIR/minios-icons

if ! command -v git &>/dev/null; then
    echo "git could not be found"
    apt-get install -y git
fi

git submodule deinit -f elementary-xfce
git submodule update --init ./

lnsvg() {
    local FILE LINK
    FILE=$1
    LINK=$2
    if [ -f $FILE ]; then
        ln -s $FILE $LINK
    fi
}

rsync -a --include='*.svg' --include='*/' --exclude='*' $MINIOS_ICONS/ $ELEMENTARY_XFCE/

for FOLDER in $(find $ELEMENTARY_XFCE/elementary-xfce/apps -type d -regex ".*/[0-9]+$"); do
    cd $FOLDER
    if [ -f baobab.svg ]; then
        lnsvg baobab.svg org.gnome.baobab.svg
    elif [ -f org.gnome.baobab.svg ]; then
        lnsvg org.gnome.baobab.svg baobab.svg
    fi
    lnsvg accessories-calculator.svg galculator.svg
    lnsvg internet-mail.svg emblem-mail.svg
    lnsvg preferences-system-power.svg laptop-mode-tools.svg
    lnsvg pdfshuffler.svg com.github.jeromerobert.pdfarranger.svg
    lnsvg pdfshuffler.svg pdfarranger.svg
    lnsvg pdfshuffler.svg pdfmod.svg
    lnsvg utilities-terminal.png guake.png
    lnsvg libreoffice-draw.png drawio.png
    lnsvg ../../status/$(basename $FOLDER)/sync-synchronizing.svg grsync.svg
    lnsvg ../../devices/$(basename $FOLDER)/drive-harddisk.svg gsmartcontrol.svg
    lnsvg utilities-system-monitor.svg qps.svg
    lnsvg web-browser.svg falkon.svg
    lnsvg ./../actions/$(basename $FOLDER)/edit-paste.svg qlipper.svg
    lnsvg usb-receiver.svg unetbootin.svg
    lnsvg application-x-firmware.svg hardinfo.svg
    lnsvg application-x-firmware.svg lshw-gtk.svg
    lnsvg ../../devices/$(basename $FOLDER)/fingerprint.svg org.gtkhash.gtkhash.svg
    lnsvg dialog-password.svg gpa.svg
    lnsvg ../../actions/$(basename $FOLDER)/system-lock-screen.svg keepassxc.svg
    lnsvg ../../status/$(basename $FOLDER)/security-high.svg zuluCrypt.svg
done

for FOLDER in $(find $ELEMENTARY_XFCE/elementary-xfce/actions -type d -regex ".*/[0-9]+$"); do
    cd $FOLDER
    lnsvg view-grid-symbolic.svg view-list.svg
    lnsvg view-dual-symbolic.svg view-preview.svg
    lnsvg view-compact-symbolic.svg view-list-text.svg
    lnsvg view-list-symbolic.svg view-list-detalis.svg
done

for SIZE in 16 24 32 48 64 96 128 symbolic; do
    cd $ELEMENTARY_XFCE/elementary-xfce/mimes/$SIZE
    if [ -f office-database.png ]; then
        ln -s office-database.png application-x-sb.png
    fi
done
ln -s mimes $ELEMENTARY_XFCE/elementary-xfce/mimetypes

cd $SCRIPT_DIR
tar --exclude-vcs -zcf elementary-minios_$(dpkg-parsechangelog --show-field Version | sed "s/-1//g").orig.tar.gz ./elementary-xfce

cp -R $SCRIPT_DIR/debian $ELEMENTARY_XFCE/

cd $ELEMENTARY_XFCE
apt build-dep .
dpkg-buildpackage -uc -us
cd $SCRIPT_DIR
git submodule deinit -f elementary-xfce
