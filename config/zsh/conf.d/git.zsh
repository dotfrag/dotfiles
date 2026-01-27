# -------------------------------------------------------------------------- GIT
if ! check_com -c git; then
  echo >&2 "git not installed."
  return
fi

xsource /usr/share/doc/git-extras/git-extras-completion.zsh

# alias grv="git remote -v | awk '{print \$2}' | sort -u"
alias ga='git add'
alias gauth='git shortlog --summary --numbered --email'
alias gc-='git checkout -'
alias gc='git commit'
alias gcb='git checkout -b'
alias gcl='git config --local --list'
alias gcls='git config --local --list | sort'
alias gcm='gr && git checkout $(git_main_branch)'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdd='git diff | delta'
alias gdni='git diff --no-index'
alias gds='gdd --side-by-side'
alias gdt='GIT_EXTERNAL_DIFF=difft git diff'
alias gdu='git diff --no-ext-diff -U0'
alias gdud='gdu | delta'
alias gdw='git diff -w'
alias gfp='git ls-files --full-name'
alias glg='git log --oneline -5'
alias gpr='git pull --rebase'
alias gr='cd $(git rev-parse --show-toplevel || echo .)'
alias grv="git remote get-url origin"
alias gs='git status'
alias gsp='git stash pop'
alias gss='git status -s'
alias gst='git stash'
alias lg='lazygit'

# lazygit filter path
lgf() {
  lazygit -f "$(gfp "$1")"
}

# git clone and cd
gcd() {
  (($# != 1)) && return
  local repo
  repo=${1##*/}
  repo=${repo%.git}
  if [[ ! -d ${repo} ]]; then
    git clone "$1"
  fi
  cd "${repo}" || return
}
gcdt() {
  (($# != 1)) && return
  cdt
  gcd "$@"
}

# git checkout
gco() {
  git branch -a \
    | tr -d '[:blank:]' \
    | rg -v '^\*' \
    | awk -F'/' '{print $NF}' \
    | sort -u \
    | fzf -q "$1" --bind 'one:become(git switch -- {}),enter:become(git switch -- {})'
}
compdef _git gco=git-checkout

# git checkout or create
gcoc() {
  if git show-ref --quiet "refs/heads/${1}"; then
    git switch "${1}"
  else
    git switch -c "${1}"
  fi
}

# check if main exists and use instead of master
git_main_branch() {
  command git rev-parse --git-dir &> /dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}; do
    if command git show-ref -q --verify "${ref}"; then
      echo "${ref:t}"
      return
    fi
  done
  echo master
}

# git pull all repos in current directory
gpall() {
  local d
  [[ -n $1 ]] && d=$(($1 + 1)) || d=2
  # shellcheck disable=SC1083
  fd -IHL -j5 -d "${d}" -td '^\.git$' -x git -C {//} pull
}

# git gc all repos
gitgc() {
  # shellcheck disable=SC1083
  fd -td '^.git$' -IHL --strip-cwd-prefix -E '.cache' -E '.cargo' -E '.local' -E 'node_modules' \
    -x echo {//} | sort -u | while read -r line; do
    if git -C "${line}" rev-parse --is-inside-work-tree &> /dev/null; then
      print -P "%F{yellow}${line}%f"
      git -C "${line}" gc
      echo
    fi
  done
}

# dot commit and push
_gp() {
  if ! git remote -v | grep -q "git@github.com:dotfrag" || [[ $(git config --get user.name) != "dotfrag" ]]; then
    echo "Invalid repository."
    return 1
  fi
}
gpc() {
  _gp || return
  git pull
  git commit -m "$(date '+%F %T')"
}
gpp() {
  _gp || return
  git add -u
  gpc
  git push
}
gppe() {
  local wm_msg
  # shellcheck disable=SC2154
  if [[ ${XDG_SESSION_DESKTOP} == "sway" ]]; then
    wm_msg=swaymsg
  elif [[ ${XDG_SESSION_DESKTOP} == "i3" ]]; then
    wm_msg=i3-msg
  fi
  [[ -n ${wm_msg} ]] && ${wm_msg} '[con_id=__focused__]' move scratchpad
  if ! gpp; then
    [[ -n ${wm_msg} ]] && ${wm_msg} '[con_id=__focused__]' scratchpad show
    return
  fi
  exit
}

# find branches that have modified a file
glf() {
  (($# != 1)) && return 1
  git log --all --source -- "$1" \
    | rg -o "refs/.*" \
    | awk '!x[$0]++' \
    | head -10 \
    | xargs -r -I{} git log -1 --format='%S|%ai%x20(%ar)' '{}' -- "$1" \
    | perl -pe 's+refs/(heads|remotes|tags)(/origin)?/++' \
    | column -t -s '|'
}

# git log
glog() {
  git log --oneline --decorate --color "$@" \
    | fzf --ansi --multi --height 100% \
      --preview 'git show --stat -p -m --color {1}' \
      --preview-window 'down,80%' \
      --bind 'enter:become(git show --stat -p -m {1})'
}

# run git command for all repos in directory (serial)
gall() {
  if [[ -d $1 ]]; then
    local repos=()
    while [[ -d $1 ]]; do
      repos+=("$1")
      shift
    done
    for repo in "${repos[@]}"; do
      print -P "%F{yellow}${repo}%f"
      git -C "${repo}" "$@"
      echo
    done
  else
    # shellcheck disable=SC1083
    fd -td -d2 '^\.git$' -IHL --strip-cwd-prefix -x echo {//} \
      | sort | xargs -I{} zsh -c "print -P '%F{yellow}{}%f' && git -C {} $* && echo"
  fi
}

# run git command for all repos in directory (parallel)
gallx() {
  # shellcheck disable=SC1083
  fd -td '^\.git$' -IHL -x git -C {//} "$@"
}

# run git command for all repos in directory that are checked out on specific branch
gallb() {
  if (($# < 2)); then
    echo "Usage: $0 <branch> <command>"
    return 1
  fi
  local branch cmd repos
  branch=$1
  shift
  cmd=("$@")
  repos=()
  # shellcheck disable=SC1083
  for repo in $(fd -td '^\.git$' -IHL --strip-cwd-prefix -x echo {//} | sort); do
    if [[ $(git -C "${repo}" symbolic-ref --short -q HEAD) == "${branch}" ]]; then
      repos+=("${repo}")
    fi
  done
  if ((${#repos} < 1)); then
    return 1
  fi
  gall "${repos[@]}" "${cmd[@]}"
}

# print the status and current branch of all repos in cwd
gallst() {
  # shellcheck disable=SC1083
  fd -td -d2 '^\.git$' -IHL --strip-cwd-prefix -x echo {//} | sort \
    | xargs -I{} zsh -c "print -nP '%F{yellow}{}%f: ' && git -C {} status -sb"
}

# get latest version of github release
get-latest-version() {
  local org repo
  if (($# == 1)); then
    if grep -q '/' <<< "$1"; then
      org=${1%/*}
      repo=${1#*/}
    else
      # shellcheck disable=SC2016
      echo 'Bad format, expected `<org>/<repo>` or `<org> <repo>`.'
      return 1
    fi
  elif (($# == 2)); then
    org=$1
    repo=$2
  elif git rev-parse --is-inside-work-tree &> /dev/null; then
    local remote
    remote=$(git remote get-url origin)
    if ! grep -q 'github.com' <<< "${remote}"; then
      echo "Remote URL not supported."
      return 1
    fi
    IFS='/' read -r org repo < <(cut -d'/' -f4,5 <<< "${remote}")
  else
    echo "usage:"
    echo "    $0 <org>/<repo>"
    echo "    $0 <org> <repo>"
    echo "    $0 (when inside git repo)"
    return 1
  fi
  repo=${repo%.git}
  curl -sLH "Accept: application/json" "https://api.github.com/repos/${org}/${repo}/releases/latest" | jq -r '.tag_name' # grep -Po '"tag_name": "\Kv[^"]*'
}

# get latest tag
get-latest-tag() {
  git rev-parse --is-inside-work-tree &> /dev/null || return 1
  git describe --tags $(git rev-list --tags --max-count=1)
}

# sync github fork
sync-fork() {
  if ! git remote get-url upstream &> /dev/null; then
    echo "No upstream remote found. Add a remote upstream with:"
    echo "git remote add upstream https://github.com/ORIGINAL-OWNER/ORIGINAL-REPOSITORY.git"
    return
  fi
  branch=$(git symbolic-ref --short -q HEAD)
  git fetch upstream
  # git checkout "${branch}"
  git pull
  if git ls-remote --exit-code upstream "${branch}" > /dev/null; then
    git merge "upstream/${branch}"
  fi
}

# git pull or sync fork
gp() {
  if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    gpall
  elif git remote -v | awk '{print $1}' | grep -q upstream; then
    sync-fork
  else
    git pull
  fi
}

# delete local branches
delete-local-branches() {
  # shellcheck disable=SC1083
  for repo in $(fd -IHL -td -d2 '^\.git$' -x echo {//}); do
    git -C "${repo}" branch \
      | rg -v 'master|main|next' \
      | xargs -r git -C "${repo}" branch "${1:--d}"
  done
}
