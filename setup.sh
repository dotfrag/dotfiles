#!/bin/bash

# globals
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
FZF_DIR=${XDG_DATA_HOME:-${HOME}/.local/share}/fzf
VIM_PACKPATH=${XDG_DATA_HOME:-${HOME}/.local/share}/vim/pack/plugins/start
ZSH_PLUGINS_DIR=${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/plugins

# detect distro
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  DISTRO=${NAME}
elif command -v lsb_release &> /dev/null; then
  DISTRO=$(lsb_release -si)
elif [[ -f /etc/lsb-release ]]; then
  # shellcheck disable=SC1091
  . /etc/lsb-release
  # shellcheck disable=SC2154
  DISTRO=${DISTRIB_ID}
else
  echo "Unable to detect distribution."
  exit 1
fi

println() {
  printf '=%.0s' $(seq 1 "${COLUMNS}")
}

setup_zsh() {
  [[ -n "${ZDOTDIR}" ]] && mkdir -p "${ZDOTDIR}"
  mkdir -p "${ZSH_PLUGINS_DIR}"
  printf "[fast-syntax-highlighting] "
  git -C "${ZSH_PLUGINS_DIR}/fsh" pull 2> /dev/null || git clone --depth 1 "https://github.com/zdharma-continuum/fast-syntax-highlighting" "${ZSH_PLUGINS_DIR}/fsh"
}

setup_vim() {
  vim_plugins=(
    "catppuccin/vim" "christoomey/vim-tmux-navigator" "junegunn/fzf"
    "junegunn/fzf.vim" "junegunn/vim-easy-align" "mg979/vim-visual-multi"
    "sheerun/vim-polyglot" "tpope/vim-commentary" "tpope/vim-repeat"
    "tpope/vim-surround" "tpope/vim-unimpaired" "vim-airline/vim-airline"
  )
  for i in "${vim_plugins[@]}"; do
    name=$(echo "${i}" | cut -d '/' -f2)
    printf "[%s] " "${name}"
    git -C "${VIM_PACKPATH}/${name}" pull 2> /dev/null || git clone --depth 1 "https://github.com/${i}" "${VIM_PACKPATH}/${name}"
  done
  println
}

setup_fzf() {
  if [[ "${DISTRO}" != "Arch Linux" ]]; then
    printf "[fzf] "
    git -C "${FZF_DIR}" pull 2> /dev/null || git clone --depth 1 https://github.com/junegunn/fzf "${FZF_DIR}"
    "${FZF_DIR}/install" --bin > /dev/null
    println
  fi
}

setup_config() {
  bash "${SCRIPT_DIR}/config/install.sh"
  println
}

setup_bin() {
  bash "${SCRIPT_DIR}/bin/install.sh"
}

main() {
  setup_zsh
  setup_vim
  setup_fzf
  setup_config
  setup_bin
}

main
