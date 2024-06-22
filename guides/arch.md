# Arch

Reference of one-off stuff that I will forget.

- [Disable webcam](#disable-webcam)
- [Enable GuC / HuC firmware loading](#enable-guc--huc-firmware-loading)
- [Gnome Keyring](#gnome-keyring)
- [GPG](#gpg)
- [Hosts file](#hosts-file)
- [Lid action](#lid-action)
- [Mounting NTFS with udisks](#mounting-ntfs-with-udisks)
- [Package cache](#package-cache)
- [Reflector](#reflector)
- [Sudoers](#sudoers)
- [thermald](#thermald)
- [TTY keymap and font](#tty-keymap-and-font)

## Disable webcam

### For one session

```shell
sudo modprobe -r uvcvideo
```

If you get "Module uvcvideo is in use", then:

```shell
sudo rmmod -f uvcvideo
```

### Permanently

```shell
echo 'blacklist uvcvideo' | sudo tee /etc/modprobe.d/blacklist-uvcvideo.conf
```

Regenerate initramfs:

```shell
sudo mkinitcpio -P
```

<https://askubuntu.com/questions/166809/how-can-i-disable-my-webcam>
<https://bbs.archlinux.org/viewtopic.php?id=170416>

## Enable GuC / HuC firmware loading

```shell
echo 'options i915 enable_guc=2' | sudo tee /etc/modprobe.d/i915-enable-guc.conf
```

Regenerate initramfs:

```shell
sudo mkinitcpio -P
```

<https://wiki.archlinux.org/title/Intel_graphics#Enable_GuC_/_HuC_firmware_loading>

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
auth required pam_securetty.so
auth requisite pam_nologin.so
auth include system-local-login
auth optional pam_gnome_keyring.so
account include system-local-login
session include system-local-login
session optional pam_gnome_keyring.so auto_start
```

<https://wiki.archlinux.org/title/GNOME/Keyring#PAM_step>

## GPG

```shell
mkdir -p $GNUPGHOME
chown -R $(whoami) $GNUPGHOME
chmod 600 $GNUPGHOME/*
chmod 700 $GNUPGHOME
```

<https://wiki.archlinux.org/title/GnuPG#Keyblock_resource_does_not_exist>, <https://gist.github.com/oseme-techguy/bae2e309c084d93b75a9b25f49718f85>

## Hosts file

```text
/etc/hosts
```

```text
127.0.0.1 localhost
::1       localhost
127.0.0.1 xps
```

<https://wiki.archlinux.org/title/Network_configuration#localhost_is_resolved_over_the_network>

## Lid action

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

## Reflector

```shell
sudo pacman -S --needed reflector
```

```shell
sudo bash -c 'cat <<EOF>/etc/xdg/reflector/reflector.conf
--save /etc/pacman.d/mirrorlist
--protocol https
--latest 20
--sort rate
EOF'
```

```shell
sudo systemctl enable --now reflector.timer
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
KEYMAP=/usr/local/share/kbd/keymaps/personal.map
# FONT=ter-d20b.psf.gz
FONT=ter-v24b.psf.gz
```
