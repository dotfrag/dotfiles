#!/bin/bash

case "$1" in
  wired)
    wired_intf_p=$(ip -br l | awk '$1 !~ "lo|docker|br|tun|vir|wl|enx" {print $1}')
    wired_intf_x=$(ip -br l | awk '$1 !~ "lo|docker|br|tun|vir|wl|enp" {print $1}')
    if [[ $(cat "/sys/class/net/${wired_intf_p}/carrier") == 1 ]]; then
      interface="${wired_intf_p}"
    else
      interface="${wired_intf_x}"
    fi
    ;;
  vpn)
    interface=$(ip -br l | awk '$1 !~ "lo|docker|br|en|vir|wl" {print $1}')
    ;;
  wireless)
    interface=$(ip -br l | awk '$1 !~ "lo|docker|br|tun|vir|en" {print $1}')
    ;;
  *)
    exit 1
    ;;
esac

# shellcheck disable=SC2154
if [[ $1 == "vpn" ]] && ! ping -c1 -W1 "${VPN_CHECK_HOST}" &>/dev/null; then
  notify-send "VPN is down, restarting..."
  vpn=$(nmcli conn show --active | grep vpn | awk '{print $1}')
  nmcli conn down "${vpn}"
  nmcli conn up "${vpn}"
fi

ip=$(ip -f inet addr show "${interface}" | awk '/inet / {print $2}' | cut -d'/' -f1)

echo -n "${ip}" | xclip -sel c -f | xclip -sel p
notify-send "Clipboard" "${interface} address copied"
