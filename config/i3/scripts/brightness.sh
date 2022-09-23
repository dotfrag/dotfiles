#!/bin/bash

case "$1" in
up)
  sudo brightnessctl set +5%
  ;;
down)
  sudo brightnessctl set 5%-
  ;;
esac

value=$(sudo brightnessctl info | grep -oP "\d+%")
notify-send --icon=dialog-information "Brightness" "Value: ${value}"
