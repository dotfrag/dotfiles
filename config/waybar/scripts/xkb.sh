#!/bin/bash

if [[ $1 == "toggle" ]]; then
  if rg -q qwerty /tmp/layout.state; then
    swaymsg input type:keyboard xkb_file ~/.config/xkb/gallium.xkb
    echo "gallium" | tee /tmp/layout.state
  elif rg -q gallium /tmp/layout.state; then
    swaymsg input type:keyboard xkb_file ~/.config/xkb/qwerty.xkb
    echo "qwerty" | tee /tmp/layout.state
  fi
  pkill -SIGRTMIN+8 waybar
else
  cat /tmp/layout.state || echo "qwerty" | tee /tmp/layout.state
fi
