#!/bin/bash

if [[ -f /etc/arch-release ]]; then
  sudo pacman -S --needed ttc-iosevka-ss08
  exit
fi

LATEST_VERSION=$(curl -sLH 'Accept: application/json' 'https://api.github.com/repos/be5invis/Iosevka/releases/latest' | grep -Po '"tag_name": "\Kv[^"]*')
FILENAME=SuperTTC-IosevkaSS08-${LATEST_VERSION/v/}.zip
TARGET_DIR="${HOME}/.local/share/fonts"

mkdir -p "${TARGET_DIR}"
wget -nc -q --show-progress -O "/tmp/${FILENAME}" "https://github.com/be5invis/Iosevka/releases/download/${LATEST_VERSION}/${FILENAME}"
unzip -o "/tmp/${FILENAME}" -d "${TARGET_DIR}"
[[ $(ps -o stat= -p "${PPID}") == "Ss" ]] && fc-cache -rf
