#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main); do
  rm -vrf "${HOME}/.config/${i}"
  ln -vsf "${SCRIPT_DIR}/${i}" "${HOME}/.config/${i}"
  echo
done
