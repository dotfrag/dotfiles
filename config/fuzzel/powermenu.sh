#!/bin/bash

lock=' Lock'
suspend=' Suspend'
logout='󰍃 Logout'
reboot=' Reboot'
poweroff=' Poweroff'

chosen=$(echo -e "${lock}\n${suspend}\n${logout}\n${reboot}\n${poweroff}" | fuzzel --dmenu --lines 5)
case ${chosen} in
  "${poweroff}")
    systemctl poweroff
    ;;
  "${reboot}")
    systemctl reboot
    ;;
  "${lock}")
    swaylock -f
    ;;
  "${suspend}")
    systemctl suspend
    ;;
  "${logout}")
    swaymsg exit
    ;;
esac
