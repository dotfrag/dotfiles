#!/bin/bash

if ! command -v git &>/dev/null; then
  echo "Missing git command. Please install git first."
  exit 1
fi

if [[ ! -d "dotfiles" ]]; then
  git clone https://github.com/dotfrag/dotfiles.git
fi

bash dotfiles/setup.sh
