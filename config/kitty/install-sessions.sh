#!/bin/bash

DIR=${HOME}/.local/share/applications
SRC=${DIR}/kitty.desktop

for session in *.session; do
  file_name=${session%.session}
  sed "/^Name=/s/\$/ ${file_name}/
  /^Exec=/s/\$/ --session ${session}/" "${SRC}" >"${DIR}/kitty-${file_name}.desktop"
done
