#!/bin/bash

status() {
  if nmcli c show --active | grep -q vpn; then
    ip=$(ip -f inet addr show tun0 | awk '/inet / {print $2}' | cut -d'/' -f1)
    echo "󰖂 ${ip}"
  else
    wired_intf=$(ip -br l | awk '$1 !~ "lo|tun|vir|wl" {print $1}')
    subnet_mask=$(ip -f inet addr show "${wired_intf}" | awk '/inet / {print $2}' | cut -d'/' -f2)
    if [[ ${subnet_mask} == "22" ]]; then
      echo "󰖂"
    else
      echo "󰖂 VPN OFF"
    fi
  fi
}

monitor() {
  status

  nmcli monitor | while read -r event; do
    if echo "${event}" | grep -P 'tun0: (connected|device removed)'; then
      status
    fi
  done
}

monitor
