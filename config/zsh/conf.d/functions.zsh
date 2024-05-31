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
mvcd() {
  if ((ARGC != 2)); then
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
  if ((ARGC < 1)); then
    echo "usage: x[rm] <file..>"
    return 1
  fi
  for f in "$@"; do
    if [[ ! -e "$f" ]]; then
      echo "error: file ${f} doesn't exist"
      return 1
    fi
  done
  for f in "$@"; do
    case "$f" in
      *.tar.bz|*.tar.bz2) mkdir "${f%.*.*}" && tar xjvf "$f" -C "${f%.*.*}" ;;
      *.tar.gz)           mkdir "${f%.*.*}" && tar xzvf "$f" -C "${f%.*.*}" ;;
      *.tar.xz)           mkdir "${f%.*.*}" && tar xJvf "$f" -C "${f%.*.*}" ;;
      *.tbz|*.tbz2)       mkdir "${f%.*}"   && tar xjvf "$f" -C "${f%.*}"   ;;
      *.tgz)              mkdir "${f%.*}"   && tar xzvf "$f" -C "${f%.*}"   ;;
      *.txz)              mkdir "${f%.*}"   && tar xJvf "$f" -C "${f%.*}"   ;;
      *.7z) 7zx"$f" -o"${f%.*}" ;;
      *.rar) unrar x"$f" "${f%.*}" ;;
      *.zip) unzip "$f" -d "${f%.*}" ;;
      *.zst) zstd -d "$f" --output-dir-mirror "${f%.*}" ;;
      *) echo 'archive format not supported'; return 1 ;;
    esac
  done
}
xrm() {
  x "$@" && rm "$@"
}

# copy to clipboard
copy() {
  if [[ "$XDG_SESSION_TYPE" = "wayland" ]]; then
    wl-copy --trim-newline
  else
    xclip -r -selection primary -filter | xclip -r -selection clipboard
  fi
}

# update dotfiles list
update-dots() {
  local dots="${XDG_DATA_HOME:-${HOME}/.local/share}/dots"
  git -C "${HOME}/repos/dotfiles" ls-files | rg -v 'ttf$' | while read line; do realpath "${HOME}/repos/dotfiles/${line}"; done >"${dots}"
  git -C "${HOME}/repos/dotfiles-private" ls-files | while read line; do realpath "${HOME}/repos/dotfiles-private/${line}"; done >>"${dots}"
  sort -o "${dots}" -u "${dots}"
}

# update grml zsh config files
update-grml-zshrc() {
  wget -nv -O "${ZDOTDIR:-${HOME}}/.zshrc" https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
  wget -nv -O "${ZDOTDIR:-${HOME}}/.zshrc.skel" https://git.grml.org/f/grml-etc-core/etc/skel/.zshrc
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
  man zshall |  less -G +/"$1"
}

# touch executable and edit
touchx() {
  if ! [[ -e "$1" ]]; then
    echo -e "#!/bin/bash\n\n" >"$1"
  fi
  chmod +x "$1" >/dev/null
  $EDITOR + "$1"
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
  nohup "$@" >/dev/null 2>/dev/null &
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

# get latest version of git repo release
get_latest_version() {
  curl -sLH "Accept: application/json" "https://api.github.com/repos/$1/releases/latest" | grep -Po '"tag_name": "\Kv[^"]*'
}

# open project in vscode
vs() {
  local projects=${XDG_DATA_HOME:-${HOME}/.local/share}/projects
  cat "${projects}" | fzf --multi --bind 'enter:become(code {+})'
}

# shellcheck fix all fixable issues
shellfix() {
  if [[ -n $1 ]]; then
    shellcheck -f diff "$1" | git apply
  else
    rg -l '^#!/bin/bash' |
      xargs -P "$(nproc)" -I{} zsh -c \
        'shellcheck -f diff {} | git apply -q'
  fi
}

# create and source venv
venv() {
  if ! [[ -d venv ]]; then
    python -m venv venv
  fi
  source venv/bin/activate
}

# sync github fork
sync-fork() {
  branch=$(git_main_branch)
  git fetch upstream &&
    git checkout "${branch}" &&
    git merge "upstream/${branch}"
}
