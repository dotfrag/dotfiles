#!/bin/bash

LATEST_RELEASE=$(curl -sLH 'Accept: application/json' https://github.com/be5invis/Iosevka/releases/latest)
LATEST_VERSION=$(echo "$LATEST_RELEASE" | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
FILENAME="super-ttc-iosevka-ss08-${LATEST_VERSION//v/}.zip"

mkdir -p "${HOME}/.local/share/fonts"
wget -nc -q --show-progress -O "/tmp/${FILENAME}" "https://github.com/be5invis/Iosevka/releases/download/${LATEST_VERSION}/${FILENAME}"
unzip -o "/tmp/${FILENAME}" -d "${HOME}/.local/share/fonts/"
fc-cache -rf
