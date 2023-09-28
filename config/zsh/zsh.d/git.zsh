# -------------------------------------------------------------------------- GIT
alias ga='git add'
alias gauth='git shortlog --summary --numbered --email'
alias gc='git commit'
alias gcl='git config --local --list'
alias gcm='gr && git checkout $(git_main_branch)'
alias gd='git diff'
alias gdd='git diff | delta'
alias gdu='git diff --no-ext-diff -U0'
alias gdw='git diff -w'
alias gfp="git ls-files --full-name"
alias glg='git log --oneline -5'
alias gp='git pull'
alias gpall="fd -td '^\.git$' -IHL -x git -C {//} pull"
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
    fzf --bind 'enter:become(git checkout {})'
}

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
gpp() {
  if ! git remote -v | grep -q "git@github.com:dotfrag"; then
    echo "Invalid repository."
    return
  fi
  git commit -am "$(date '+%Y-%m-%d %H:%M:%S')"
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
    --preview 'git show -m --color {1}' \
    --preview-window 'down,80%' \
    --bind 'enter:become(git show -m {1})'
}

# run git command for all repos in directory (serial)
gall() {
  fd -td '^\.git$' -IHL -x echo {//} | sort |
    xargs -I{} zsh -c "print -P '%F{yellow}{}%f' && git -C {} $* && echo"
}

# run git command for all repos in directory (parallel)
gallx() {
  fd -td '^\.git$' -IHL -x git -C {//} $*
}
