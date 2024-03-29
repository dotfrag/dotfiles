#!/bin/bash

if [[ -f /etc/arch-release ]]; then
  sudo pacman -S --needed "ttc-iosevka-ss08"
  exit
fi

LATEST_VERSION=$(curl -sLH 'Accept: application/json' 'https://api.github.com/repos/be5invis/Iosevka/releases/latest' | grep -Po '"tag_name": "\Kv[^"]*')
FILENAME="super-ttc-iosevka-ss08-${LATEST_VERSION/v/}.zip"

mkdir -p "${HOME}/.local/share/fonts"
wget -nc -q --show-progress -O "/tmp/${FILENAME}" "https://github.com/be5invis/Iosevka/releases/download/${LATEST_VERSION}/${FILENAME}"
unzip -o "/tmp/${FILENAME}" -d "${HOME}/.local/share/fonts/"
fc-cache -rf
