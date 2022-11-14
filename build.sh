#!/bin/bash

git submodule init
git submodule update
cp -R debian elementary-xfce/

SOURCE=$(pwd)/elementary-xfce/elementary-xfce/apps
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
