#!/usr/bin/env bash

# Terminate already running bar instances
# polybar-msg cmd quit
killall -q -9 polybar inhibit-idle.sh microphone.sh sharing-status.sh vpn-status.sh

# Wait until the processes have been shut down
while pgrep -u "${UID}" -x polybar > /dev/null; do sleep 0; done

# Cleanup pipes
rm /tmp/polybar_mqueue.*

# Variables
mapfile -t MONITORS < <(polybar --list-monitors | cut -d":" -f1)
if [[ -z ${POLYBAR_INTF_TYPE} ]]; then
  wired_intf_p=$(ip -br l | awk '$1 !~ "lo|tun|vir|wl|enx" {print $1}')
  wired_intf_x=$(ip -br l | awk '$1 !~ "lo|tun|vir|wl|enp" {print $1}')
  if [[ $(cat "/sys/class/net/${wired_intf_p}/carrier") == 1 ]]; then
    wired_intf="${wired_intf_p}"
  else
    wired_intf="${wired_intf_x}"
  fi
  if [[ -z ${wired_intf} ]]; then
    export POLYBAR_INTF_TYPE="wireless"
  fi
fi

# Launch the bar
printf "\n-------------------\n" | tee -a /tmp/polybar_top.log /tmp/polybar_bottom.log
for m in "${MONITORS[@]}"; do
  export MONITOR=${m}
  for bar in top bottom; do
    polybar --log=warning --reload "${bar}" 2>&1 | tee -a "/tmp/polybar_${bar}.log" &
    disown
  done
done
