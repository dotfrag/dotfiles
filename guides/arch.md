# Arch

Reference of one-off stuff that I will forget.

- [Gnome Keyring](#gnome-keyring)
- [Mounting NTFS with udisks](#mounting-ntfs-with-udisks)
- [thermald](#thermald)
- [Hosts file](#hosts-file)
- [Lid action](#lid-action)
- [Package cache](#package-cache)
- [Reflector](#reflector)
- [GPG](#gpg)

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

## Mounting NTFS with udisks

```shell
sudo pacman -S --needed udisks2
```

```text
/etc/udisks2/mount_options.conf
```

```ini
[defaults]
ntfs_defaults=uid=$UID,gid=$GID,prealloc
```

<https://wiki.archlinux.org/title/NTFS#udisks_support>

## thermald

```shell
sudo pacman -S --needed thermald
```

```shell
sudo mkdir -p /etc/systemd/system/thermald.service.d
sudo bash -c '{
echo "[Service]"
echo "StandardOutput=null"
} > /etc/systemd/system/thermald.service.d/nostdout.conf'
```

```shell
systemctl enable --now thermald
```

<https://www.reddit.com/r/archlinux/comments/3okrhl/thermald_anyone/>

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

```text
/etc/systemd/logind.conf
```

```text
HandleLidSwitch=ignore
```

```shell
systemctl kill -s HUP systemd-logind
```

<https://wiki.archlinux.org/title/Power_management#ACPI_events>

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

```text
/etc/xdg/reflector/reflector.conf
```

```text
--save /etc/pacman.d/mirrorlist
--protocol https
--latest 20
--sort rate
```

```shell
sudo systemctl enable --now reflector.timer
```

<https://wiki.archlinux.org/title/reflector>

## GPG

```shell
mkdir -p $GNUPGHOME
chown -R $(whoami) $GNUPGHOME
chmod 600 $GNUPGHOME/*
chmod 700 $GNUPGHOME
```

<https://wiki.archlinux.org/title/GnuPG#Keyblock_resource_does_not_exist>, <https://gist.github.com/oseme-techguy/bae2e309c084d93b75a9b25f49718f85>
