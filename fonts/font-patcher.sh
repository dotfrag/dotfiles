#!/bin/bash

# Globals
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
FONTS_DIR=${HOME}/.local/share/fonts/Iosevka_Nerd_Font
ROOT_DIR=/tmp/iosevka-nerd-font
IN_DIR=/tmp/iosevka-nerd-font/in
OUT_DIR=/tmp/iosevka-nerd-font/out

start_docker() {
  systemctl is-active --quiet docker || systemctl start docker || exit 1
}

make_dirs() {
  mkdir -p "${ROOT_DIR}" "${IN_DIR}" "${OUT_DIR}" "${FONTS_DIR}" >/dev/null || exit 1
}

get_latest_version() {
  LATEST_RELEASE=$(curl -sLH 'Accept: application/json' https://github.com/be5invis/Iosevka/releases/latest)
  # shellcheck disable=SC2001
  LATEST_VERSION=$(echo "${LATEST_RELEASE}" | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
  LATEST_VERSION_URL="https://github.com/be5invis/Iosevka/releases/download/${LATEST_VERSION}/ttf-iosevka-ss08-${LATEST_VERSION//v/}.zip"
}

download_and_extract_font() {
  file_list=(
    iosevka-ss08-bold.ttf
    iosevka-ss08-bolditalic.ttf
    iosevka-ss08-medium.ttf
    iosevka-ss08-mediumitalic.ttf
    iosevka-ss08-regular.ttf
  )
  wget -nc -q --show-progress "${LATEST_VERSION_URL}" -P "${ROOT_DIR}/"
  unzip -u "${ROOT_DIR}/ttf-iosevka-ss08-${LATEST_VERSION/v/}.zip" "${file_list[@]}" -d "${ROOT_DIR}/"
}

patch_complete() {
  rm -f "${IN_DIR:?}"/* "${OUT_DIR:?}"/*
  cp -t "${IN_DIR}" "${ROOT_DIR}"/iosevka-ss08-{medium,mediumitalic,bold,bolditalic}.ttf
  docker run --rm -v "${IN_DIR}:/in" -v "${OUT_DIR}:/out" nerdfonts/patcher --complete
  mv "${OUT_DIR:?}"/*.ttf "${SCRIPT_DIR}/"
}

patch_complete_variable_width_glyphs() {
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
}

install_fonts() {
  cp "${SCRIPT_DIR}"/*.ttf "${FONTS_DIR}/"
  fc-cache -rf
  echo "${LATEST_VERSION}" >"${SCRIPT_DIR}/version.txt"
}

main() {
  start_docker
  make_dirs
  get_latest_version
  download_and_extract_font
  patch_complete
  patch_complete_variable_width_glyphs
  install_fonts
}

main