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

## i3-gaps

```shell
sudo nala install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev
git -C /tmp clone https://www.github.com/Airblader/i3 i3-gaps
cd /tmp/i3-gaps
mkdir -p build && cd build
meson ..
sudo meson install
```

## polybar

```shell
sudo nala install -y build-essential git cmake cmake-data pkg-config python3-sphinx python3-packaging libuv1-dev libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev
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
cd /tmp
git clone https://github.com/dunst-project/dunst.git
cd dunst
make
sudo make WAYLAND=0 install
```

## betterlockscreen

```shell
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

## picom

```shell
sudo nala install -y libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson
git -C /tmp clone https://github.com/ibhagwan/picom
cd /tmp/picom
git submodule update --init --recursive
meson --buildtype=release . build
sudo ninja -C build install
```