# -------------------------------------------------------------------------- FZF
eval "$(fzf --zsh)"

export FZF_DEFAULT_OPTS="--height 25% --reverse --border=bottom --info=inline \
--bind 'home:first,end:last' \
--bind 'ctrl-y:preview-up,ctrl-e:preview-down' \
--bind 'ctrl-b:preview-page-up,ctrl-f:preview-page-down' \
--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down' \
--bind 'ctrl-/:change-preview-window(hidden|)' \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

export FZF_DEFAULT_COMMAND="fd --type file --hidden --follow"
export FZF_ALT_C_COMMAND="fd --type directory --hidden --follow"
export FZF_ALT_C_OPTS="--preview 'tree -a -L 1 -C {}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export SKIM_DEFAULT_OPTIONS="$SKIM_DEFAULT_OPTIONS \
--color=fg:#cad3f5,bg:#24273a,matched:#363a4f,matched_bg:#f0c6c6,\
current:#cad3f5,current_bg:#494d64,current_match:#24273a,\
current_match_bg:#f4dbd6,spinner:#a6da95,info:#c6a0f6,prompt:#8aadf4,\
cursor:#ed8796,selected:#ee99a0,header:#8bd5ca,border:#6e738d"

# fe[b|d] [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
#   - [p] persistent fzf
#   - [b] bat preview
#   - [d] dotfiles
fe() {
  fzf --query="$@" --multi --bind 'enter:become($EDITOR {+}),ctrl-v:become(vi {+})'
}
fep() {
  fzf --query="$@" --multi --bind 'enter:execute($EDITOR {+}),ctrl-v:execute(vi {+})'
}
feb() {
  fzf --query="$@" --multi --height 100% \
      --preview "bat --color=always {}" \
      --bind 'enter:become($EDITOR {+}),ctrl-v:become(vi {+})'
}
fed() {
  cat "${XDG_DATA_HOME:-${HOME}/.local/share}/dots" |
    fzf --query="$@" --multi \
    --bind 'one:become($EDITOR {+}),enter:become($EDITOR {+}),ctrl-v:become(vi {+})'
}

# fuzzy ripgrep open with line number
vg() {
  rg --color=always --line-number --no-heading $@ |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --height 30 \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become($EDITOR {1} +{2}),ctrl-v:become(vi {1} +{2})'
}

# fuzzy ripgrep dots open with line number
vgd() {
  local files
  IFS=$'\n' local files=($(cat "${XDG_DATA_HOME:-${HOME}/.local/share}/dots"))
  rg --color=always --line-number --no-heading $@ ${files[@]} |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --height 30 \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'one:become($EDITOR {1} +{2}),enter:become($EDITOR {1} +{2}),ctrl-v:become(vi {1} +{2})'
}

# fkill - kill processes - list only the ones you can kill
fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

# command cheatsheet
cmd() {
  local cmds=${ZDOTDIR:-${HOME}}/.cmds
  local cmd=$(fzf --query="$1" --select-1 --exit-0 <$cmds)
  [[ -n "${cmd}" ]] && eval "${cmd}"
}
