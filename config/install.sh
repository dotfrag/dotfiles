#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_DIR=${XDG_CONFIG_HOME:-${HOME}/.config}

output=()
declare -A config_dirs=(
  ["Hyprland"]="hypr"
  ["aria2c"]="aria2"
  ["fast-theme"]="fsh"
  ["google-chrome"]="chrome-flags.conf"
  ["google-chrome-stable"]="chrome-flags.conf"
  ["networkmanager_dmenu"]="networkmanager-dmenu"
  ["rg"]="ripgrep"
  ["setxkbmap"]="xkb"
  ["shellcheck"]="shellcheckrc"
  ["subl"]="sublime-text"
  ["sway"]="xdg-desktop-portal"
  ["thorium-browser"]="thorium-flags.conf"
)

# straightforward configs
for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main | grep -vP "install|zsh"); do
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

# zsh
if [[ -v ZDOTDIR ]]; then
  rm -rf "${ZDOTDIR}"
  output+=("$(ln -vsfT "${SCRIPT_DIR}/zsh" "${ZDOTDIR}")")
else
  ZDIR=${XDG_CONFIG_HOME:-${HOME}/.config}/zsh
  mkdir -p "${ZDIR}"
  output+=("$(ln -vsfT "${SCRIPT_DIR}/zsh/conf.d" "${ZDIR}/conf.d")")
  for f in "${SCRIPT_DIR}/zsh/".*; do
    output+=("$(ln -vsfT "${f}" "${HOME}/${f##*/}")")
  done
fi

# fast-syntax-highlighting and bat setup
zsh -ic 'fast-theme XDG:catppuccin-macchiato; bat cache --build' >/dev/null

# shellcheck disable=SC2207
IFS=$'\n' output=($(sort <<<"${output[*]}"))
printf "%s\n" "${output[@]}" | column -t

# mpv
if command -v mpv >/dev/null && ! [[ -d "${CONFIG_DIR}/mpv/scripts/uosc" ]]; then
  curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh | bash
fi
