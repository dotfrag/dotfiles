#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
FONTS_DIR=${HOME}/.local/share/fonts/Iosevka_Nerd_Font
ROOT_DIR=/tmp/iosevka-nerd-font
IN_DIR=/tmp/iosevka-nerd-font/in
OUT_DIR=/tmp/iosevka-nerd-font/out

systemctl is-active --quiet docker || systemctl start docker || exit 1
mkdir "${ROOT_DIR}" "${IN_DIR}" "${OUT_DIR}" "${FONTS_DIR}" 2>/dev/null

LATEST_RELEASE=$(curl -sLH 'Accept: application/json' https://github.com/be5invis/Iosevka/releases/latest)
LATEST_VERSION=$(echo "${LATEST_RELEASE}" | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')

wget -nc "https://github.com/be5invis/Iosevka/releases/download/${LATEST_VERSION}/ttf-iosevka-ss08-${LATEST_VERSION//v/}.zip" -P "${ROOT_DIR}/"
unzip -u "${ROOT_DIR}/ttf-iosevka-ss08-${LATEST_VERSION/v/}.zip" -d "${ROOT_DIR}/"

rm -f "${IN_DIR:?}"/* "${OUT_DIR:?}"/*
cp -t "${IN_DIR}" "${ROOT_DIR}"/iosevka-ss08-{medium,mediumitalic,bold,bolditalic}.ttf
docker run --rm -v "${IN_DIR}:/in" -v "${OUT_DIR}:/out" nerdfonts/patcher --complete
mv "${OUT_DIR:?}"/*.ttf "${SCRIPT_DIR}/"

rm -f "${IN_DIR:?}"/* "${OUT_DIR:?}"/*
cp -t "${IN_DIR}" "${ROOT_DIR}"/iosevka-ss08-{regular,medium}.ttf
docker run --rm -v "${IN_DIR}:/in" -v "${OUT_DIR}:/out" nerdfonts/patcher --complete --variable-width-glyphs
ttx "${OUT_DIR}"/*.ttf
rm -f "${OUT_DIR:?}"/*.ttf

while read -r file; do
  new_file=${file/Iosevka/IosevkaVariableWidth}
  mv "${file}" "${new_file}"
  sed -i 's/Iosevka SS08/IosevkaVariableWidth SS08/g' "${new_file}"
  sed -i 's/Iosevka\( \?\)Nerd/IosevkaVariableWidth\1Nerd/g' "${new_file}"
  ttx "${new_file}"
done < <(find "${OUT_DIR}" -name '*.ttx')
mv "${OUT_DIR:?}"/*.ttf "${SCRIPT_DIR}/"

find "${SCRIPT_DIR}" -name '*.ttf' -exec cp {} "${FONTS_DIR}/" \;
fc-cache -rf

echo "${LATEST_VERSION}" >"${SCRIPT_DIR}/version.txt"
