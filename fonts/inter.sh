#!/bin/bash

if [[ -f /etc/arch-release ]]; then
  yay -S --needed ttf-inter
  exit
fi

LATEST_VERSION=$(curl -sLH 'Accept: application/json' 'https://api.github.com/repos/rsms/inter/releases/latest' | jq -r '.tag_name')
FILENAME=Inter-${LATEST_VERSION/v/}.zip
TARGET_DIR="${HOME}/.local/share/fonts/Inter"

mkdir -p "${TARGET_DIR}"
wget -nc -q --show-progress -O "/tmp/${FILENAME}" "https://github.com/rsms/inter/releases/download/${LATEST_VERSION}/${FILENAME}"
unzip -o "/tmp/${FILENAME}" -d "${TARGET_DIR}" -x 'extras/*' 'web/*'
[[ $(ps -o stat= -p "${PPID}") == "Ss" ]] && fc-cache -rf
