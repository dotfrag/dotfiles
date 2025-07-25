# -------------------------------------------------------------------- FUNCTIONS
# yazi
f() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  command rm -f -- "$tmp"
}

# change working dir in shell to last dir in lf on exit
lfd() {
  cd "$(command lf -print-last-dir "$@")"
}

# copy file and cd to destination directory
cpcd() {
  if ((ARGC != 2)); then
    printf 'usage: cpcd <file> <destination>\n'
    return 1
  fi
  if [[ ! -e $1 ]]; then
    printf "error: file $1 doesn't exist\n"
    return 1
  fi
  cp -vi "$1" "$2"
  if [[ -d $2 ]]; then
    builtin cd "$2"
  else
    builtin cd "$(dirname "$2")"
  fi
}

# move file and cd to destination directory
mvcd() {
  if ((ARGC != 2)); then
    printf 'usage: mvcd <file> <destination>\n'
    return 1
  fi
  if [[ ! -e $1 ]]; then
    printf "error: file $1 doesn't exist\n"
    return 1
  fi
  mv -vi "$1" "$2"
  if [[ -d $2 ]]; then
    builtin cd "$2"
  else
    builtin cd "$(dirname "$2")"
  fi
}

# extract archive to subdirectory
x() {
  if ((ARGC < 1)); then
    echo "usage: x[rm] <file..>"
    return 1
  fi
  for f in "$@"; do
    if [[ ! -e $f ]]; then
      echo "error: file ${f} doesn't exist"
      return 1
    fi
    case "$f" in
      *.deb) mkdir "${f%.*}" && ar x "$f" --output "${f%.*}" ;;
      *.tar) mkdir "${f%.*.*}" && tar xvf "$f" -C "${f%.*.*}" ;;
      *.tar.bz | *.tar.bz2) mkdir "${f%.*.*}" && tar xjvf "$f" -C "${f%.*.*}" ;;
      *.tar.gz) mkdir "${f%.*.*}" && tar xzvf "$f" -C "${f%.*.*}" ;;
      *.tar.xz) mkdir "${f%.*.*}" && tar xJvf "$f" -C "${f%.*.*}" ;;
      *.tbz | *.tbz2) mkdir "${f%.*}" && tar xjvf "$f" -C "${f%.*}" ;;
      *.tgz) mkdir "${f%.*}" && tar xzvf "$f" -C "${f%.*}" ;;
      *.txz) mkdir "${f%.*}" && tar xJvf "$f" -C "${f%.*}" ;;
      *.7z) 7zx "$f" -o "${f%.*}" ;;
      *.rar) unrar x "$f" "${f%.*}" ;;
      *.xz) unxz "$f" ;;
      *.zip) unzip "$f" -d "${f%.*}" ;;
      *.zst) zstd -d "$f" --output-dir-mirror "${f%.*}" ;;
      *)
        echo 'archive format not supported'
        return 1
        ;;
    esac
  done
}
xrm() {
  for f in "$@"; do
    x "$f" && rm "$f"
  done
}

# yank to clipboard
yank() {
  if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    wl-copy --trim-newline
  else
    xclip -r -selection primary -filter | xclip -r -selection clipboard
  fi
}

# print and yank to clipboard
xyank() {
  if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    tee /dev/tty | wl-copy --trim-newline
  else
    tee /dev/tty | xclip -r -selection primary -filter | xclip -r -selection clipboard
  fi
}

# paste from clipboard
put() {
  if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    local type
    type=$(wl-paste -l | rg image)
    if [[ $type == image* ]]; then
      filename=$(date +%Y-%m-%d_%T).png
      wl-paste -t "$type" > "$filename" \
        && echo "Created image file $filename"
      [[ -v KITTY_WINDOW_ID ]] && kitten icat "$filename"
    else
      wl-paste
    fi
  else
    xclip -o #-selection clipboard
  fi
}

# update dotfiles list
update-dots() {
  local dots="${XDG_DATA_HOME:-${HOME}/.local/share}/dots"
  git -C "${HOME}/repos/dotfiles" ls-files | rg -v 'ttf$' | while read line; do realpath "${HOME}/repos/dotfiles/${line}"; done > "${dots}"
  git -C "${HOME}/repos/dotfiles-private" ls-files | while read line; do realpath "${HOME}/repos/dotfiles-private/${line}"; done >> "${dots}"
  sort -o "${dots}" -u "${dots}"
}

# update grml zsh config files
update-grml-zshrc() {
  local zshrc=${ZDOTDIR:-${HOME}}/.zshrc
  local zshrcskel=${ZDOTDIR:-${HOME}}/.zshrc.skel
  wget -nv -O "${zshrc}.tmp" https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
  wget -nv -O "${zshrcskel}.tmp" https://git.grml.org/f/grml-etc-core/etc/skel/.zshrc
  if [[ -s ${zshrc} ]] && [[ -s ${zshrcskel} ]]; then
    command mv -v "${zshrc}.tmp" "${zshrc}"
    command mv -v "${zshrcskel}.tmp" "${zshrcskel}"
  else
    echo "Something went wrong."
  fi
}

# history grep
hgrep() {
  fc -Dlim "*$@*" 1
}

# man pages search
mans() {
  man "$1" | less -G +/"$2"
}

# zsh man page search
manzsh() {
  man zshall | less -G +/"$1"
}

# touch executable and edit
touchx() {
  if ! [[ -e $1 ]]; then
    case "$1" in
      *.py) shebang="#!/usr/bin/env python3" ;;
      *) shebang="#!/bin/bash" ;;
    esac
    echo -e "${shebang}\n\n" > "$1"
  fi
  chmod +x "$1" > /dev/null
  ${EDITOR} + "$1"
}

# create temporary executable
sht() {
  cdt
  touchx test
}

# backup/restore file
bak() {
  while ((${#argv} > 0)); do
    mv "$1" "$1.bak"
    shift
  done
}
ubak() {
  while ((${#argv} > 0)); do
    mv "$1" "${1%.bak}"
    shift
  done
}

# capture the output of a command so it can be retrieved with ret
cap() {
  tee /tmp/capture.out
}
ret() {
  cat /tmp/capture.out
}

# ripgrep | less
rgl() {
  rg --pretty "$@" | less -RFX
}

# launch app and exit
launch() {
  nohup "$@" > /dev/null 2>&1 &
  disown && exit
}

# bat hightlight help messages
help() {
  "$@" --help 2>&1 | bat --plain --language=help
}

# switching shell safely and efficiently? http://www.zsh.org/mla/workers/2001/msg02410.html
bash() {
  NO_SWITCH="yes" command bash "$@"
}
restart() {
  exec $SHELL $SHELL_ARGS "$@"
}

# open project in vscode
vs() {
  local projects=${XDG_DATA_HOME:-${HOME}/.local/share}/projects
  cat "${projects}" | fzf --multi --bind 'enter:become(code {+})'
}

# shfmt format all files
shellfmt() {
  if [[ -n $1 ]]; then
    shfmt --write "$1"
  else
    rg -l '^#!/bin/bash' | xargs -P "$(nproc)" shfmt --write
  fi
}

# shellcheck fix all fixable issues
shellfix() {
  if [[ -n $1 ]]; then
    shellcheck -f diff "$1" | git apply --allow-empty
  else
    rg -l '^#!/bin/bash' | xargs -P "$(nproc)" -I{} zsh -c 'shellcheck -f diff {} | git apply --allow-empty -q'
  fi
}

# create or source venv
venv() {
  local venv_dir=.venv
  if [[ -v VIRTUAL_ENV ]]; then
    deactivate
    return
  fi
  if ! [[ -d ${venv_dir} ]]; then
    $(command -v python3 || command -v python) -m venv ${venv_dir}
  fi
  source ${venv_dir}/bin/activate
}

# process tree
ptree() {
  if [[ $# -gt 0 ]]; then
    ps --no-headers "$@"
    for p in "$@"; do
      ptree $(cat "/proc/${p}/task/${p}/children")
    done
  fi
}

# process search
pss() {
  ps -ef | sed -n "1p; /[${1:0:1}]${1:1}/p"
}

# update node
fnmup() {
  current_version=$(fnm ls | rg default | awk '{print $2}')
  fnm install --lts
  new_version=$(fnm ls | rg default | awk '{print $2}')
  if [[ ${current_version} != "${new_version}" ]]; then
    fnm uninstall "${current_version}"
  fi
}

# update pip packages inside venv
pipup() {
  [[ -v VIRTUAL_ENV ]] || return 1
  pip list | awk '{print $1}' | tail +3 | xargs pip install -U
}

# sort json keys using jq
jqsort() {
  jq 'to_entries|sort|from_entries' "$1" > "$1".tmp && mv -f "$1".tmp "$1"
}

# disable saving shell history to histfile and atuin
# https://unix.stackexchange.com/a/692914
# https://github.com/atuinsh/atuin/issues/517#issuecomment-1271702597
# NOTE: because the HISTFILE is unset, this will also discard (not save) the
# commands of the current session to the history file, but atuin will register
# all commands up to and including incognito
incognito() {
	unset HISTFILE
	add-zsh-hook -d precmd _atuin_precmd
	add-zsh-hook -d preexec _atuin_preexec
}

# repeat command, similar to watch, but often more convenient
whl() {
  re='^[0-9]+$'
  if [[ $1 =~ $re ]]; then
    interval=$1
    shift
  fi
  while true; do
    "$@"
    sleep "${interval:-2}"
  done
}

# load tmuxp sessions
tmuxp() {
  local session
  command -v tmuxp > /dev/null || return
  session=$(fd . ~/.config/tmuxp -x basename {} .yml | sort | fzf)
  if [[ -n ${session} ]]; then
    command tmuxp load "${session}"
  fi
}

# watch ls
wls() {
  watch -n "${1:-2}" -c eza --color=always -la --group-directories-first
}
wlsm() {
  watch -n "${1:-2}" -c eza --color=always -la --group-directories-first --sort modified
}
