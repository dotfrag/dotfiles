#!/bin/bash

DIR=${HOME}/.local/share/applications
SRC=${DIR}/kitty.desktop

for session in *.session; do
  file_name=${session%.session}
  file_name_out="kitty-${file_name}.desktop"
  sed "/^Name=/s/\$/ ${file_name}/
  /^Exec=/s/\$/ --session ${session}/" "${SRC}" >"${DIR}/${file_name_out}"
  echo "Installed ${file_name_out}"
done
