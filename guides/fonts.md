# Fonts

```shell
LATEST_RELEASE=$(curl -sLH 'Accept: application/json' https://github.com/be5invis/Iosevka/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
cd /tmp
wget -nc "https://github.com/be5invis/Iosevka/releases/download/${LATEST_VERSION}/super-ttc-iosevka-ss08-${LATEST_VERSION//v}.zip"
unzip super-ttc-iosevka-ss08-${LATEST_VERSION//v}.zip
mkdir -p ~/.local/share/fonts
mv -vf /tmp/iosevka-ss08.ttc ~/.local/share/fonts/
fc-cache -rf
```
