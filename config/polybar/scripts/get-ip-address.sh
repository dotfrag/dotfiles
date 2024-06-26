#!/bin/bash

case "$1" in
  wired)
    filter="lo|docker|br|tun|vir|wl"
    ;;
  vpn)
    filter="lo|docker|br|en|vir|wl"
    ;;
  wireless)
    filter="lo|docker|br|tun|vir|en"
    ;;
  *)
    exit 1
    ;;
esac

interface=$(ip -br l | awk '$1 !~ "'"${filter}"'" {print $1}')
ip=$(ip -f inet addr show "${interface}" | awk '/inet / {print $2}' | cut -d'/' -f1)

echo -n "${ip}" | xclip -sel c -f | xclip -sel p
notify-send "Clipboard" "${interface} address copied"
