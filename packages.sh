# shellcheck shell=bash

# Note: For ttf-nerd-fonts-symbols-mono, use the "Symbols Nerd Font Mono" family
# in your font config.
#
# Symlink /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf to
# /etc/fonts/conf.d/, or see `man 5 fonts-conf` for other options.

packages_pacman=(
  7zip
  base-devel
  bat
  bitwarden
  brightnessctl
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
  gammastep
  git
  git-delta
  git-filter-repo
  git-zsh-completion
  github-cli
  glow
  gnome-keyring
  imagemagick
  imv
  inter-font
  jq
  just
  kitty
  kitty-shell-integration
  kitty-terminfo
  lazygit
  lf
  libqalculate
  lm_sensors
  man-db
  man-pages
  mdcat
  mediainfo
  miniserve
  mpv
  mtr
  nemo
  neovim
  noto-fonts
  noto-fonts-emoji
  obsidian
  pacman-contrib
  papirus-icon-theme
  parallel
  plocate
  procs
  qalculate-gtk
  reflector
  ripgrep
  rofi
  rsync
  seahorse
  skim
  starship
  tealdeer
  thermald
  tmux
  tree
  ttc-iosevka-ss08
  ttf-fira-code
  ttf-jetbrains-mono
  ttf-nerd-fonts-symbols-common
  ttf-nerd-fonts-symbols-mono
  ttf-opensans
  unarchiver
  unzip
  vim
  wget
  wl-clipboard
  yazi
  yt-dlp
  zip
  zoxide
  zsh
  zstd
)

packages_aur=(
  # google-chrome
  catppuccin-cursors-macchiato
  catppuccin-gtk-theme-macchiato
  grimshot-bin-sway
  lazydocker
  networkmanager-dmenu-git
  otf-geist
  otf-geist-mono
  sublime-text-4
  swaync
  thorium-browser-bin
  topgrade-bin
  ttf-merriweather
  viddy-bin
  visual-studio-code-bin
)

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
  ranger
  tmux
  tree
  zsh
)

detect_distro() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO=${NAME}
  elif command -v lsb_release &>/dev/null; then
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
  if [[ "${DISTRO}" = "Arch Linux" ]]; then
    sudo pacman -Syu
    sudo pacman -S --needed "${packages_pacman[@]}"
    if ! command -v yay &>/dev/null; then
      git clone --depth 1 https://aur.archlinux.org/yay-bin.git /tmp/yay &&
        cd /tmp/yay &&
        makepkg -si &&
        command rm -rf /tmp/yay
    fi
    yay -S --needed "${packages_aur[@]}"
  elif [[ "${DISTRO}" = "Fedora Linux" ]]; then
    sudo dnf check-update
    sudo dnf install -y "${packages_dnf[@]}"
  elif [[ "${DISTRO}" = "Ubuntu" ]]; then
    command -v nala &>/dev/null && apt=nala || apt=apt
    sudo "${apt}" update
    sudo "${apt}" install -y "${packages_apt[@]}"
  fi
}

main() {
  detect_distro
  setup_packages
}

sudo -v && main
