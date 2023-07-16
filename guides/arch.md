# Arch

Reference of one-off stuff that I will forget.

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
sudo systemctl enable --now paccache.timer
```

<https://wiki.archlinux.org/title/pacman#Cleaning_the_package_cache>

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
