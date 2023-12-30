#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR=${XDG_CONFIG_HOME:-${HOME}/.config}
ZSH_DIR=${ZDOTDIR:-${HOME}}

output=()
declare -A config_dirs=(
  ["betterlockscreen"]="betterlockscreenrc"
  ["fast-theme"]="fsh"
  ["google-chrome"]="chrome-flags.conf"
  ["google-chrome-stable"]="chrome-flags.conf"
  ["networkmanager_dmenu"]="networkmanager-dmenu"
  ["rg"]="ripgrep"
  ["sway"]="xdg-desktop-portals"
  ["zsh"]=".zshrc.local"
)

# straightforward configs
for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main | grep -vP "install|zsh|sublime-text"); do
  output+=("$(command -v "${i}" >/dev/null && ln -vsfT "${SCRIPT_DIR}/${i}" "${CONFIG_DIR}/${i}")")
done

# custom config dirs
for i in "${!config_dirs[@]}"; do
  if [[ "${i}" = zsh ]]; then
    output+=("$(command -v zsh >/dev/null && ln -vsfT "${SCRIPT_DIR}/zsh/${config_dirs[${i}]}" "${ZSH_DIR}/${config_dirs[${i}]}")")
    output+=("$(ln -vsfT "${SCRIPT_DIR}/${config_dirs['fast-theme']}" "${HOME}/.config/${config_dirs['fast-theme']}")")
    zsh -ic 'fast-theme XDG:catppuccin-macchiato; bat cache --build' >/dev/null
    continue
  fi
  output+=("$(command -v "${i}" >/dev/null && ln -vsfT "${SCRIPT_DIR}/${config_dirs[${i}]}" "${CONFIG_DIR}/${config_dirs[${i}]}")")
done

# sublime-text
output+=("$(command -v subl >/dev/null && ln -vsfT "${SCRIPT_DIR}/sublime-text" "${CONFIG_DIR}/sublime-text/Packages/User")")

# shellcheck disable=SC2207
IFS=$'\n' output=($(sort <<<"${output[*]}"))
printf "%s\n" "${output[@]}" | column -t
