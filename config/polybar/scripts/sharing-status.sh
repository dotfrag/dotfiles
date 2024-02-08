#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

sep="$("${SCRIPT_DIR}/get-property.sh" sep)"
color=$("${SCRIPT_DIR}/get-property.sh" color tertiary)

i3-msg -t subscribe -m '[ "window" ]' | while read -r event; do
  name=$(echo "${event}" | jq -r '.container.name')
  if [[ "${name}" == "teams.microsoft.com is sharing"* ]]; then
    change=$(echo "${event}" | jq -r '.change')
    if [ "${change}" = "new" ]; then
      echo "%{F#BF616A}󰊻 SHARING%{F-}%{F${color}}${sep}%{F-}"
    elif [ "${change}" = "close" ]; then
      echo
    fi
  fi
done
