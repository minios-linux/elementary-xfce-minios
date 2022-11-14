#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SOURCE=$SCRIPT_DIR/elementary-xfce/elementary-xfce/apps

if apt-cache policy git | grep -q "Installed: (none)"; then
    apt-get install -y git
fi

git submodule init
git submodule update
cd $SCRIPT_DIR/elementary-xfce
git archive --format=tar.gz HEAD -o ../elementary-xfce-minios_0.17-2.orig.tar.gz
cd $SCRIPT_DIR
cp -R $SCRIPT_DIR/debian $SCRIPT_DIR/elementary-xfce/

for FOLDER in $(ls $SOURCE | grep -E "^[0-9]+$"); do
    cd $SOURCE/$FOLDER
    if [ -f accessories-calculator.png ]; then
        ln -s accessories-calculator.png galculator.png
    fi
    if [ -f baobab.png ]; then
        ln -s baobab.png org.gnome.baobab.png
    elif [ -f org.gnome.baobab.png ]; then
        ln -s org.gnome.baobab.png baobab.png
    fi
    if [ -f pdfshuffler.png ]; then
        ln -s pdfshuffler.png com.github.jeromerobert.pdfarranger.png
        ln -s pdfshuffler.png pdfarranger.png
        ln -s pdfshuffler.png pdfmod.png
    fi
    if [ -f ../../status/$FOLDER/sync-synchronizing.png ]; then
        ln -s ../../status/$FOLDER/sync-synchronizing.png grsync.png
    fi
    if [ -f ../../devices/$FOLDER/drive-harddisk.png ]; then
        ln -s ../../devices/$FOLDER/drive-harddisk.png gsmartcontrol.png
    fi
done

cd $SCRIPT_DIR/elementary-xfce
apt build-dep elementary-xfce
dpkg-buildpackage -uc -us
