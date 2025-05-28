# kitty

## Install

```shell
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin && exit
```

## Desktop integration

```shell
command ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
command cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
command cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
command sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
command sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
echo 'kitty.desktop' > ~/.config/xdg-terminals.list
```

<https://sw.kovidgoyal.net/kitty/binary/#desktop-integration-on-linux>

## Terminfo

```shell
if [ -n "$TERMINFO" ]; then
  sudo mkdir -p /etc/terminfo/x
  sudo install --owner=root --group=root "${TERMINFO}/kitty.termcap" /etc/terminfo/
  sudo install --owner=root --group=root "${TERMINFO}/kitty.terminfo" /etc/terminfo/
  sudo install --owner=root --group=root "${TERMINFO}/x/xterm-kitty" /etc/terminfo/x/
fi
```

```shell
Defaults env_keep += "TERM TERMINFO"
```

## Update-alternatives

```shell
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator ${HOME}/.local/bin/kitty 1
sudo update-alternatives --config x-terminal-emulator
```

```shell
sudo update-alternatives --remove x-terminal-emulator ${HOME}/.local/bin/kitty
```
