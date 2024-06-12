# Ubuntu

- [nala](#nala)
- [i3-gaps](#i3-gaps)
- [polybar](#polybar)
- [rofi](#rofi)
- [dunst](#dunst)
- [betterlockscreen](#betterlockscreen)
- [picom](#picom)

## nala

```shell
sudo apt install -y nala
```

## i3

```shell
sudo nala install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev
git -C /tmp clone --depth 1 https://github.com/i3/i3
cd /tmp/i3
mkdir -p build && cd build
meson ..
sudo meson install
```

## polybar

```shell
sudo nala install -y build-essential git cmake cmake-data pkg-config python3-sphinx python3-packaging libuv1-dev libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev
LATEST_RELEASE=$(curl -sLH 'Accept: application/json' https://github.com/polybar/polybar/releases/latest)
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

## rofi

```shell
sudo nala install -y bison check flex libgdk-pixbuf-2.0-dev
LATEST_RELEASE=$(curl -sLH 'Accept: application/json' https://github.com/davatorium/rofi/releases/latest)
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

## dunst

```shell
sudo nala install -y libdbus-1-dev libx11-dev libxinerama-dev libxrandr-dev libxss-dev libglib2.0-dev libpango1.0-dev libgtk-3-dev libxdg-basedir-dev
git -C /tmp clone --depth 1 https://github.com/dunst-project/dunst.git
cd /tmp/dunst
make
sudo make WAYLAND=0 install
```

## betterlockscreen

```shell
sudo nala install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
git -C /tmp clone --depth 1 https://github.com/Raymo111/i3lock-color.git
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
sudo systemctl enable betterlockscreen@$USER
```

## picom

```shell
sudo nala install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev
git -C /tmp clone --depth 1 https://github.com/yshui/picom
cd /tmp/picom
meson setup --buildtype=release build
sudo ninja -C build install
```

## nemo

```shell
sudo nala install -y intltool libcinnamon-desktop-dev libexempi-dev libexif-gtk-dev libgail-3-dev libgirepository1.0-dev libgsf-1-dev libxapp-dev libxml2-dev
git -C /tmp clone --depth 1 https://github.com/linuxmint/nemo
cd /tmp/nemo
meson build
sudo ninja -C build install
```
