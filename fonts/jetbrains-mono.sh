#!/bin/bash

if [[ -f /etc/arch-release ]]; then
  sudo pacman -S --needed ttf-jetbrains-mono
  exit
fi

LATEST_VERSION=$(curl -sLH 'Accept: application/json' 'https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest' | jq -r '.tag_name')
FILENAME=JetBrainsMono-${LATEST_VERSION/v/}.zip
TARGET_DIR="${HOME}/.local/share/fonts/JetBrainsMono"

mkdir -p "${TARGET_DIR}"
wget -nc -q --show-progress -O "/tmp/${FILENAME}" "https://github.com/JetBrains/JetBrainsMono/releases/download/${LATEST_VERSION}/${FILENAME}"
unzip -o "/tmp/${FILENAME}" -d "${TARGET_DIR}"
[[ $(ps -o stat= -p "${PPID}") == "Ss" ]] && fc-cache -rf
