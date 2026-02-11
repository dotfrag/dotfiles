# -------------------------------------------------------------------- FUNCTIONS
# print function with syntax highlighting
func() {
  local f
  while (($# > 0)); do
    if [[ ! -v functions[$1] ]]; then
      echo "Function $1 not found."
      shift
      (($# > 0)) && echo || true
      continue
    fi
    f=$(whence -v "$1" | awk '{print $NF}')
    f=${f/#${HOME}/\~}
    print -P "%F{yellow}${f}%f"
    whence -f "$1" | bat --plain --language zsh
    shift
    (($# > 0)) && echo || true
  done
}

# edit function in editor
edfunc() {
  (($# < 1)) && return 1
  if [[ ! -v functions[$1] ]]; then
    echo "Function $1 not found."
    return 1
  fi
  local file_path line_number pat search
  search="$(
    rg -g '*.zsh' "^$1\(\)" \
      ~/repos/dotfiles{,-private} \
      --line-number --max-count 1 \
      | cut -d':' -f1-2
  )"
  IFS=':' read -r file_path line_number <<< "${search}"
  pat='n?vim'
  # shellcheck disable=SC2154
  if [[ ${EDITOR} =~ ${pat} ]]; then
    ${EDITOR} "${file_path}" +"${line_number}|norm 0zt"
  else
    ${EDITOR} "${file_path}"
  fi
}

# ------------------------------------------------------------------------ SHELL
# switching shell safely and efficiently? http://www.zsh.org/mla/workers/2001/msg02410.html
bash() {
  NO_SWITCH="yes" command bash "$@"
}
restart() {
  exec $SHELL $SHELL_ARGS "$@"
}

# launch app and exit
launch() {
  nohup "$@" > /dev/null 2>&1 &
  disown && exit
}

# bat hightlight help messages
help() {
  (($# < 1)) && return 1
  "$@" --help 2>&1 | bat --plain --language=help
}

# history grep
hgrep() {
  fc -Dlim "*$@*" 1
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

# fix all shellcheckrc files/links using `dotfiles/config/shellcheckrc` as main
fix-shellcheckrc-links() {
  cd "${HOME}" || exit
  all=$(fd -u -d4 -tf shellcheckrc -X realpath)
  main=$(rg '/shellcheckrc' <<< "${all}")
  for i in $(rg -v '/shellcheckrc' <<< "${all}"); do
    ln -vf "${main}" "${i}"
  done | column -t
}

# shfmt format all files
shellfmt() {
  if (($# > 0)); then
    while (($# > 0)); do
      shfmt --write "$1"
      shift
    done
  else
    rg -l '^#!/bin/bash' | xargs -P "$(nproc)" shfmt --write
  fi
}

# shellcheck fix all fixable issues
shellfix() {
  if (($# > 0)); then
    while (($# > 0)); do
      shellcheck -f diff "$1" | git apply --allow-empty
      shift
    done
  else
    rg -l '^#!/bin/bash' | xargs -P "$(nproc)" -I{} zsh -c 'shellcheck -f diff {} | git apply --allow-empty -q'
  fi
}

# repeat command, similar to watch, but often more convenient
whl() {
  local interval clear=0
  if [[ $1 == "-c" ]]; then
    clear=1
    shift
  fi
  local re='^[.0-9]+$'
  if [[ $1 =~ ${re} ]]; then
    interval=$1
    shift
  fi
  while true; do
    ((clear)) && clear
    "$@"
    sleep "${interval:-2}"
  done
}

# capture the output of a command so it can be retrieved with ret
cap() {
  tee /tmp/capture.out
}
ret() {
  cat /tmp/capture.out
}

# -------------------------------------------------------------------------- EZA
# cd and list files
cl() {
  cd $1 && eza --icons=auto --all --hyperlink --group-directories-first
}

# recurse into directories as a tree (short)
lst() {
  eza --tree --icons=auto --all --group-directories-first --level "${1:-5}"
}

# watch ls
wls() {
  watch -n "${1:-2}" -c eza --long --color=always --icons=auto --no-quotes --all --group-directories-first --smart-group --header
}
wlsm() {
  watch -n "${1:-2}" -c "eza --long --color=always --icons=auto --no-quotes --all --group-directories-first --smart-group --sort modified | tail -n $((LINES - 2))"
}

# ----------------------------------------------------------------- FILE MANAGER
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

# ------------------------------------------------------------------------ MV/CP
# move file and cd to destination directory
mvcd() {
  if (($# != 2)); then
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

# copy file and cd to destination directory
cpcd() {
  if (($# != 2)); then
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

# --------------------------------------------------------------------- ARCHIVES
# extract archive to subdirectory
x() {
  if (($# < 1)); then
    echo "usage: x[rm] <file..>"
    return 1
  fi
  for f in "$@"; do
    if [[ ! -e ${f} ]]; then
      echo "error: file ${f} doesn't exist"
      return 1
    fi
    case "${f}" in
      *.deb) mkdir "${f%.*}" && ar x "${f}" --output "${f%.*}" ;;
      *.tar) mkdir "${f%.*.*}" && tar xvf "${f}" -C "${f%.*.*}" ;;
      *.tar.bz | *.tar.bz2) mkdir "${f%.*.*}" && tar xjvf "${f}" -C "${f%.*.*}" ;;
      *.tar.gz) mkdir "${f%.*.*}" && tar xzvf "${f}" -C "${f%.*.*}" ;;
      *.tar.xz) mkdir "${f%.*.*}" && tar xJvf "${f}" -C "${f%.*.*}" ;;
      *.tbz | *.tbz2) mkdir "${f%.*}" && tar xjvf "${f}" -C "${f%.*}" ;;
      *.tgz) mkdir "${f%.*}" && tar xzvf "${f}" -C "${f%.*}" ;;
      *.txz) mkdir "${f%.*}" && tar xJvf "${f}" -C "${f%.*}" ;;
      *.7z) 7zx "${f}" -o "${f%.*}" ;;
      *.rar) unrar x "${f}" "${f%.*}" ;;
      *.xz) unxz "${f}" ;;
      *.zip) unzip "${f}" -d "${f%.*}" ;;
      *.zst) zstd -d "${f}" --output-dir-mirror "${f%.*}" ;;
      *)
        echo 'archive format not supported'
        return 1
        ;;
    esac
  done
}
xrm() {
  for f in "$@"; do
    x "${f}" && rm "${f}"
  done
}

# list archive contents
xl() {
  if (($# < 1)); then
    echo "usage: xl <file..>"
    return 1
  fi
  for f in "$@"; do
    if [[ ! -e ${f} ]]; then
      echo "error: file ${f} doesn't exist"
      return 1
    fi
    case "${f}" in
      *.tar* | *.tgz | *.txz) tar -tvf "${f}" ;;
      *.rar) unrar l "${f}" ;;
      *.xz) unxz -l "${f}" ;;
      *.zip) unzip -l "${f}" ;;
      *)
        echo 'archive format not supported'
        return 1
        ;;
    esac
  done
}

# --------------------------------------------------------------------- YANK/PUT
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
  tee /dev/tty | yank
}

# paste from clipboard
put() {
  if [[ ${XDG_SESSION_TYPE} == "wayland" ]]; then
    local type
    type=$(wl-paste -l | rg image)
    if [[ ${type} == image* ]]; then
      filename=$(date +%Y-%m-%d_%T).png
      wl-paste -t "${type}" > "${filename}" \
        && echo "Created image file ${filename}"
      [[ -v KITTY_WINDOW_ID ]] && kitten icat "${filename}"
    else
      wl-paste
    fi
  else
    xclip -o #-selection clipboard
  fi
}

# ----------------------------------------------------------------- UPDATE STUFF
# debounce update check frequency
debounce-update-check() {
  if (($# < 1)); then
    echo "usage: $0 <app> [hours]"
    return 1
  fi

  local state=${XDG_STATE_HOME:-${HOME}.local/state}/zsh/debounce-update-check
  local app=$1
  local f=${state}/${app}
  local hours=${2:-12}
  local seconds=$((hours * 60 * 60))
  local now last since
  mkdir -p "${state}"

  now=$(date +%s)
  last=$(date -f "${f}" +%s 2> /dev/null)
  since=$((now - last))

  if [[ -z ${last} ]] || ((since > seconds)); then
    if date +@%s > "${f}"; then
      return 0
    else
      echo 'Something went wrong.'
      return 1
    fi
  else
    local left=$((last + seconds - now))
    minutes=$(qalc --defaults --terse --set "decimal comma off" "round(${left}/60, 2)")
    hours=$(qalc --defaults --terse --set "decimal comma off" "round(${left}/60/60, 2)")
    echo "[${app}] ${minutes} minutes (${hours} hours) left until next update check."
    return 1
  fi
}

# update dotfiles list
update-dots() {
  local dots="${XDG_DATA_HOME:-${HOME}/.local/share}/dots"
  git -C "${HOME}/repos/dotfiles" ls-files | rg -v 'ttf$' | while read -r line; do realpath "${HOME}/repos/dotfiles/${line}"; done > "${dots}"
  git -C "${HOME}/repos/dotfiles-private" ls-files | while read -r line; do realpath "${HOME}/repos/dotfiles-private/${line}"; done >> "${dots}"
  sort -o "${dots}" -u "${dots}"
}

# update projects list
update-projects() {
  local projects=${XDG_DATA_HOME:-${HOME}/.local/share}/projects
  command rm -f "${projects}"
  realpath ~/repos/* ~/repos/src/* ~/projects/* 2> /dev/null | while read -r line; do
    [[ -d ${line} ]] && echo "${line}" >> "${projects}"
  done
  printf '%s\n' "${XDG_CONFIG_HOME:-${HOME}/.config}/nvim"* >> "${projects}"
  # for d in ~/.local/share/nvim*; do
  #   if [[ -d "${d}/project_nvim" ]]; then
  #     command ln -f "${projects}" "${d}/project_nvim/project_history"
  #   fi
  # done
}

# update grml zsh config files
update-zshrc() {
  debounce-update-check zshrc || return
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

# get latest caddy + cloudflare binary
update-caddy() {
  local latest_version
  latest_version=$(get-latest-version caddyserver/caddy)
  if [[ $latest_version != $(caddy -v | awk '{print $1}') ]]; then
    curl -o ~/.local/bin/caddy -L 'https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com%2Fcaddy-dns%2Fcloudflare'
  else
    echo "Already up to date."
  fi
}

# install or update yt-dlp (https://github.com/yt-dlp/yt-dlp/wiki/Installation)
update-yt-dlp() {
  local yt_dlp=$HOME/.local/bin/yt-dlp
  if [[ -x $yt_dlp ]]; then
    $yt_dlp -U
  else
    # curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o $yt_dlp
    # using yt-dlp_linux (instead of zipimport binary above) because it bundles curl_cffi
    wget --quiet --show-progress -O $yt_dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux
    chmod a+rx $yt_dlp
  fi
}

# update node using fnm
update-node() {
  current_version=$(fnm ls | rg lts-latest | awk '{print $2}')
  fnm install --lts
  new_version=$(fnm ls | rg default | awk '{print $2}')
  if [[ ${current_version} != "${new_version}" ]]; then
    fnm uninstall "${current_version}"
  fi
}

# install or update pnpm (https://pnpm.io/installation)
update-pnpm() {
  if check_com -c pnpm; then
    pnpm self-update
  else
    curl -fsSL https://get.pnpm.io/install.sh | sh -
  fi
}

# update pip packages inside venv
pipup() {
  [[ -v VIRTUAL_ENV ]] || return 1
  pip list | awk '{print $1}' | tail +3 | xargs pip install -U
}

# -------------------------------------------------------------------- MAN PAGES
# man pages search
mans() {
  man "$1" | less -G +/"$2"
}

# zsh man page search
manzsh() {
  man zshall | less -G +/"$1"
}

# -------------------------------------------------------------- COUNTDOWN/TIMER
# https://superuser.com/a/611582
countdown() {
  if (($# != 1)); then
    echo 'countdown 60'
    echo 'countdown $((2 * 60 * 60)) # two hours'
    echo 'countdown $((24 * 60 * 60)) # one day'
    return 1
  fi
  start="$(($(date '+%s') + $1))"
  printf '\e[?25l'
  while [[ ${start} -ge $(date +%s) ]]; do
    time="$((start - $(date +%s)))"
    printf '%s\r' "$(date -u -d "@${time}" +%H:%M:%S)"
    sleep 0.1
  done
  printf '\e[?25h' # BUG: doesn't work when interrupted (i.e Ctrl-C)
}
timer() {
  start=$(date +%s)
  printf '\e[?25l'
  while true; do
    time="$(($(date +%s) - start))"
    printf '%s\r' "$(date -u -d "@${time}" +%H:%M:%S)"
    sleep 0.1
  done
  printf '\e[?25h' # BUG: doesn't work when interrupted (i.e Ctrl-C)
}

# -------------------------------------------------------------------- OVERLOADS
# pnpm select command from package.json
p() {
  if (($# == 0)); then
    [[ -f package.json ]] || return 1
    local commands
    commands=$(jq -r '.scripts | to_entries[] | "\(.key)\t\(.value)"' package.json)
    fzf --with-nth=1 --delimiter='\t' --preview 'echo {2}' --preview-window=down:1:wrap --bind 'enter:become(pnpm run {1})' <<< "${commands}"
  else
    pnpm "$@"
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

# load tmuxp sessions
tmuxp() {
  local session
  [[ -x $(whence -p tmuxp) ]] || return
  session=$(fd . ~/.config/tmuxp -x basename {} .yml | sort | fzf)
  if [[ -n ${session} ]]; then
    command tmuxp load "${session}"
  fi
}

# ------------------------------------------------------------------------- FIND
# find regular files with more than link to them
# to see names linked to the same file use `find -samefile file_name`
find-hardlinks() {
  # find . -links +1 -type f -name '*' -printf '%i %p\n' | sort
  find -type f -links +1
}

# find broken symlink files
find-broken-symlinks() {
  find -xtype l
}

# --------------------------------------------------------------------------- PS
# process search (grep)
psg() {
  ps -ef | sed -n "1p; /[${1:0:1}]${1:1}/p"
}

# process tree
ptree() {
  (($# != 1)) && return
  ps --no-headers "$@"
  for p in "$@"; do
    # shellcheck disable=SC2046
    ptree $(cat "/proc/${p}/task/${p}/children")
  done
}

# ------------------------------------------------------------------------ UTILS
# touch executable and edit
touchx() {
  (($# != 1)) && return 1
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

# ripgrep | less
rgl() {
  rg --pretty "$@" | less -RFX
}

# sort json keys using jq
jqsort() {
  jq 'to_entries|sort|from_entries' "$1" > "$1".tmp && mv -f "$1".tmp "$1"
}

# open project in vscode
vs() {
  local projects=${XDG_DATA_HOME:-${HOME}/.local/share}/projects
  cat "${projects}" | fzf --multi --bind 'enter:become(code {+})'
}
# check if file ends with newline character
file-ends-with-newline() {
  (($# != 1)) && return 1
  [[ $(tail -c1 "$1" | wc -l) -gt 0 ]] \
    && echo "yes" \
    || echo "no"
}

# get a random, unused port
random-port() {
  python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()'
}

# diff two zip files
zipdiff() {
  # magic below:
  # 1. print first line (header)
  # 2. ignore last line (summary) and sort files
  # 3. print last line (summary)
  local contents contents_1 contents_2
  contents=$(unzip -vql "$1" | grep -v -- '-----')
  contents_1=$(head -n1 <<< "${contents}" && tail -n+2 <<< "${contents}" | head -n -1 | sort -fk8 && tail -1 <<< "${contents}")
  contents=$(unzip -vql "$2" | grep -v -- '-----')
  contents_2=$(head -n1 <<< "${contents}" && tail -n+2 <<< "${contents}" | head -n -1 | sort -fk8 && tail -1 <<< "${contents}")
  # diff -W200 -y <(echo "${contents_1}") <(echo "${contents_2}")
  git diff -U999 --no-index <(echo "${contents_1}") <(echo "${contents_2}")
}

# adb download and run
adb() {
  if ! [[ -x /tmp/platform-tools/adb ]]; then
    local url=https://dl.google.com/android/repository/platform-tools-latest-linux.zip
    local file_path=/tmp/platform-tools.zip
    wget --quiet --show-progress -nc -O "${file_path}" "${url}"
    unzip "${file_path}" -d /tmp
  fi
  HOME=${XDG_DATA_HOME}/android /tmp/platform-tools/adb "$@"
}

# trust .nvim.lua in cwd
nvim-trust() {
  local f target
  f=$(realpath "${PWD}"/.nvim.lua)
  [[ -f ${f} ]] || return 1
  # shellcheck disable=SC2154
  target=${XDG_STATE_HOME}/nvim/trust
  [[ -f ${target} ]] && sed -i "\+${f}+d" "${target}"
  sha256sum "${f}" | xargs >> "${target}"
}
