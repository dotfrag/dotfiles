#!/bin/bash

if ! command -v brightnessctl &>/dev/null; then
  echo "brightnessctl could not be found"
  notify-send "brightnessctl could not be found"
  exit 1
fi

case "$1" in
up)
  sudo brightnessctl set +5%
  ;;
down)
  sudo brightnessctl set 5%-
  ;;
esac

value=$(sudo brightnessctl info | grep -oP "\d+%")
command -v canberra-gtk-play &>/dev/null && canberra-gtk-play -i audio-volume-change
command -v dunstify && dunstify --icon="audio-volume-muted" --hints="string:x-dunst-stack-tag:brightness" "Brightness" "Value: ${value}"
