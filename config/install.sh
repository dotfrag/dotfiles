#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main | grep -v "zsh"); do
  rm -vrf "${HOME}/.config/${i}"
done

echo

for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main | grep -vP "vim|zsh"); do
  command -v "${i}" >/dev/null && ln -vsf "${SCRIPT_DIR}/${i}" "${HOME}/.config/${i}"
done

ln -vsf "${SCRIPT_DIR}/chrome-flags.conf" "${HOME}/.config/chrome-flags.conf"
