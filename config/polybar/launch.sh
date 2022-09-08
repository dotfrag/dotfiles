#!/usr/bin/env bash

# Terminate already running bar instances
# polybar-msg cmd quit
killall -q -9 polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
printf "\n-------------------\n" | tee -a /tmp/polybar_top.log /tmp/polybar_bottom.log
monitors=$(polybar --list-monitors | cut -d":" -f1)
primary_monitor=$(polybar --list-monitors | grep "primary" | cut -d":" -f1)
for m in ${monitors[@]}; do
  export MONITOR=$m
  if [ "$m" = "$primary_monitor" ]; then
    export TRAY_POS="right"
  fi
  polybar --log=warning --reload top    2>&1 | tee -a /tmp/polybar_top.log    & disown
  polybar --log=warning --reload bottom 2>&1 | tee -a /tmp/polybar_bottom.log & disown
  unset TRAY_POS
done
