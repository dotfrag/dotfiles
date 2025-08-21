#!/bin/bash

if [[ -f /etc/arch-release ]]; then
  yay -S --needed otf-geist
  exit
fi

LATEST_VERSION=$(curl -sLH 'Accept: application/json' 'https://api.github.com/repos/vercel/geist-font/releases/latest' | grep -Po '"tag_name": "\K[^"]*')
FILENAME=geist-font-${LATEST_VERSION}.zip
TARGET_DIR="${HOME}/.local/share/fonts/Geist"

mkdir -p "${TARGET_DIR}"
wget -nc -q --show-progress -O "/tmp/${FILENAME}" "https://github.com/vercel/geist-font/releases/download/${LATEST_VERSION}/${FILENAME}"
unzip -j -o "/tmp/${FILENAME}" -d "${TARGET_DIR}" "${FILENAME%.zip}/fonts/*" # "${FILENAME%.zip}/fonts/GeistMono"
[[ $(ps -o stat= -p "${PPID}") == "Ss" ]] && fc-cache -rf
