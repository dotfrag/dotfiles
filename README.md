Dotfiles
========

- [kitty](#kitty)
- [Fonts](#fonts)
- [Gnome](#gnome)
- [Fedora](#fedora)
  - [i3-gaps](#i3-gaps)
  - [polybar](#polybar)
  - [rofi](#rofi)
  - [betterlockscreen](#betterlockscreen)
  - [picom](#picom)
- [Ubuntu](#ubuntu)
  - [i3-gaps](#i3-gaps-1)
  - [polybar](#polybar-1)
  - [rofi](#rofi-1)
  - [betterlockscreen](#betterlockscreen-1)
  - [picom](#picom-1)

---

## kitty

```
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin && exit
```

```
 \ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
\cp -f ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
\cp -f ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
```

```
 if [ -n "$TERMINFO" ]; then
  sudo mkdir -p /etc/terminfo/x
  sudo install --owner=root --group=root "${TERMINFO}/kitty.termcap" /etc/terminfo/
  sudo install --owner=root --group=root "${TERMINFO}/kitty.terminfo" /etc/terminfo/
  sudo install --owner=root --group=root "${TERMINFO}/x/xterm-kitty" /etc/terminfo/x/
fi
```

```
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator ${HOME}/.local/bin/kitty 1
sudo update-alternatives --config x-terminal-emulator
```

```
sudo update-alternatives --remove x-terminal-emulator ${HOME}/.local/bin/kitty
```

## Fonts

```
 LATEST_RELEASE=$(curl -LsH 'Accept: application/json' https://github.com/be5invis/Iosevka/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
cd /tmp
wget -nc "https://github.com/be5invis/Iosevka/releases/download/${LATEST_VERSION}/super-ttc-iosevka-ss08-${LATEST_VERSION//v}.zip"
unzip super-ttc-iosevka-ss08-${LATEST_VERSION//v}.zip
mkdir -p ~/.local/share/fonts
mv -vf /tmp/iosevka-ss08.ttc ~/.local/share/fonts/
fc-cache -rf
```

## Gnome

```
 cd /tmp
wget https://github.com/EliverLara/Nordic/releases/latest/download/Nordic-darker.tar.xz
tar xvf Nordic-darker.tar.xz
mkdir -p ~/.local/share/themes
rm -rf ~/.local/share/themes/Nordic-darker
mv -v Nordic-darker ~/.local/share/themes/
```

```
 git -C /tmp clone https://github.com/robertovernina/NordArc.git
mkdir -p ~/.local/share/icons
rm -rf ~/.local/share/icons/NordArc-Icons
mv -v /tmp/NordArc/NordArc-Icons ~/.local/share/icons/
```

```
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
```

```
gsettings set org.gnome.desktop.interface gtk-theme "Nordic-darker"
```

```
gsettings set org.gnome.desktop.wm.preferences theme "Nordic-darker"
```

```
gsettings set org.gnome.desktop.interface icon-theme "NordArc-Icons"
```

```
gsettings set org.gnome.desktop.interface monospace-font-name "Iosevka SS08 11"
```

## Fedora

```
sudo dnf groupinstall -y "Development Tools"
```

### i3-gaps

```
sudo dnf copr enable fuhrmann/i3-gaps
sudo dnf install -y i3-gaps
```

### polybar

```
sudo dnf install -y polybar
```

### rofi

```
 sudo dnf -y install xcb-util-wm-devel xcb-util-cursor-devel pango-devel startup-notification-devel gdk-pixbuf2-devel check-devel
LATEST_RELEASE=$(curl -LsH 'Accept: application/json' https://github.com/davatorium/rofi/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
cd /tmp
wget -nc "https://github.com/davatorium/rofi/releases/download/${LATEST_VERSION}/rofi-${LATEST_VERSION}.tar.gz"
tar xzvf "rofi-${LATEST_VERSION}.tar.gz"
cd "rofi-${LATEST_VERSION}"
mkdir -p build && cd build
../configure
make
sudo make install
```

### betterlockscreen

```
 sudo dnf install -y autoconf automake cairo-devel fontconfig gcc libev-devel libjpeg-turbo-devel libXinerama libxkbcommon-devel libxkbcommon-x11-devel libXrandr pam-devel pkgconf xcb-util-image-devel xcb-util-xrm-devel
git -C /tmp clone https://github.com/Raymo111/i3lock-color.git
cd /tmp/i3lock-color
git tag -f "git-$(git rev-parse --short HEAD)"
./install-i3lock-color.sh
```

```
 cd /tmp
wget https://github.com/pavanjadhaw/betterlockscreen/archive/refs/heads/main.zip
unzip main.zip
cd betterlockscreen-main/
chmod u+x betterlockscreen
sudo cp betterlockscreen /usr/local/bin/
sudo cp system/betterlockscreen@.service /usr/lib/systemd/system/
systemctl enable betterlockscreen@$USER
```

### picom

```
 sudo dnf install -y dbus-devel gcc git libconfig-devel libdrm-devel libev-devel libX11-devel libX11-xcb libXext-devel libxcb-devel mesa-libGL-devel meson pcre-devel pixman-devel uthash-devel xcb-util-image-devel xcb-util-renderutil-devel xorg-x11-proto-devel
git -C /tmp clone https://github.com/ibhagwan/picom
cd /tmp/picom
git submodule update --init --recursive
meson --buildtype=release . build
sudo ninja -C build install
```

## Ubuntu

```
sudo apt install -y nala
```

### i3-gaps

```
 sudo nala install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev
git -C /tmp clone https://www.github.com/Airblader/i3 i3-gaps
cd /tmp/i3-gaps
mkdir -p build && cd build
meson ..
sudo meson install
```

### polybar

```
 sudo nala install -y build-essential git cmake cmake-data pkg-config python3-sphinx python3-packaging libuv1-dev libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev
LATEST_RELEASE=$(curl -LsH 'Accept: application/json' https://github.com/polybar/polybar/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
cd /tmp
wget -nc "https://github.com/polybar/polybar/releases/download/${LATEST_VERSION}/polybar-${LATEST_VERSION}.tar.gz"
tar xzvf "polybar-${LATEST_VERSION}.tar.gz"
cd "polybar-${LATEST_VERSION}"
mkdir -p build && cd build
cmake ..
make -j$(nproc)
sudo make install
```

### rofi

```
 LATEST_RELEASE=$(curl -LsH 'Accept: application/json' https://github.com/davatorium/rofi/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
cd /tmp
wget -nc "https://github.com/davatorium/rofi/releases/download/${LATEST_VERSION}/rofi-${LATEST_VERSION}.tar.gz"
tar xzvf "rofi-${LATEST_VERSION}.tar.gz"
cd "rofi-${LATEST_VERSION}"
mkdir -p build && cd build
../configure
make
sudo make install
```

### betterlockscreen

```
 sudo nala install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
git -C /tmp clone https://github.com/Raymo111/i3lock-color.git
cd /tmp/i3lock-color
git tag -f "git-$(git rev-parse --short HEAD)"
./install-i3lock-color.sh

cd /tmp
wget https://github.com/pavanjadhaw/betterlockscreen/archive/refs/heads/main.zip
unzip main.zip
cd betterlockscreen-main/
chmod u+x betterlockscreen
sudo cp betterlockscreen /usr/local/bin/
sudo cp system/betterlockscreen@.service /usr/lib/systemd/system/
systemctl enable betterlockscreen@$USER
```

### picom

```
 sudo nala install -y libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson
git -C /tmp clone https://github.com/ibhagwan/picom
cd /tmp/picom
git submodule update --init --recursive
meson --buildtype=release . build
sudo ninja -C build install
```
