# Arch

Reference of one-off stuff that I will forget.

- [Flameshot](#flameshot)
- [Gnome Keyring](#gnome-keyring)
- [GPG](#gpg)
- [Hosts file](#hosts-file)
- [Mounting NTFS with udisks](#mounting-ntfs-with-udisks)
- [Package cache](#package-cache)
- [Pacman Parallel Downloads](#pacman-parallel-downloads)
- [Reflector](#reflector)
- [Sudoers](#sudoers)
- [thermald](#thermald)
- [TTY keymap and font](#tty-keymap-and-font)
- [Misc (situational)](#misc-situational)
  - [Disable webcam](#disable-webcam)
    - [For one session](#for-one-session)
    - [Permanently](#permanently)
  - [Enable GuC / HuC firmware loading](#enable-guc--huc-firmware-loading)
  - [Lid action](#lid-action)
  - [HP EliteDesk no HDMI output](#hp-elitedesk-no-hdmi-output)

## Flameshot

Most likely requires [xdg-portals](https://wiki.archlinux.org/title/XDG_Desktop_Portal) `xdg-desktop-portal-wlr` and `xdg-desktop-portal-gtk`.

Multiple potential fixes for wayland. Currently using [ly](https://codeberg.org/AnErrupTion/ly) with sway:

```text
File: /usr/share/wayland-sessions/sway.desktop
[Desktop Entry]
Name=Sway
Comment=An i3-compatible Wayland compositor
Exec=sway --unsupported-gpu
Type=Application
DesktopNames=sway # important line to add
```

Other solutions:

- [Environment variables](https://wiki.archlinux.org/title/Systemd/User#Environment_variables)
- <https://flameshot.org/docs/guide/wayland-help/>
- <https://github.com/fairyglade/ly/issues/702>

## Gnome Keyring

```shell
sudo pacman -S --needed gnome-keyring
```

Add `auth optional pam_gnome_keyring.so` at the end of the `auth` section and
`session optional pam_gnome_keyring.so auto_start` at the end of the `session` section.

```text
/etc/pam.d/login
```

```text
auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so <<<
account    include      system-local-login
session    include      system-local-login
session    optional     pam_gnome_keyring.so auto_start <<<
password   include      system-local-login
```

Restart and check status:

```shell
busctl --user get-property org.freedesktop.secrets /org/freedesktop/secrets/collection/login org.freedesktop.Secret.Collection Locked
```

<https://wiki.archlinux.org/title/GNOME/Keyring#PAM_step>, <https://www.reddit.com/r/bash/comments/s2n756/comment/hsfnpit/>

## GPG

```shell
mkdir -p $GNUPGHOME
chown -R $(whoami) $GNUPGHOME
chmod 600 $GNUPGHOME/*
chmod 700 $GNUPGHOME
```

After using the above for a long time, I realised I had permission issues with
directories (and specifically `dirmngr`). The following fixed it:

As **root**:

```shell
cd /home/user/.local/share
chmod 700 gnupg
cd gnupg
find . -type d -exec chmod 700 {} \;
find . -type f -exec chmod 600 {} \;
```

<https://wiki.archlinux.org/title/GnuPG#Keyblock_resource_does_not_exist>, <https://gist.github.com/oseme-techguy/bae2e309c084d93b75a9b25f49718f85>

<https://wiki.archlinux.org/title/Network_configuration#localhost_is_resolved_over_the_network>

## Hosts file

```text
/etc/hosts
```

```text
127.0.0.1 localhost
::1       localhost
127.0.0.1 xps
```

## Mounting NTFS with udisks

```shell
sudo pacman -S --needed udisks2
```

```shell
sudo bash -c 'cat <<EOF>/etc/udisks2/mount_options.conf
[defaults]
ntfs_defaults=uid=\$UID,gid=\$GID,prealloc
EOF'
```

<https://wiki.archlinux.org/title/NTFS#udisks_support>

## Package cache

```shell
sudo pacman -S --needed pacman-contrib
```

```shell
sudo systemctl enable --now paccache.timer
```

<https://wiki.archlinux.org/title/pacman#Cleaning_the_package_cache>

## Pacman Parallel Downloads

```shell
sudo sed -i.bak 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
```

## Reflector

```shell
sudo pacman -S --needed reflector
```

```shell
sudo bash -c 'cat <<EOF>/etc/xdg/reflector/reflector.conf
--save /etc/pacman.d/mirrorlist
--protocol https
--latest 50
--number 20
--sort rate
EOF'
```

```shell
sudo systemctl enable reflector.timer
sudo systemctl start reflector
```

<https://wiki.archlinux.org/title/reflector>

## Sudoers

```text
Defaults editor=/usr/bin/vim
Defaults env_keep += "SYSTEMD_EDITOR"
```

## thermald

```shell
sudo pacman -S --needed thermald
```

```shell
sudo mkdir -p /etc/systemd/system/thermald.service.d
sudo bash -c 'cat <<EOF>/etc/systemd/system/thermald.service.d/nostdout.conf
[Service]
StandardOutput=null
EOF'
```

```shell
sudo systemctl enable --now thermald
```

<https://www.reddit.com/r/archlinux/comments/3okrhl/thermald_anyone/>

## TTY keymap and font

```shell
sudo pacman -S --needed terminus-font
```

```shell
sudo mkdir -p /usr/local/share/kbd/keymaps
sudo cp /usr/share/kbd/keymaps/i386/qwerty/us.map.gz /usr/local/share/kbd/keymaps/personal.map.gz
sudo gunzip -f /usr/local/share/kbd/keymaps/personal.map.gz
sudo sed -i 's/Caps_Lock/Escape/g' /usr/local/share/kbd/keymaps/personal.map
```

Add related lines to `/etc/vconsole.conf`:

```text
# KEYMAP=us
KEYMAP=/usr/local/share/kbd/keymaps/personal.map
# FONT=ter-d20b.psf.gz
FONT=ter-v24b.psf.gz
```

## Misc (situational)

### Disable webcam

#### For one session

```shell
sudo modprobe -r uvcvideo
```

If you get "Module uvcvideo is in use", then:

```shell
sudo rmmod -f uvcvideo
```

#### Permanently

```shell
echo 'blacklist uvcvideo' | sudo tee /etc/modprobe.d/blacklist-uvcvideo.conf
```

Regenerate initramfs:

```shell
sudo mkinitcpio -P
```

To enable the webcam for a single session, run:

```shell
sudo modprobe uvcvideo
```

<https://askubuntu.com/questions/166809/how-can-i-disable-my-webcam>
<https://bbs.archlinux.org/viewtopic.php?id=170416>

### Enable GuC / HuC firmware loading

```shell
echo 'options i915 enable_guc=2' | sudo tee /etc/modprobe.d/i915-enable-guc.conf
```

Regenerate initramfs:

```shell
sudo mkinitcpio -P
```

<https://wiki.archlinux.org/title/Intel_graphics#Enable_GuC_/_HuC_firmware_loading>

### Lid action

```shell
sudo mkdir -p /etc/systemd/logind.conf.d
sudo bash -c 'cat <<EOF>/etc/systemd/logind.conf.d/HandleLidSwitch.conf
[Login]
HandleLidSwitch=ignore
EOF'
```

```shell
sudo systemctl kill -s HUP systemd-logind
```

<https://wiki.archlinux.org/title/Power_management#ACPI_events>

### HP EliteDesk no HDMI output

Override `Intel Kabylake HDMI` pins using alsa-tools and `hdajackretask`.

```text
❯ cat /usr/lib/firmware/hda-jack-retask.fw
[codec]
0x8086280b 0x80860101 2

[pincfg]
0x05 0x18560070
0x06 0x18560070
0x07 0x18560070
```

```text
❯ cat /etc/modprobe.d/hda-jack-retask.conf
# This file was added by the program 'hda-jack-retask'.
# If you want to revert the changes made by this program, you can simply erase this file and reboot your computer.
options snd-hda-intel patch=hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw
```

<https://forum.manjaro.org/t/intel-cannon-lake-pch-cavs-conexant-cx20632-no-sound-at-hdmi-or-displayport/133494/2>
