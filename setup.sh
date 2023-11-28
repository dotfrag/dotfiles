#!/bin/bash

# globals
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
FZF_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/fzf"
VIM_PACKPATH="${XDG_DATA_HOME:-${HOME}/.local/share}/vim/pack/plugins/start"
ZSH_COMP_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/completions"
ZSH_PLUGINS_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/plugins"

# detect distro
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO=${NAME}
elif command -v lsb_release &>/dev/null; then
  DISTRO=$(lsb_release -si)
elif [ -f /etc/lsb-release ]; then
  # shellcheck disable=SC1091
  . /etc/lsb-release
  # shellcheck disable=SC2154
  DISTRO=${DISTRIB_ID}
else
  echo "Unable to detect distribution."
  exit 1
fi

setup_packages() {
  . packages.sh
  if [ "${DISTRO}" = "Arch Linux" ]; then
    sudo pacman -Syu
    sudo pacman -S --needed "${packages_pacman[@]}"
    if ! command -v yay &>/dev/null; then
      git clone --depth 1 https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si
    fi
    yay -S --needed "${packages_yay[@]}"
  elif [ "${DISTRO}" = "Fedora Linux" ]; then
    sudo dnf check-update
    sudo dnf install -y "${packages_dnf[@]}"
  elif [ "${DISTRO}" = "Ubuntu" ]; then
    command -v nala &>/dev/null && apt=nala || apt=apt
    sudo "${apt}" update
    sudo "${apt}" install -y "${packages_apt[@]}"
  fi
  printf '=%.0s' $(seq 1 ${COLUMNS})
}

setup_zsh() {
  [ -n "${ZDOTDIR}" ] && mkdir -p "${ZDOTDIR}"
  wget -nv -O "${ZDOTDIR:-${HOME}}/.zshrc" https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
  wget -nv -O "${ZDOTDIR:-${HOME}}/.zshrc.skel" https://git.grml.org/f/grml-etc-core/etc/skel/.zshrc
  [ -f "${ZDOTDIR:-${HOME}}/.zshrc.pre" ] || printf "ls_options+=( --group-directories-first )" >"${ZDOTDIR:-${HOME}}/.zshrc.pre"
  ln -vsf "${SCRIPT_DIR}/config/zsh/.zshrc.local" "${ZDOTDIR:-${HOME}}/.zshrc.local"
  ln -vsf "${SCRIPT_DIR}/config/zsh/zsh.d" "${ZDOTDIR:-${HOME}}/"
  mkdir -p "${ZSH_PLUGINS_DIR}"
  printf "[fast-syntax-highlighting] "
  git -C "${ZSH_PLUGINS_DIR}/fsh" pull 2>/dev/null || git clone --depth 1 "https://github.com/zdharma-continuum/fast-syntax-highlighting" "${ZSH_PLUGINS_DIR}/fsh"
  printf '=%.0s' $(seq 1 ${COLUMNS})
  if [ "${DISTRO}" != "Arch Linux" ]; then
    # TODO: Extract completions to separate script.
    mkdir -p "${ZSH_COMP_DIR}"
    wget -nv -O "${ZSH_COMP_DIR}/_autorandr" https://raw.githubusercontent.com/phillipberndt/autorandr/master/contrib/zsh_completion/_autorandr
    wget -nv -O "${ZSH_COMP_DIR}/_docker" https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
    wget -nv -O "${ZSH_COMP_DIR}/_dunst" https://raw.githubusercontent.com/dunst-project/dunst/master/contrib/_dunst.zshcomp
    wget -nv -O "${ZSH_COMP_DIR}/_dunstctl" https://raw.githubusercontent.com/dunst-project/dunst/master/contrib/_dunstctl.zshcomp
    wget -nv -O "${ZSH_COMP_DIR}/_eza" https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza
    wget -nv -O "${ZSH_COMP_DIR}/_fd" https://raw.githubusercontent.com/sharkdp/fd/master/contrib/completion/_fd
    wget -nv -O "${ZSH_COMP_DIR}/_gita" https://raw.githubusercontent.com/nosarthur/gita/master/auto-completion/zsh/_gita
    wget -nv -O "${ZSH_COMP_DIR}/_lf" https://raw.githubusercontent.com/gokcehan/lf/master/etc/lf.zsh
    printf '=%.0s' $(seq 1 ${COLUMNS})
  fi
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
    git -C "${VIM_PACKPATH}/${name}" pull 2>/dev/null || git clone --depth 1 "https://github.com/${i}" "${VIM_PACKPATH}/${name}"
  done
  printf '=%.0s' $(seq 1 ${COLUMNS})
}

setup_fzf() {
  if [ "${DISTRO}" != "Arch Linux" ]; then
    printf "[fzf] "
    git -C "${FZF_DIR}" pull 2>/dev/null || git clone --depth 1 https://github.com/junegunn/fzf "${FZF_DIR}"
    "${FZF_DIR}/install" --completion --key-bindings --no-bash --no-update-rc --xdg >/dev/null
    printf '=%.0s' $(seq 1 ${COLUMNS})
  fi
}

setup_config() {
  bash "${SCRIPT_DIR}/config/install.sh"
  printf '=%.0s' $(seq 1 ${COLUMNS})
}

setup_bin() {
  bash "${SCRIPT_DIR}/bin/install.sh"
}

[ "$1" = "pac" ] && sudo -v && setup_packages
setup_zsh
setup_vim
setup_fzf
setup_config
setup_bin
