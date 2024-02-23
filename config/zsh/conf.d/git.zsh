# -------------------------------------------------------------------------- GIT
alias ga='git add'
alias gauth='git shortlog --summary --numbered --email'
alias gc='git commit'
alias gcb='git checkout -b'
alias gcl='git config --local --list'
alias gcm='gr && git checkout $(git_main_branch)'
alias gd='git diff'
alias gdd='git diff | delta'
alias gdni='git diff --no-index'
alias gdt='GIT_EXTERNAL_DIFF=difft git diff'
alias gdu='git diff --no-ext-diff -U0'
alias gdud='gdu | delta'
alias gdw='git diff -w'
alias gfp="git ls-files --full-name"
alias glg='git log --oneline -5'
alias gp='git pull'
alias gpr='git pull --rebase'
alias gr='cd $(git rev-parse --show-toplevel)'
alias grv='git remote -v'
alias gs='git status'
alias gss='git status -s'
alias lg='lazygit'

# git checkout
gco() {
  git branch -a |
    tr -d '[:blank:]' |
    rg -v '^\*' |
    awk -F'/' '{print $NF}' |
    sort -u |
    fzf -q "$1" --bind 'enter:become(git checkout {})'
}
compdef _git gco=git-checkout

# check if main exists and use instead of master
git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done
  echo master
}

gpall() {
  fd -IHL -d "${1:=2}" -td '^\.git$' -x git -C {//} pull
}

# git gc all repos
gitgc() {
  fd -td '^.git' -IH -E '.cache' -E '.cargo' -E '.local' -E 'node_modules' \
    -x echo {//} | sort -u | while read -r line; do
    if git -C "${line}" rev-parse --is-inside-work-tree &>/dev/null; then
      print -P "%F{yellow}${line}%f"
      git -C "${line}" gc
      echo
    fi
  done
}

# dot commit and push
_gp() {
  if ! git remote -v | grep -q "git@github.com:dotfrag"; then
    echo "Invalid repository."
    return 1
  fi
}
gpc() {
  _gp || return
  git pull
  git commit -m "$(date '+%Y-%m-%d %H:%M:%S')"
}
gpp() {
  _gp || return
  git add -u
  gpc
  git push
}

# find branches that have modified a file
glf() {
  git log --all --source -- $1 |
    rg -o "refs/.*" |
    awk '!x[$0]++' |
    head -10 |
    xargs -I '{}' git log -1 --format='%S|%ai%x20(%ar)' '{}' -- $1 |
    sed -E 's|refs/(remotes\|tags)(/origin)?/||' |
    column -t -s '|'
}

# git log
glog() {
  git log --oneline --decorate --color "$@" |
    fzf --ansi --multi --height 100% \
      --preview 'git show --stat -p -m --color {1}' \
      --preview-window 'down,80%' \
      --bind 'enter:become(git show --stat -p -m {1})'
}

# run git command for all repos in directory (serial)
gall() {
  if [ -d "$1" ]; then
    local repos=()
    while [ -d "$1" ]; do
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
    fd -td '^\.git$' -IHL -x echo {//} | sort |
      xargs -I{} zsh -c "print -P '%F{yellow}{}%f' && git -C {} $* && echo"
  fi
}

# run git command for all repos in directory (parallel)
gallx() {
  fd -td '^\.git$' -IHL -x git -C {//} $*
}
