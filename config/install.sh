#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR=${XDG_CONFIG_HOME:-${HOME}/.config}

output=()
declare -A config_dirs=(
  ["Hyprland"]="hypr"
  ["betterlockscreen"]="betterlockscreenrc"
  ["fast-theme"]="fsh"
  ["google-chrome"]="chrome-flags.conf"
  ["google-chrome-stable"]="chrome-flags.conf"
  ["networkmanager_dmenu"]="networkmanager-dmenu"
  ["rg"]="ripgrep"
  ["setxkbmap"]="xkb"
  ["subl"]="sublime-text"
  ["sway"]="xdg-desktop-portal"
  ["thorium-browser"]="thorium-flags.conf"
)

# straightforward configs
for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main | grep -vP "install|sublime-text"); do
  output+=("$(command -v "${i}" >/dev/null && ln -vsfT "${SCRIPT_DIR}/${i}" "${CONFIG_DIR}/${i}")")
done

# custom config dirs
for i in "${!config_dirs[@]}"; do
  if [[ "${i}" = fast-theme ]]; then
    output+=("$(ln -vsfT "${SCRIPT_DIR}/${config_dirs['fast-theme']}" "${HOME}/.config/${config_dirs['fast-theme']}")")
  elif [[ "${i}" = subl ]]; then
    output+=("$(command -v "${i}" >/dev/null && ln -vsfT "${SCRIPT_DIR}/${config_dirs[${i}]}" "${CONFIG_DIR}/sublime-text/Packages/User")")
  else
    output+=("$(command -v "${i}" >/dev/null && ln -vsfT "${SCRIPT_DIR}/${config_dirs[${i}]}" "${CONFIG_DIR}/${config_dirs[${i}]}")")
  fi
done

# fast-syntax-highlighting and bat setup
zsh -ic 'fast-theme XDG:catppuccin-macchiato; bat cache --build' >/dev/null

# shellcheck disable=SC2207
IFS=$'\n' output=($(sort <<<"${output[*]}"))
printf "%s\n" "${output[@]}" | column -t
