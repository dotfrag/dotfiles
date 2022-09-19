#!/usr/bin/env bash

# Terminate already running bar instances
# polybar-msg cmd quit
killall -q -9 polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Variables
mapfile -t MONITORS < <(polybar --list-monitors | cut -d":" -f1)
PRIMARY_MONITOR=$(polybar --list-monitors | grep "primary" | cut -d":" -f1)
if [ -z "${POLYBAR_INTF_TYPE}" ]; then
  has_ethernet=$(nmcli device | awk '$2=="ethernet" {print $1}' | head -1 | wc -l)
  if [ "${has_ethernet}" -eq 0 ]; then
    export POLYBAR_INTF_TYPE="wireless"
  fi
fi

# Launch the bar
printf "\n-------------------\n" | tee -a /tmp/polybar_top.log /tmp/polybar_bottom.log
for m in "${MONITORS[@]}"; do
  export MONITOR=$m
  if [ "${m}" = "${PRIMARY_MONITOR}" ]; then
    export TRAY_POS="right"
  fi
  for bar in top bottom; do
    polybar --log=warning --reload "${bar}" 2>&1 | tee -a "/tmp/polybar_${bar}.log" & disown
  done
  unset TRAY_POS
done
