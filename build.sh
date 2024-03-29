#!/bin/bash

set -x

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ELEMENTARY_APPS=$SCRIPT_DIR/elementary-xfce/elementary-xfce/apps
ELEMENTARY_ACTIONS=$SCRIPT_DIR/elementary-xfce/elementary-xfce/actions
MINIOS_APPS=$SCRIPT_DIR/minios-icons/apps

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

for FOLDER in $(ls $MINIOS_APPS | grep -E "^[0-9]+$"); do
    cd $MINIOS_APPS/$FOLDER
    cp *.svg $ELEMENTARY_APPS/$FOLDER
done

for FOLDER in $(ls $ELEMENTARY_APPS | grep -E "^[0-9]+$"); do
    cd $ELEMENTARY_APPS/$FOLDER
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
    lnsvg web-browser.svg falkon.svg
    lnsvg clipboard.svg qlipper.svg
    lnsvg clipboard.svg xfce4-clipman-plugin.png
done

for FOLDER in $(ls $ELEMENTARY_ACTIONS | grep -E "^[0-9]+$"); do
    cd $ELEMENTARY_ACTIONS/$FOLDER
    lnsvg view-grid-symbolic.svg view-list.svg
    lnsvg view-dual-symbolic.svg view-preview.svg
    lnsvg view-compact-symbolic.svg view-list-text.svg
    lnsvg view-list-symbolic.svg view-list-detalis.svg
done

cd $SCRIPT_DIR
tar --exclude-vcs -zcf elementary-xfce-minios_$(dpkg-parsechangelog --show-field Version | cut -d'-' -f1).orig.tar.gz ./elementary-xfce

cd $SCRIPT_DIR/elementary-xfce
apt build-dep elementary-xfce
dpkg-buildpackage -uc -us
cd $SCRIPT_DIR
git submodule deinit -f elementary-xfce
