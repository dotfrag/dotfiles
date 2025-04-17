#!/bin/bash

if [[ -f /etc/arch-release ]]; then
  yay -S --needed otf-geist
  exit
fi

LATEST_VERSION=$(curl -sLH 'Accept: application/json' 'https://api.github.com/repos/vercel/geist-font/releases/latest' | grep -Po '"tag_name": "\K[^"]*')
FILENAMES=("Geist-${LATEST_VERSION}.zip" "GeistMono-${LATEST_VERSION}.zip")
TARGET_DIR="${HOME}/.local/share/fonts"

mkdir -p "${TARGET_DIR}"
for file in "${FILENAMES[@]}"; do
  wget -nc -q --show-progress -O "/tmp/${file}" "https://github.com/vercel/geist-font/releases/download/${LATEST_VERSION}/${file}"
  unzip -o "/tmp/${file}" -d "${TARGET_DIR}" -x '__MACOSX/*' '*/statics-otf/*' '*statics-woff/*' '*/variable-woff/*'
done
[[ $(ps -o stat= -p "${PPID}") == "Ss" ]] && fc-cache -rf
