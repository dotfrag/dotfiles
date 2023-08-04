#!/bin/bash

# globals
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
FZF_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/fzf"
VIM_PACKPATH="${XDG_DATA_HOME:-${HOME}/.local/share}/vim/pack/plugins/start"
ZSH_PLUGINS_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/plugins"

# detect distro
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO=$NAME
elif type lsb_release >/dev/null 2>&1; then
  DISTRO=$(lsb_release -si)
elif [ -f /etc/lsb-release ]; then
  # shellcheck disable=SC1091
  . /etc/lsb-release
  DISTRO=$DISTRIB_ID
else
  echo "Unable to detect distribution."
  exit 1
fi

# packages
. packages.sh
if [ "$DISTRO" = "Arch Linux" ]; then
  sudo pacman -Syu
  sudo pacman -S --needed "${packages_pacman[@]}"
  if ! command -v yay &>/dev/null; then
    git clone --depth 1 https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si
  fi
  yay -S --needed "${packages_yay[@]}"
elif [ "$DISTRO" = "Fedora Linux" ]; then
  sudo dnf check-update
  sudo dnf install -y "${packages_dnf[@]}"
elif [ "$DISTRO" = "Ubuntu" ]; then
  command -v nala &>/dev/null && apt=nala || apt=apt
  sudo "${apt}" update
  sudo "${apt}" install -y "${packages_apt[@]}"
fi
printf '=%.0s' $(seq 1 ${COLUMNS})

# zsh
[ -n "${ZDOTDIR}" ] && mkdir -p "${ZDOTDIR}"
wget -nv -O "${ZDOTDIR:-${HOME}}/.zshrc" https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
wget -nv -O "${ZDOTDIR:-${HOME}}/.zshrc.skel" https://git.grml.org/f/grml-etc-core/etc/skel/.zshrc
[ -f "${ZDOTDIR:-${HOME}}/.zshrc.pre" ] || printf "ls_options+=( --group-directories-first )" >"${ZDOTDIR:-${HOME}}/.zshrc.pre"
ln -vsf "${SCRIPT_DIR}/config/zsh/.zshrc.local" "${ZDOTDIR:-${HOME}}/.zshrc.local"
mkdir -p "${ZSH_PLUGINS_DIR}"
printf "[zsh-syntax-highlighting] "
git -C "${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting" pull 2>/dev/null || git clone --depth 1 "https://github.com/zsh-users/zsh-syntax-highlighting" "${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting"
printf '=%.0s' $(seq 1 ${COLUMNS})
if [ "$DISTRO" != "Arch Linux" ]; then
  sudo mkdir -p /usr/local/share/zsh/site-functions
  sudo wget -nv -O /usr/local/share/zsh/site-functions/_autorandr https://raw.githubusercontent.com/phillipberndt/autorandr/master/contrib/zsh_completion/_autorandr
  sudo wget -nv -O /usr/local/share/zsh/site-functions/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
  sudo wget -nv -O /usr/local/share/zsh/site-functions/_dunst https://raw.githubusercontent.com/dunst-project/dunst/master/contrib/_dunst.zshcomp
  sudo wget -nv -O /usr/local/share/zsh/site-functions/_dunstctl https://raw.githubusercontent.com/dunst-project/dunst/master/contrib/_dunstctl.zshcomp
  sudo wget -nv -O /usr/local/share/zsh/site-functions/_exa https://raw.githubusercontent.com/ogham/exa/master/completions/zsh/_exa
  sudo wget -nv -O /usr/local/share/zsh/site-functions/_fd https://raw.githubusercontent.com/sharkdp/fd/master/contrib/completion/_fd
  printf '=%.0s' $(seq 1 ${COLUMNS})
fi

# vim
vim_plugins=(
  "catppuccin/vim" "christoomey/vim-tmux-navigator" "junegunn/fzf"
  "junegunn/fzf.vim" "junegunn/vim-easy-align" "mg979/vim-visual-multi"
  "sheerun/vim-polyglot" "tpope/vim-commentary" "tpope/vim-repeat"
  "tpope/vim-surround" "tpope/vim-unimpaired" "vim-airline/vim-airline"
)
for i in "${vim_plugins[@]}"; do
  name=$(echo "$i" | cut -d '/' -f2)
  printf "[%s] " "${name}"
  git -C "${VIM_PACKPATH}/${name}" pull 2>/dev/null || git clone --depth 1 "https://github.com/${i}" "${VIM_PACKPATH}/${name}"
done
printf '=%.0s' $(seq 1 ${COLUMNS})

# fzf
if [ "$DISTRO" != "Arch Linux" ]; then
  printf "[fzf] "
  git -C "${FZF_DIR}" pull 2>/dev/null || git clone --depth 1 https://github.com/junegunn/fzf "${FZF_DIR}"
  "${FZF_DIR}/install" --completion --key-bindings --no-bash --no-update-rc --xdg >/dev/null
  printf '=%.0s' $(seq 1 ${COLUMNS})
fi

# install config dirs
bash "${SCRIPT_DIR}/config/install.sh"
printf '=%.0s' $(seq 1 ${COLUMNS})

# install bin files
bash "${SCRIPT_DIR}/bin/install.sh"
