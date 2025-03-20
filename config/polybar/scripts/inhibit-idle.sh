#!/bin/bash

if pgrep -f idle.py >/dev/null; then
  pkill -f idle.py
  polybar-msg action inhibit-idle hook 0
else
  nohup idle.py -s 30 >/dev/null 2>&1 &
  polybar-msg action inhibit-idle hook 1
fi
