#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

sep="$("${SCRIPT_DIR}/get-property.sh" sep)"
color_sep=$("${SCRIPT_DIR}/get-property.sh" color tertiary)
color_red=$("${SCRIPT_DIR}/get-property.sh" color red)

i3-msg -t subscribe -m '[ "window" ]' | while read -r event; do
  name=$(echo "${event}" | jq -r '.container.name')
  if [[ "${name}" == "teams.microsoft.com is sharing"* ]]; then
    change=$(echo "${event}" | jq -r '.change')
    if [[ "${change}" = "new" ]]; then
      dunstctl set-paused true
      echo "%{F${color_red}}󰊻 SHARING%{F-}%{F${color_sep}}${sep}%{F-}"
    elif [[ "${change}" = "close" ]]; then
      dunstctl set-paused false
      echo
    fi
  fi
done
