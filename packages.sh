#!/bin/bash

# Note: For ttf-nerd-fonts-symbols-mono, use the "Symbols Nerd Font Mono" family
# in your font config.
#
# Symlink /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf to
# /etc/fonts/conf.d/, or see `man 5 fonts-conf` for other options.

# AUTOSORT: START
packages_pacman_base=(
  # git-zsh-completion
  7zip
  aria2
  at
  base-devel
  bat
  btop
  coreutils
  curl
  difftastic
  dua-cli
  duf
  entr
  eza
  fd
  ffmpeg
  fzf
  git
  git-delta
  git-filter-repo
  glow
  imagemagick
  jq
  just
  lazygit
  lf
  libqalculate
  lm_sensors
  man-db
  man-pages
  mdcat
  mediainfo
  miniserve
  moreutils
  mtr
  neovim
  pacman-contrib
  parallel
  procs
  reflector
  ripgrep
  rsync
  skim
  starship
  tealdeer
  terminus-font
  thermald
  tmux
  tree
  unarchiver
  unzip
  vim
  wget
  yazi
  yt-dlp
  yt-dlp-ejs
  zip
  zoxide
  zsh
  zstd
)
# AUTOSORT: END

# AUTOSORT: START
packages_pacman_desktop=(
  bitwarden
  bob
  brightnessctl
  croc
  direnv
  gammastep
  github-cli
  gnome-keyring
  go
  hurl
  hyperfine
  imv
  inter-font
  kitty
  kitty-shell-integration
  kitty-terminfo
  mpv
  nemo
  neovide
  noto-fonts
  noto-fonts-emoji
  obsidian
  papirus-icon-theme
  pass
  perl-image-exiftool
  plocate
  qalculate-gtk
  qpdf
  rofi
  rofimoji
  rustup
  seahorse
  sshfs
  sway
  sway-contrib
  swaybg
  swayidle
  swaylock
  swaync
  tree-sitter-cli
  ttc-iosevka-ss08
  ttf-fira-code
  ttf-jetbrains-mono
  ttf-nerd-fonts-symbols-common
  ttf-nerd-fonts-symbols-mono
  ttf-opensans
  uv
  wl-clipboard
  xdg-desktop-portal-gtk
  xdg-desktop-portal-wlr
  zathura
  zathura-pdf-mupdf
)
# AUTOSORT: END

# AUTOSORT: START
packages_pacman_server=(
  bandwhich
  docker
  docker-compose
  nethogs
  qrencode
  sysstat
  ufw
  unbound
  wireguard-tools
)
# AUTOSORT: END

# AUTOSORT: START
packages_aur_base=(
  czkawka-cli-bin
  lazydocker-bin
  topgrade-bin
  viddy-bin
)
# AUTOSORT: END

# AUTOSORT: START
packages_aur_desktop=(
  bun-bin
  catppuccin-cursors-macchiato
  catppuccin-gtk-theme-macchiato
  google-chrome
  networkmanager-dmenu-git
  otf-geist
  otf-geist-mono
  sublime-text-4
  thorium-browser-bin
  ttf-merriweather
  visual-studio-code-bin
)
# AUTOSORT: END

packages_aur_server=()

# AUTOSORT: START
packages_dnf=(
  cargo
  exa
  golang
  nodejs
  ranger
  rust
  tmux
  tree
  vim-enhanced
  zoxide
  zsh
)
# AUTOSORT: END

# AUTOSORT: START
packages_apt=(
  # ranger
  tmux
  tree
  zsh
)
# AUTOSORT: END

detect_distro() {
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
}

select_environment() {
  title="Select environment"
  prompt="Pick an option:"
  options=("base" "desktop/laptop" "server" "quit")

  echo "${title}"
  PS3="${prompt} "
  # shellcheck disable=SC2034
  select opt in "${options[@]}"; do
    # echo "${REPLY}: ${opt}"
    case ${REPLY} in
      1) environment=base && break ;;
      2) environment=desktop && break ;;
      3) environment=server && break ;;
      4) exit ;;
      *) exit ;;
    esac
  done
}

install_yay() {
  sudo pacman -S --needed git base-devel \
    && git clone --depth 1 https://aur.archlinux.org/yay-bin.git /tmp/yay-bin \
    && cd /tmp/yay-bin \
    && makepkg -si
}

setup_packages() {
  if [[ ${DISTRO} == "Arch Linux" ]]; then
    select_environment
    local packages_pacman=("${packages_pacman_base[@]}")
    local packages_aur=("${packages_aur_base[@]}")
    if [[ ${environment} == desktop ]]; then
      packages_pacman+=("${packages_pacman_desktop[@]}")
      packages_aur+=("${packages_aur_desktop[@]}")
    elif [[ ${environment} == server ]]; then
      packages_pacman+=("${packages_pacman_server[@]}")
      packages_aur+=("${packages_aur_server[@]}")
    fi
    sudo pacman -Syu
    sudo pacman -S --needed "${packages_pacman[@]}"
    command -v yay > /dev/null || install_yay
    yay -Sy --needed "${packages_aur[@]}"
  elif [[ ${DISTRO} == "Fedora Linux" ]]; then
    sudo dnf check-update
    sudo dnf install -y "${packages_dnf[@]}"
  elif [[ ${DISTRO} == "Ubuntu" ]]; then
    command -v nala &> /dev/null && apt=nala || apt=apt
    sudo "${apt}" update
    sudo "${apt}" install -y "${packages_apt[@]}"
  fi
}

if [[ $1 == "yay" ]]; then
  install_yay
  exit
fi

main() {
  detect_distro
  setup_packages
}

sudo -v && main
