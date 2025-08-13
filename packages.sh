#!/bin/bash

# Note: For ttf-nerd-fonts-symbols-mono, use the "Symbols Nerd Font Mono" family
# in your font config.
#
# Symlink /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf to
# /etc/fonts/conf.d/, or see `man 5 fonts-conf` for other options.

packages_pacman_base=(
  7zip
  aria2
  at
  base-devel
  bat
  btop
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
  git-zsh-completion
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
  zip
  zoxide
  zsh
  zstd
)

packages_pacman_desktop=(
  bitwarden
  brightnessctl
  gammastep
  github-cli
  gnome-keyring
  go
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
  plocate
  qalculate-gtk
  qpdf
  rofi
  rofimoji
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

packages_pacman_server=(
  sysstat
)

packages_aur_base=(
  czkawka-cli-bin
  lazydocker-bin
  topgrade-bin
  viddy-bin
)

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

packages_aur_server=()

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

packages_apt=(
  # ranger
  tmux
  tree
  zsh
)

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

setup_packages() {
  if [[ ${DISTRO} == "Arch Linux" ]]; then
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
    if ! command -v yay &> /dev/null; then
      sudo pacman -S --needed git base-devel
      git clone --depth 1 https://aur.archlinux.org/yay-bin.git /tmp/yay-bin \
        && cd /tmp/yay-bin \
        && makepkg -si
    fi
    yay -S --needed "${packages_aur[@]}"
  elif [[ ${DISTRO} == "Fedora Linux" ]]; then
    sudo dnf check-update
    sudo dnf install -y "${packages_dnf[@]}"
  elif [[ ${DISTRO} == "Ubuntu" ]]; then
    command -v nala &> /dev/null && apt=nala || apt=apt
    sudo "${apt}" update
    sudo "${apt}" install -y "${packages_apt[@]}"
  fi
}

main() {
  detect_distro
  setup_packages
}

title="Select environment"
prompt="Pick an option:"
options=("base" "desktop" "server" "quit")

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

sudo -v && main
