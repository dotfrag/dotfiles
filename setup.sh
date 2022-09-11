#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# detect distro for package manager
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$NAME
elif type lsb_release >/dev/null 2>&1; then
  OS=$(lsb_release -si)
elif [ -f /etc/lsb-release ]; then
  . /etc/lsb-release
  OS=$DISTRIB_ID
else
  echo "Unable to detect distribution."
  exit 1
fi

# packages
if [ "$OS" = "Ubuntu" ]; then
  sudo apt update && sudo apt install -y ranger ripgrep tmux tree zsh
elif [ "$OS" = "Fedora Linux" ]; then
  sudo dnf check-update && sudo dnf install -y autoconf automake cargo cmake exa gcc gcc-c++ golang kitty neovim nodejs ranger ripgrep rust starship tmux tree vim-enhanced zoxide zsh
fi

# zsh
wget -nv -O "${HOME}/.zshrc" https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
wget -nv -O "${HOME}/.zshrc.skel" https://git.grml.org/f/grml-etc-core/etc/skel/.zshrc
[ -f "${HOME}/.zshrc.pre" ] || printf "ls_options+=( --group-directories-first )" >"${HOME}/.zshrc.pre"
ln -sf "${SCRIPT_DIR}/.zshrc.local" "${HOME}/.zshrc.local"
mkdir -p "${HOME}/.zsh"
# git -C "${HOME}/.zsh/pure" pull 2>/dev/null || git clone "https://github.com/sindresorhus/pure.git" "${HOME}/.zsh/pure"
# git -C "${HOME}/.zsh/zsh-z" pull 2>/dev/null || git clone "https://github.com/agkozak/zsh-z.git" "${HOME}/.zsh/zsh-z"
git -C "${HOME}/.zsh/zsh-syntax-highlighting" pull 2>/dev/null || git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${HOME}/.zsh/zsh-syntax-highlighting"
sudo wget -nv -O /usr/local/share/zsh/site-functions/_autorandr https://raw.githubusercontent.com/phillipberndt/autorandr/master/contrib/zsh_completion/_autorandr
sudo wget -nv -O /usr/local/share/zsh/site-functions/_fd https://raw.githubusercontent.com/sharkdp/fd/master/contrib/completion/_fd

# tmux
ln -sf "${SCRIPT_DIR}/.tmux.conf" "${HOME}/.tmux.conf"

# vim
ln -sf "${SCRIPT_DIR}/.vimrc" "${HOME}/.vimrc"
mkdir -p ${HOME}/.vim/{backup,swap,undo}
mkdir -p ${HOME}/.vim/pack/plugins/{start,opt}
vim_plugins=(
  "Yggdroot/indentLine" "arcticicestudio/nord-vim.git"
  "christoomey/vim-tmux-navigator.git" "junegunn/fzf" "junegunn/fzf.vim"
  "junegunn/vim-easy-align" "sheerun/vim-polyglot" "tpope/vim-commentary"
  "tpope/vim-commentary" "tpope/vim-repeat.git" "tpope/vim-surround.git"
  "tpope/vim-unimpaired" "vim-airline/vim-airline.git"
)
for i in "${vim_plugins[@]}"; do
  name=$(echo "$i" | cut -d '/' -f2)
  git -C "${HOME}/.vim/pack/plugins/start/${name}" pull 2>/dev/null || git clone "https://github.com/${i}" "${HOME}/.vim/pack/plugins/start/${name}"
done

# fzf
git -C ${HOME}/.fzf pull || git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
${HOME}/.fzf/install --completion --key-bindings --no-update-rc >/dev/null

# ripgrep
mkdir -p "${HOME}/.config/ripgrep"
[ -f "${HOME}/.config/ripgrep/config" ] || printf -- "--max-columns=150\n--max-columns-preview\n--smart-case" >"${HOME}/.config/ripgrep/config"
