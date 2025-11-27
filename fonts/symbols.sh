#!/bin/bash

if [[ -f /etc/arch-release ]]; then
  sudo pacman -S --needed "ttf-nerd-fonts-symbols"
  exit
fi

LATEST_VERSION=$(curl -sLH "Accept: application/json" "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" | jq -r '.tag_name')
FILENAME="NerdFontsSymbolsOnly.zip"

mkdir -p "${HOME}/.local/share/fonts"
wget -nc -q --show-progress -O "/tmp/${FILENAME}" "https://github.com/ryanoasis/nerd-fonts/releases/download/${LATEST_VERSION}/${FILENAME}"
unzip -o "/tmp/${FILENAME}" -d "${HOME}/.local/share/fonts/" SymbolsNerdFontMono-Regular.ttf SymbolsNerdFont-Regular.ttf
sudo wget -q --show-progress -O /etc/fonts/conf.d/10-nerd-font-symbols.conf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/10-nerd-font-symbols.conf
[[ $(ps -o stat= -p "${PPID}") == "Ss" ]] && fc-cache -rf
