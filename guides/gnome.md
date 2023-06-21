# Gnome

```shell
cd /tmp
wget https://github.com/EliverLara/Nordic/releases/latest/download/Nordic-darker.tar.xz
tar xvf Nordic-darker.tar.xz
mkdir -p ~/.local/share/themes
rm -rf ~/.local/share/themes/Nordic-darker
mv -v Nordic-darker ~/.local/share/themes/
```

```shell
git -C /tmp clone https://github.com/robertovernina/NordArc.git
mkdir -p ~/.local/share/icons
rm -rf ~/.local/share/icons/NordArc-Icons
mv -v /tmp/NordArc/NordArc-Icons ~/.local/share/icons/
```

```shell
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
```

```shell
gsettings set org.gnome.desktop.interface gtk-theme "Nordic-darker"
```

```shell
gsettings set org.gnome.desktop.wm.preferences theme "Nordic-darker"
```

```shell
gsettings set org.gnome.desktop.interface icon-theme "NordArc-Icons"
```

```shell
gsettings set org.gnome.desktop.interface monospace-font-name "Iosevka SS08 11"
```
