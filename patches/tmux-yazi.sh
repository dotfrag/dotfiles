#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
GIT_ROOT=$(git -C "${SCRIPT_DIR}" rev-parse --show-toplevel)
TARGET=${GIT_ROOT}/config/tmux/tmux.conf

sed -i -e 's/M-\[/M--/' -e 's/M-\]/M-=/' "${TARGET}"
