# -------------------------------------------------------------------------- FZF
if ! check_com -c fzf; then
  echo >&2 "fzf not installed."
  return
fi

source <(fzf --zsh)

# custom opts
export FZF_DEFAULT_OPTS="--height 30% --reverse --border --info inline-right \
--bind 'home:first,end:last' \
--bind 'ctrl-y:preview-up,ctrl-e:preview-down' \
--bind 'ctrl-b:preview-page-up,ctrl-f:preview-page-down' \
--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down' \
--bind 'ctrl-/:change-preview-window(hidden|)' \
--marker '▏' --prompt '▌ '"

# catppuccin colors (https://raw.githubusercontent.com/catppuccin/fzf/refs/heads/main/themes/catppuccin-fzf-macchiato.sh)
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} \
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"

# override border color
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} \
--color=border:#363A4F"

# extend colors
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} \
--color=selected-fg:#b8c0e0"

export FZF_DEFAULT_COMMAND="fd --type file --hidden --follow"
export FZF_ALT_C_COMMAND="fd --type directory --hidden --follow"
# export FZF_ALT_C_OPTS="--preview 'tree -a -L 1 -C {}'"
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

export SKIM_DEFAULT_OPTIONS="${SKIM_DEFAULT_OPTIONS} \
--color=fg:#cad3f5,bg:#24273a,matched:#363a4f,matched_bg:#f0c6c6,\
current:#cad3f5,current_bg:#494d64,current_match:#24273a,\
current_match_bg:#f4dbd6,spinner:#a6da95,info:#c6a0f6,prompt:#8aadf4,\
cursor:#ed8796,selected:#ee99a0,header:#8bd5ca,border:#6e738d"

# fe[p|b|d] [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
#   - [p] persistent fzf
#   - [b] bat preview
#   - [d] dotfiles
#   https://github.com/junegunn/fzf/wiki/examples#opening-files
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
  local dots="${XDG_DATA_HOME:-${HOME}/.local/share}/dots"
  # shellcheck disable=SC2016
  local bind='one:become($EDITOR {+}),enter:become($EDITOR {+}),ctrl-v:become(vi {+})'
  if [[ -n $1 ]]; then
    rg "$1" "${dots}" | fzf --multi --bind "${bind}"
  else
    fzf --multi --bind "${bind}" < "${dots}"
  fi
}

# fuzzy ripgrep open at line number
# https://github.com/junegunn/fzf/wiki/examples#opening-files
vg() {
  [[ -z $1 ]] && {
    vgi
    return
  }
  rg --color=always --line-number --no-heading $@ \
    | fzf --ansi \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --height 30 \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
      --bind 'enter:become($EDITOR {1} +{2}),ctrl-v:become(vi {1} +{2})'
}

# ripgrep interactive with fuzzy search and open at line number
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-between-ripgrep-mode-and-fzf-mode-using-a-single-key-binding
vgi() {
  command rm -f /tmp/rg-fzf-{r,f}
  local RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case"
  local INITIAL_QUERY="${*:-}"
  fzf --ansi --disabled --height 30 --query "${INITIAL_QUERY}" \
    --bind "start:reload:${RG_PREFIX} {q} || true" \
    --bind "change:reload:sleep 0.25; ${RG_PREFIX} {q} || true" \
    --bind 'tab:transform:[[ ! $FZF_PROMPT =~ rg ]] &&
      echo "rebind(change)+change-prompt(rg » )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
      echo "unbind(change)+change-prompt(fzf » )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
    --color "hl:-1:underline,hl+:-1:underline:reverse" \
    --prompt 'rg » ' \
    --delimiter : \
    --header 'Tab: Switch between ripgrep/fzf' \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become($EDITOR {1} +{2})'
}

# # fuzzy ripgrep dots open at line number
# vgd() {
#   [[ -z $1 ]] && return 1
#   rg --color=always --line-number --no-heading $@ ${HOME}/repos/dotfiles{,-private} \
#     | fzf --ansi \
#       --color "hl:-1:underline,hl+:-1:underline:reverse" \
#       --height 30 \
#       --delimiter : \
#       --preview 'bat --color=always {1} --highlight-line {2}' \
#       --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
#       --bind 'one:become($EDITOR {1} +{2}),enter:become($EDITOR {1} +{2}),ctrl-v:become(vi {1} +{2})'
# }

# fuzzy ripgrep dots open at line number in the style of vgi
vgd() {
  command rm -f /tmp/rg-fzf-{r,f}
  local RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case --hidden"
  local INITIAL_QUERY="${*:-}"
  fzf --ansi --disabled --height 30 --query "${INITIAL_QUERY}" \
    --bind "start:reload:${RG_PREFIX} {q} ${HOME}/repos/dotfiles{,-private} || true" \
    --bind "change:reload:sleep 0.25; ${RG_PREFIX} {q} ${HOME}/repos/dotfiles{,-private} || true" \
    --bind 'tab:transform:[[ ! $FZF_PROMPT =~ rg ]] &&
      echo "rebind(change)+change-prompt(rg » )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
      echo "unbind(change)+change-prompt(fzf » )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
    --color "hl:-1:underline,hl+:-1:underline:reverse" \
    --prompt 'rg » ' \
    --delimiter : \
    --header 'Tab: Switch between ripgrep/fzf' \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'one:become($EDITOR {1} +{2}),enter:become($EDITOR {1} +{2})'
}

# fkill - kill processes - list only the ones you can kill
# https://github.com/junegunn/fzf/wiki/examples#processes
fkill() {
  local pid
  if [[ ${UID} != "0" ]]; then
    pid=$(ps -f -u "${UID}" | fzf -m --header-lines=1 --height=100% --preview='echo {}' --preview-window=down,3,wrap | awk '{print $2}')
  else
    pid=$(ps -ef | fzf -m --header-lines=1 --height=100% --preview='echo {}' --preview-window=down,3,wrap | awk '{print $2}')
  fi
  if [[ -n ${pid} ]]; then
    echo "${pid}" | xargs kill -"${1:-TERM}"
  fi
}

# command cheatsheet
cmd() {
  local cmds=${ZDOTDIR:-${HOME}}/.cmds
  # local cmd
  # cmd=$(fzf --query="$1" --select-1 --exit-0 < "${cmds}")
  # [[ -n ${cmd} ]] && eval "${cmd}"
  fzf --query="$@" --select-1 --exit-0 --bind 'enter:become(eval {}),ctrl-v:accept-non-empty' < "${cmds}"
}

# ps interactive
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#updating-the-list-of-processes-by-pressing-ctrl-r
psf() {
  fzf --bind='start,ctrl-r:reload(date; ps -ef)' \
    --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
    --preview='echo {}' --preview-window=down,3,wrap \
    --multi --height=100% | sed '$!G'
}
