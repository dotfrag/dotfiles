#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
GIT_ROOT=$(git -C "${SCRIPT_DIR}" rev-parse --show-toplevel)
TARGET=${GIT_ROOT}/config/yazi/yazi.toml

cat << EOF >> "${TARGET}"

[plugin]
preloaders = []
previewers = [
  { url = "*/", run = "folder" },
  { mime = "text/*", run = "code" },
]
EOF
