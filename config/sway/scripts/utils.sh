#!/bin/bash

# List of open windows
windows() {
  swaymsg -r -t get_tree | jq -r '.. | select(.type? == "con") | .name?'
}

# List of outputs
outputs() {
  swaymsg -r -t get_outputs | jq -r '.[].name'
}

# Poll tree layout until a window with the given identifier exists
wait_for_window() {
  local what=$1 id=${2:-name}
  until swaymsg -t get_tree | jq -e ".. | objects | select(.${id}? == \"${what}\")" > /dev/null 2>&1; do
    sleep 0.1
  done
}

# Poll tree layout until a window with the given identifier exists (regex)
wait_for_window_regex() {
  local what=$1 id=${2:-name}
  until swaymsg -t get_tree | jq -e ".. | objects | select(.${id}? | strings | test(\"${what}\"))" > /dev/null 2>&1; do
    sleep 0.1
  done
}

# Poll tree layout until a window with the given title exists
wait_for_window_name() {
  local title=$1
  until swaymsg -t get_tree | jq -e ".. | objects | select(.name? == \"${title}\")" > /dev/null 2>&1; do
    sleep 0.1
  done
}

# Poll tree layout until a window with the given app_id exists
wait_for_window_app_id() {
  local app_id=$1
  # select(.app_id? == "$app_id" or .window_properties.class? == "$app_id")
  until swaymsg -t get_tree | jq -e ".. | objects | select(.app_id? == \"${app_id}\")" > /dev/null 2>&1; do
    sleep 0.1
  done
}
