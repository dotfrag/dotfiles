#!/bin/bash

status() {
  DEFAULT_SOURCE=$(pactl get-default-source)
  volume=$(pactl list sources | grep "${DEFAULT_SOURCE}" -m1 -A7 | grep "Volume" | awk -F'/' '{print $2}')
  mute=$(pactl list sources | grep "${DEFAULT_SOURCE}" -m1 -A7 | grep "Mute")

  if [[ -z "${volume}" ]]; then
    echo "No Mic Found"
  else
    volume="${volume//[[:blank:]]/}"
    if [[ "${mute}" == *"yes"* ]]; then
      echo " MUTED"
    elif [[ "${mute}" == *"no"* ]]; then
      echo "%{F#EBCB8B} OPEN%{F-} ${volume}"
    else
      echo "%{F#EBCB8B} OPEN%{F-} ${volume} !"
    fi
  fi
}

listen() {
  status
  LANG=EN
  pactl subscribe | while read -r event; do
    if echo "${event}" | grep -q "source" || echo "${event}" | grep -q "server"; then
      status
    fi
  done
}

toggle() {
  pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

increase() {
  DEFAULT_SOURCE=$(pactl get-default-source)
  volume=$(pactl list sources | grep "${DEFAULT_SOURCE}" -m1 -A7 | grep "Volume" | awk -F'/' '{print $2}')

  if ((${volume//%/} < 100)); then
    pactl set-source-volume @DEFAULT_SOURCE@ +5%
  fi
}

decrease() {
  pactl set-source-volume @DEFAULT_SOURCE@ -5%
}

case "$1" in
  --toggle)
    toggle
    ;;
  --increase)
    increase
    ;;
  --decrease)
    decrease
    ;;
  *)
    listen
    ;;
esac
