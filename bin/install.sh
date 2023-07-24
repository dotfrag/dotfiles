#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main | grep -v "install.sh"); do
  rm -vrf "${HOME}/.local/bin/${i}"
  ln -vsf "${SCRIPT_DIR}/${i}" "${HOME}/.local/bin/${i}"
  echo
done
