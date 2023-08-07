# -------------------------------------------------------------------- FUNCTIONS
# change working dir in shell to last dir in lf on exit
lfd() {
  tmp="$(mktemp)"
  lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp"
    if [ -d "$dir" ]; then
      if [ "$dir" != "$(pwd)" ]; then
        cd "$dir"
      fi
    fi
  fi
}

# copy file and cd to destination directory
cpcd () {
  if (( ARGC != 2 )); then
    printf 'usage: cpcd <file> <destination>\n'
    return 1
  fi
  if [[ ! -e "$1" ]]; then
    printf "error: file $1 doesn't exist\n"
    return 1
  fi
  cp -vi "$1" "$2"
  if [[ -d "$2" ]]; then
    builtin cd "$2"
  else
    builtin cd "$(dirname "$2")"
  fi
}

# move file and cd to destination directory
mvcd () {
  if (( ARGC != 2 )); then
    printf 'usage: mvcd <file> <destination>\n'
    return 1
  fi
  if [[ ! -e "$1" ]]; then
    printf "error: file $1 doesn't exist\n"
    return 1
  fi
  mv -vi "$1" "$2"
  if [[ -d "$2" ]]; then
    builtin cd "$2"
  else
    builtin cd "$(dirname "$2")"
  fi
}

# extract archive to subdirectory
x() {
  if (( ARGC != 1 )); then
    printf 'usage: x <file>\n'
    return 1
  fi
  if [[ ! -e "$1" ]]; then
    printf "error: file $1 doesn't exist\n"
    return 1
  fi
  case "$1" in
    *.tar.bz|*.tar.bz2) mkdir "${1%.*.*}" && tar xjvf "$1" -C "${1%.*.*}" ;;
    *.tar.gz)           mkdir "${1%.*.*}" && tar xzvf "$1" -C "${1%.*.*}" ;;
    *.tar.xz)           mkdir "${1%.*.*}" && tar xJvf "$1" -C "${1%.*.*}" ;;
    *.tbz|*.tbz2)       mkdir "${1%.*}"   && tar xjvf "$1" -C "${1%.*}"   ;;
    *.tgz)              mkdir "${1%.*}"   && tar xzvf "$1" -C "${1%.*}"   ;;
    *.txz)              mkdir "${1%.*}"   && tar xJvf "$1" -C "${1%.*}"   ;;
    *.7z) 7zx"$1" -o"${1%.*}" ;;
    *.rar) unrar x"$1" "${1%.*}" ;;
    *.zip) unzip "$1" -d "${1%.*}" ;;
    *) printf 'archive format not supported\n' ;;
  esac
}

# copy to clipboard
copy() {
  if [[ "$XDG_SESSION_TYPE" = "wayland" ]]; then
    wl-copy --trim-newline
  else
    xclip -r -selection primary -filter | xclip -r -selection clipboard
  fi
}

update-dots() {
  local dots="${XDG_STATE_HOME:-${HOME}/.local/state}/dots"
  git -C "${HOME}/repos/dotfiles" ls-files | rg -v 'ttf$' | while read line; do realpath "${HOME}/repos/dotfiles/${line}"; done >"${dots}"
  git -C "${HOME}/repos/dotfiles-private" ls-files | while read line; do realpath "${HOME}/repos/dotfiles-private/${line}"; done >>"${dots}"
  sort -o "${dots}" -u "${dots}"
}

# history grep
hgrep() {
  fc -Dlim "*$@*" 1
}

# man pages search
mans() {
  man --pager="less -G -p '^\s+$2'" "$1"
}

# touch executable and edit
touchx() {
  if ! [[ -e "$1" ]]; then
    echo -e "#!/bin/bash\n\n" > "$1"
  fi
  chmod +x "$1" >/dev/null
  $EDITOR + "$1"
}

# backup/restore file
bak() {
  mv -v "$1" "$1.bak"
}
ubak() {
  mv -v "$1" "${1%.bak}"
}

# ripgrep | less
rgl() {
  rg --pretty "$@" | less -RFX
}

# launch app and exit
launch() {
  nohup "$@" >/dev/null 2>/dev/null & disown && exit
}

# bat hightlight help messages
help() {
    "$@" --help 2>&1 | bat --plain --language=help
}

# switching shell safely and efficiently? http://www.zsh.org/mla/workers/2001/msg02410.html
bash() {
   NO_SWITCH="yes" command bash "$@"
}
restart () {
   exec $SHELL $SHELL_ARGS "$@"
}
