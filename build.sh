#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SOURCE=$SCRIPT_DIR/elementary-xfce/elementary-xfce/apps

if apt-cache policy git | grep -q "Installed: (none)"; then
    apt-get install -y git
fi

git submodule init
git submodule update

cp -R $SCRIPT_DIR/debian $SCRIPT_DIR/elementary-xfce/

for FOLDER in $(ls $SOURCE | grep -E "^[0-9]+$"); do
    cd $SOURCE/$FOLDER
    if [ -f accessories-calculator.svg ]; then
        ln -s accessories-calculator.svg galculator.svg
    fi
    if [ -f baobab.svg ]; then
        ln -s baobab.svg org.gnome.baobab.svg
    elif [ -f org.gnome.baobab.svg ]; then
        ln -s org.gnome.baobab.svg baobab.svg
    fi
    if [ -f internet-mail.svg ]; then
        ln -s internet-mail.svg emblem-mail.svg
    fi
    if [ -f preferences-system-power.svg ]; then
        ln -s preferences-system-power.svg laptop-mode-tools.svg
    fi
    if [ -f pdfshuffler.svg ]; then
        ln -s pdfshuffler.svg com.github.jeromerobert.pdfarranger.svg
        ln -s pdfshuffler.svg pdfarranger.svg
        ln -s pdfshuffler.svg pdfmod.svg
    fi
    if [ -f ../../status/$FOLDER/sync-synchronizing.svg ]; then
        ln -s ../../status/$FOLDER/sync-synchronizing.svg grsync.svg
    fi
    if [ -f ../../devices/$FOLDER/drive-harddisk.svg ]; then
        ln -s ../../devices/$FOLDER/drive-harddisk.svg gsmartcontrol.svg
    fi
done

cd $SCRIPT_DIR
tar --exclude-vcs -zcf elementary-xfce-minios_$(dpkg-parsechangelog --show-field Version | sed "s/-2-2/-2/g").orig.tar.gz ./elementary-xfce

cd $SCRIPT_DIR/elementary-xfce
apt build-dep elementary-xfce
dpkg-buildpackage -uc -us
