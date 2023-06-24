#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

output=()
declare -A config_dirs=(
  [betterlockscreen]=betterlockscreenrc
  [google - chrome - stable]=chrome-flags.conf
  [google - chrome]=chrome-flags.conf
  [networkmanager_dmenu]=networkmanager-dmenu
  [rg]=ripgrep
  [zsh]=.zshrc.local
)

for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main | grep -v "zsh"); do
  rm -vrf "${HOME}/.config/${i}"
done

echo

for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main | grep -vP "vim|zsh"); do
  output+=("$(command -v "${i}" >/dev/null && ln -vsf "${SCRIPT_DIR}/${i}" "${HOME}/.config/${i}")")
done

for i in "${!config_dirs[@]}"; do
  if [[ "$i" = zsh ]]; then
    output+=("$(command -v zsh >/dev/null && ln -vsf "${SCRIPT_DIR}/zsh/${config_dirs[$i]}" "${ZDOTDIR:-${HOME}}/${config_dirs[$i]}")")
    continue
  fi
  output+=("$(command -v "${i}" >/dev/null && ln -vsf "${SCRIPT_DIR}/${config_dirs[$i]}" "${HOME}/.config/${config_dirs[$i]}")")
done

# shellcheck disable=SC2207
IFS=$'\n' output=($(sort <<<"${output[*]}"))
printf "%s\n" "${output[@]}" | column -t
