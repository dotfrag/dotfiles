#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main | grep -v "zsh"); do
  rm -vrf "${HOME}/.config/${i}"
done

echo

output=()
for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main | grep -vP "vim|zsh"); do
  output+=("$(command -v "${i}" >/dev/null && ln -vsf "${SCRIPT_DIR}/${i}" "${HOME}/.config/${i}")")
done
printf "%s\n" "${output[@]}" | column -t && echo

command -v betterlockscreen >/dev/null && ln -vsf "${SCRIPT_DIR}/betterlockscreenrc" "${HOME}/.config/betterlockscreenrc"
command -v networkmanager_dmenu >/dev/null && ln -vsf "${SCRIPT_DIR}/networkmanager-dmenu" "${HOME}/.config/networkmanager-dmenu"

echo

ln -vsf "${SCRIPT_DIR}/zsh/.zshrc.local" "${ZDOTDIR:-${HOME}}/.zshrc.local"
ln -vsf "${SCRIPT_DIR}/chrome-flags.conf" "${HOME}/.config/chrome-flags.conf"
