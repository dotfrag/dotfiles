#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
FZF_DIR="${HOME}/.local/bin/fzf"
ZSH_PLUGINS_DIR="${HOME}/.config/zsh/plugins"

# detect distro for package manager
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
if [ "$DISTRO" = "Ubuntu" ]; then
  command -v nala &>/dev/null && pacman=nala || pacman=apt
  sudo "${pacman}" update
  sudo "${pacman}" install -y ranger tmux tree zsh
elif [ "$DISTRO" = "Fedora Linux" ]; then
  sudo dnf check-update
  sudo dnf install -y cargo exa golang nodejs ranger rust tmux tree vim-enhanced zoxide zsh
fi
printf '=%.0s' $(seq 1 ${COLUMNS})

# zsh
wget -nv -O "${ZDOTDIR:-${HOME}}/.zshrc" https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
wget -nv -O "${ZDOTDIR:-${HOME}}/.zshrc.skel" https://git.grml.org/f/grml-etc-core/etc/skel/.zshrc
[ -f "${ZDOTDIR:-${HOME}}/.zshrc.pre" ] || printf "ls_options+=( --group-directories-first )" >"${ZDOTDIR:-${HOME}}/.zshrc.pre"
ln -vsf "${SCRIPT_DIR}/config/zsh/.zshrc.local" "${ZDOTDIR:-${HOME}}/.zshrc.local"
mkdir -p "${ZSH_PLUGINS_DIR}"
printf "[zsh-syntax-highlighting] "
git -C "${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting" pull 2>/dev/null || git clone "https://github.com/zsh-users/zsh-syntax-highlighting" "${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting"
printf '=%.0s' $(seq 1 ${COLUMNS})
sudo mkdir -p /usr/local/share/zsh/site-functions
sudo wget -nv -O /usr/local/share/zsh/site-functions/_autorandr https://raw.githubusercontent.com/phillipberndt/autorandr/master/contrib/zsh_completion/_autorandr
sudo wget -nv -O /usr/local/share/zsh/site-functions/_fd https://raw.githubusercontent.com/sharkdp/fd/master/contrib/completion/_fd
sudo wget -nv -O /usr/local/share/zsh/site-functions/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
sudo wget -nv -O /usr/local/share/zsh/site-functions/_dunst https://raw.githubusercontent.com/dunst-project/dunst/master/contrib/_dunst.zshcomp
sudo wget -nv -O /usr/local/share/zsh/site-functions/_dunstctl https://raw.githubusercontent.com/dunst-project/dunst/master/contrib/_dunstctl.zshcomp
printf '=%.0s' $(seq 1 ${COLUMNS})

# tmux
ln -vsf "${SCRIPT_DIR}/config/tmux" "${HOME}/.config/"
printf '=%.0s' $(seq 1 ${COLUMNS})

# vim
ln -vsf "${SCRIPT_DIR}/config/vim/.vimrc" "${HOME}/.vimrc"
vim_plugins=(
  "christoomey/vim-tmux-navigator" "junegunn/fzf" "junegunn/fzf.vim"
  "junegunn/vim-easy-align" "mg979/vim-visual-multi" "sheerun/vim-polyglot"
  "tpope/vim-commentary" "tpope/vim-commentary" "tpope/vim-repeat"
  "tpope/vim-surround" "tpope/vim-unimpaired" "vim-airline/vim-airline"
)
for i in "${vim_plugins[@]}"; do
  name=$(echo "$i" | cut -d '/' -f2)
  printf "[%s] " "${name}"
  git -C "${HOME}/.vim/pack/plugins/start/${name}" pull 2>/dev/null || git clone "https://github.com/${i}" "${HOME}/.vim/pack/plugins/start/${name}"
done
printf "[onedark.vim] "
git -C "${HOME}/.vim/pack/plugins/opt/onedark.vim" pull 2>/dev/null || git clone "https://github.com/joshdick/onedark.vim" "${HOME}/.vim/pack/plugins/opt/onedark.vim"
printf '=%.0s' $(seq 1 ${COLUMNS})

# fzf
printf "[fzf] "
git -C "${FZF_DIR}" pull 2>/dev/null || git clone --depth 1 https://github.com/junegunn/fzf "${FZF_DIR}"
"${FZF_DIR}/install" --completion --key-bindings --no-bash --no-update-rc >/dev/null
mv "${HOME}/.fzf.zsh" "${ZDOTDIR:-${HOME}}/" 2>/dev/null
printf '=%.0s' $(seq 1 ${COLUMNS})

# ripgrep
mkdir -p "${HOME}/.config/ripgrep"
[ -f "${HOME}/.config/ripgrep/config" ] || printf -- "--max-columns=150\n--max-columns-preview\n--smart-case" >"${HOME}/.config/ripgrep/config"
