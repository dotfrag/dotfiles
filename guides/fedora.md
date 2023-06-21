# Fedora

---

- [devtools](#devtools)
- [i3](#i3)
- [polybar](#polybar)
- [rofi](#rofi)
- [dunst](#dunst)
- [betterlockscreen](#betterlockscreen)
- [picom](#picom)

---

## devtools

```shell
sudo dnf groupinstall -y "Development Tools"
```

## i3

```shell
sudo dnf install -y i3
```

## polybar

```shell
sudo dnf install -y polybar
```

## rofi

```shell
sudo dnf install -y rofi
```

## dunst

```shell
sudo dnf install -y dunst
```

## betterlockscreen

```shell
sudo dnf install -y autoconf automake cairo-devel fontconfig gcc libev-devel libjpeg-turbo-devel libXinerama libxkbcommon-devel libxkbcommon-x11-devel libXrandr pam-devel pkgconf xcb-util-image-devel xcb-util-xrm-devel
git -C /tmp clone https://github.com/Raymo111/i3lock-color.git
cd /tmp/i3lock-color
git tag -f "git-$(git rev-parse --short HEAD)"
./install-i3lock-color.sh
```

```shell
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
sudo dnf install -y dbus-devel gcc git libconfig-devel libdrm-devel libev-devel libX11-devel libX11-xcb libXext-devel libxcb-devel mesa-libGL-devel meson pcre-devel pixman-devel uthash-devel xcb-util-image-devel xcb-util-renderutil-devel xorg-x11-proto-devel
git -C /tmp clone https://github.com/ibhagwan/picom
cd /tmp/picom
git submodule update --init --recursive
meson --buildtype=release . build
sudo ninja -C build install
```
