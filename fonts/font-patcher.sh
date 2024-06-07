#!/bin/bash

# Globals
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
FONTS_DIR=${HOME}/.local/share/fonts/IosevkaSS08NerdFont
ROOT_DIR=/tmp/iosevka-nerd-font
IN_DIR=/tmp/iosevka-nerd-font/in
OUT_DIR=/tmp/iosevka-nerd-font/out
DOCKER=docker
FILE_LIST=(
  IosevkaSS08-Bold.ttf
  IosevkaSS08-BoldItalic.ttf
  IosevkaSS08-Italic.ttf
  IosevkaSS08-Medium.ttf
  IosevkaSS08-MediumItalic.ttf
  IosevkaSS08-Regular.ttf
)

init() {
  if command -v docker &>/dev/null; then
    systemctl is-active --quiet docker || systemctl start docker || exit 1
  else
    DOCKER=podman
  fi
  ${DOCKER} image pull nerdfonts/patcher
  mkdir -p "${ROOT_DIR}" "${IN_DIR}" "${OUT_DIR}" "${FONTS_DIR}" >/dev/null || exit 1
}

get_latest_version() {
  LATEST_VERSION=$(curl -sLH 'Accept: application/json' 'https://api.github.com/repos/be5invis/Iosevka/releases/latest' | grep -Po '"tag_name": "\Kv[^"]*')
  LATEST_VERSION_URL="https://github.com/be5invis/Iosevka/releases/download/${LATEST_VERSION}/PkgTTF-IosevkaSS08-${LATEST_VERSION/v/}.zip"
  if grep -qs "${LATEST_VERSION}" "${SCRIPT_DIR}/version.txt"; then
    echo "Already on the latest version. No need to update."
    exit
  fi
}

download_and_extract_font() {
  wget -nc -q --show-progress "${LATEST_VERSION_URL}" -P "${ROOT_DIR}/"
  unzip -u "${ROOT_DIR}/PkgTTF-IosevkaSS08-${LATEST_VERSION/v/}.zip" "${FILE_LIST[@]}" -d "${ROOT_DIR}/"
}

patch_fonts() {
  rm -f "${IN_DIR:?}"/* "${OUT_DIR:?}"/*
  cp -t "${IN_DIR}" "${ROOT_DIR}"/*.ttf
  ${DOCKER} run --rm -v "${IN_DIR}:/in" -v "${OUT_DIR}:/out" nerdfonts/patcher --complete --quiet
  mv "${OUT_DIR:?}"/*.ttf "${SCRIPT_DIR}/"
}

patch_fonts_mono() {
  rm -f "${IN_DIR:?}"/* "${OUT_DIR:?}"/*
  cp -t "${IN_DIR}" "${ROOT_DIR}"/*.ttf
  ${DOCKER} run --rm -v "${IN_DIR}:/in" -v "${OUT_DIR}:/out" nerdfonts/patcher --complete --mono --quiet
  mv "${OUT_DIR:?}"/*.ttf "${SCRIPT_DIR}/"
}

patch_fonts_propo() {
  rm -f "${IN_DIR:?}"/* "${OUT_DIR:?}"/*
  cp -t "${IN_DIR}" "${ROOT_DIR}"/IosevkaSS08-{Regular,Medium}.ttf
  ${DOCKER} run --rm -v "${IN_DIR}:/in" -v "${OUT_DIR}:/out" nerdfonts/patcher --complete --variable-width-glyphs --quiet
  mv "${OUT_DIR:?}"/*.ttf "${SCRIPT_DIR}/"
}

install_fonts() {
  mkdir -p "${FONTS_DIR}"
  rm -f "${FONTS_DIR:?}"/*
  cp "${SCRIPT_DIR}"/*.ttf "${FONTS_DIR}/"
  fc-cache -rf
}

update_fonts_version() {
  echo "${LATEST_VERSION}" >"${SCRIPT_DIR}/version.txt"
}

main() {
  init
  get_latest_version
  download_and_extract_font
  patch_fonts
  # patch_fonts_mono
  # patch_fonts_propo
  install_fonts
  update_fonts_version
}

if [[ $1 = "install" ]]; then
  install_fonts
  echo "Fonts installed."
  exit
fi

main
