#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SOURCE=$SCRIPT_DIR/elementary-xfce/elementary-xfce/apps

if apt-cache policy git | grep -q "Installed: (none)"; then
    apt-get install -y git
fi

git submodule init ./
git submodule update ./

lnsvg() {
    local FILE LINK
    FILE=$1
    LINK=$2
    if [ -f $FILE ]; then
        ln -s $FILE $LINK
    fi
}

cp -R $SCRIPT_DIR/debian $SCRIPT_DIR/elementary-xfce/

for FOLDER in $(ls $SOURCE | grep -E "^[0-9]+$"); do
    cd $SOURCE/$FOLDER
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
    lnsvg ../../status/$FOLDER/sync-synchronizing.svg grsync.svg
    lnsvg ../../devices/$FOLDER/drive-harddisk.svg gsmartcontrol.svg
    lnsvg utilities-system-monitor.svg qps.svg
done

cd $SCRIPT_DIR
tar --exclude-vcs -zcf elementary-xfce-minios_$(dpkg-parsechangelog --show-field Version | sed "s/-2~mos+1//g").orig.tar.gz ./elementary-xfce

cd $SCRIPT_DIR/elementary-xfce
apt build-dep elementary-xfce
dpkg-buildpackage -uc -us
cd $SCRIPT_DIR
git submodule deinit -f elementary-xfce
