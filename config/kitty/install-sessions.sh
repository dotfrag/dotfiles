#!/bin/bash

DIR=${HOME}/.local/share/applications

if [[ -f /usr/share/applications/kitty.desktop ]]; then
  SRC=/usr/share/applications/kitty.desktop
elif [[ -f ${DIR}/kitty.desktop ]]; then
  SRC=${DIR}/kitty.desktop
else
  echo "Cannot find kitty.desktop file"
  exit 1
fi

for session in *.session; do
  file_name=${session%.session}
  file_name_out="kitty-${file_name}.desktop"
  sed "/^Name=/s/\$/ ${file_name}/
  /^Exec=/s/\$/ -o allow_remote_control=yes --session ${session}/" "${SRC}" >"${DIR}/${file_name_out}"
  echo "Installed ${file_name_out}"
done
