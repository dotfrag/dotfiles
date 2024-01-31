#!/bin/bash

i3-msg -t subscribe -m '[ "window" ]' | while read -r event; do
  name=$(echo "${event}" | jq -r '.container.name')
  if [[ "${name}" == "teams.microsoft.com is sharing"* ]]; then
    change=$(echo "${event}" | jq -r '.change')
    if [ "${change}" = "new" ]; then
      echo "%{F#BF616A}󰊻 SHARING%{F-}"
    elif [ "${change}" = "close" ]; then
      echo
    fi
  fi
done
