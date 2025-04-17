#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

output=()
for i in $(git -C "${SCRIPT_DIR}" ls-tree --name-only main | grep -v "install.sh"); do
  output+=("$(ln -vsf "${SCRIPT_DIR}/${i}" "${HOME}/.local/bin/${i}")")
done

printf "%s\n" "${output[@]}" | column -t
