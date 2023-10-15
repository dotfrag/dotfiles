#!/bin/bash

# Globals
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
FONTS_DIR=${HOME}/.local/share/fonts/IosevkaSS08NerdFont
ROOT_DIR=/tmp/iosevka-nerd-font
IN_DIR=/tmp/iosevka-nerd-font/in
OUT_DIR=/tmp/iosevka-nerd-font/out
DOCKER=docker
FILE_LIST=(
  iosevka-ss08-bold.ttf
  iosevka-ss08-bolditalic.ttf
  iosevka-ss08-italic.ttf
  iosevka-ss08-medium.ttf
  iosevka-ss08-mediumitalic.ttf
  iosevka-ss08-regular.ttf
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
  LATEST_RELEASE=$(curl -sLH 'Accept: application/json' https://github.com/be5invis/Iosevka/releases/latest)
  # shellcheck disable=SC2001
  LATEST_VERSION=$(echo "${LATEST_RELEASE}" | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
  if grep -qs "${LATEST_VERSION}" "${SCRIPT_DIR}/version.txt"; then
    echo "Already on the latest version. No need to update."
    exit
  fi
  LATEST_VERSION_URL="https://github.com/be5invis/Iosevka/releases/download/${LATEST_VERSION}/ttf-iosevka-ss08-${LATEST_VERSION//v/}.zip"
}

download_and_extract_font() {
  wget -nc -q --show-progress "${LATEST_VERSION_URL}" -P "${ROOT_DIR}/"
  unzip -u "${ROOT_DIR}/ttf-iosevka-ss08-${LATEST_VERSION/v/}.zip" "${FILE_LIST[@]}" -d "${ROOT_DIR}/"
}

patch_complete() {
  rm -f "${IN_DIR:?}"/* "${OUT_DIR:?}"/*
  cp -t "${IN_DIR}" "${ROOT_DIR}"/*.ttf
  "$DOCKER" run --rm -v "${IN_DIR}:/in" -v "${OUT_DIR}:/out" nerdfonts/patcher --complete
  mv "${OUT_DIR:?}"/*.ttf "${SCRIPT_DIR}/"
}

patch_complete_variable_width_glyphs() {
  rm -f "${IN_DIR:?}"/* "${OUT_DIR:?}"/*
  cp -t "${IN_DIR}" "${ROOT_DIR}"/iosevka-ss08-{regular,medium}.ttf
  "$DOCKER" run --rm -v "${IN_DIR}:/in" -v "${OUT_DIR}:/out" nerdfonts/patcher --complete --variable-width-glyphs
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
  patch_complete
  patch_complete_variable_width_glyphs
  install_fonts
  update_fonts_version
}

if [[ $1 = "install" ]]; then
  install_fonts
  echo "Fonts installed."
  exit
fi

main
