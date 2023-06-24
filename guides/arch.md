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

## Hosts file

```text
/etc/hosts
```

```text
# Static table lookup for hostnames.
# See hosts(5) for details.

127.0.0.1 localhost
::1       localhost
127.0.0.1 xps
```
