#!/bin/bash
#
# curl -fsSL https://raw.githubusercontent.com/dotfrag/dotfiles/refs/heads/main/install.sh | bash

REPOS_DIR=${HOME}/repos
DOTFILES_DIR=${REPOS_DIR}/dotfiles

if ! command -v git > /dev/null; then
  echo "Missing git command. Please install git first."
  exit 1
fi

if [[ ! -d ${DOTFILES_DIR} ]]; then
  mkdir -p "${REPOS_DIR}"
  git -C "${REPOS_DIR}" clone https://github.com/dotfrag/dotfiles.git
fi

bash "${DOTFILES_DIR}/setup.sh"

if [[ ${SHELL} != *zsh ]]; then
  chsh -s /bin/zsh
fi
