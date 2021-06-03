#!/bin/bash

# git clone or update (pull)
function gclone() {
  git clone "$1" "$2" &> /dev/null
  if [ $? -ne 0 ]; then
    echo "Repository $2 exists, checking for updates.."
    git -C $2 pull
  fi
}

# Update package database and install packages
read -p "Install packages? [y/n] " -n 1 -r ; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if [ -f "/etc/debian_version" ]; then

    echo "Updating package database.."
    sudo apt-get update -y > /dev/null

    echo "Installing wget curl git build-essential software-properties-common.."
    sudo apt-get install wget curl git build-essential software-properties-common -y > /dev/null
    sudo add-apt-repository ppa:aacebedo/fasd -y && sudo apt-get update -y > /dev/null

    echo "Installing zsh vim tmux ranger fasd.."
    sudo apt-get install zsh vim tmux ranger fasd -y > /dev/null

    echo "Installing fd ripgrep.."
    cd $(mktemp -d)
    curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | grep "browser_download_url.*fd_.*_amd64.deb" | cut -d: -f2,3 | tr -d "\" " | wget -qi -
    curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep "browser_download_url.*ripgrep_.*_amd64.deb" | cut -d: -f2,3 | tr -d "\" " | wget -qi -
    sudo dpkg -i fd* ripgrep* > /dev/null

  elif [ -f "/etc/arch-release" ]; then

    echo "Updating package database.."
    sudo pacman -Syy > /dev/null

    echo "Installing wget curl git.."
    sudo pacman -S wget curl git --noconfirm > /dev/null

    echo "Installing zsh vim tmux ranger ripgrep fd fasd.."
    sudo pacman -S zsh vim tmux ranger ripgrep fd fasd --noconfirm > /dev/null

  fi
fi

cd $HOME

# Dotfiles
read -p "Setup DOTFILES? [y/n] " -n 1 -r ; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  gclone "https://github.com/dotfrag/dotfiles.git" "$HOME/dotfiles"
fi

# Vim
read -p "Setup VIM? [y/n] " -n 1 -r ; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  mkdir -p $HOME/.vim/{autoload,backup,swap,undo}
  ln -sf $HOME/dotfiles/.vimrc $HOME/.vimrc
  cp $HOME/dotfiles/.vim/plugins.vim $HOME/.vim/
  ln -sf $HOME/dotfiles/.vim/mappings.vim $HOME/.vim/
  ln -sf $HOME/dotfiles/.vim/autoload/myfunc.vim $HOME/.vim/autoload/
  ln -sfn $HOME/dotfiles/.vim/{ftplugin,UltiSnips} $HOME/.vim/
fi

# Zsh
read -p "Setup ZSH? [y/n] " -n 1 -r ; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Downloading grml-zsh-config.."
  wget -qO $HOME/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
fi

# Tmux
read -p "Setup TMUX? [y/n] " -n 1 -r ; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  gclone "https://github.com/tmux-plugins/tmux-copycat" "$HOME/.tmux/plugins/copycat"
  gclone "https://github.com/tmux-plugins/tmux-logging" "$HOME/.tmux/plugins/logging"
  gclone "https://github.com/tmux-plugins/tmux-resurrect" "$HOME/.tmux/plugins/resurrect"
  gclone "https://github.com/tmux-plugins/tmux-yank" "$HOME/.tmux/plugins/yank"
  ln -sf $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
fi

# fzf
read -p "Setup FZF? [y/n] " -n 1 -r ; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  gclone "--depth 1 https://github.com/junegunn/fzf.git" "$HOME/.fzf"
  $HOME/.fzf/install --key-bindings --completion --no-update-rc > /dev/null
fi

# Ranger
read -p "Setup RANGER? [y/n] " -n 1 -r ; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if [ ! -L $HOME/.config/ranger ]; then
    echo "Directory $HOME/.config/ranger exists."
  else
    ln -sfn $HOME/dotfiles/.config/ranger $HOME/.config/ranger
  fi
fi

# vim: ts=2 sw=2 et
