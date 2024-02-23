# ---------------------------------------------------------------------- ALIASES
alias agi='sudo nala install'
alias aug='sudo nala update && sudo nala upgrade'
alias di='sudo dnf install'
alias dug='sudo dnf check-update && sudo dnf upgrade'

alias chmod='chmod -v'
alias chown='chown -v'
alias cp='cp -vi'
alias ln='ln -vi'
alias mv='mv -vi'
alias rm='rm -v'

alias bathelp='bat --plain --language=help'
alias cat='bat'
alias colors='bash -c "$(wget -qO- https://git.io/vQgMr)"'
alias dfs='df -h | sort -n -k 5'
alias dus='du -sh * 2>/dev/null | sort -h'
alias files='nautilus --browser $(pwd) &>/dev/null & disown'
alias glow='glow -p'
alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -o "PreferredAuthentications=keyboard-interactive"'
alias killsigs="kill -l | tr ' ' '\n' | nl"
alias ls='eza --all --long --git --group-directories-first'
alias mdcat='mdcat -p'
alias print-aliases='print -rl -- ${(k)aliases}'
alias print-functions='print -rl -- ${(k)functions}'
alias ran='ranger --choosedir=/tmp/.rangerdir; LASTDIR=$(cat /tmp/.rangerdir); cd "$LASTDIR"'
alias rr='restart'
alias shellfmt='shfmt -i 2 -ci -w .'
alias tx='tmux attach-session || start-tmux.sh'

alias update-fnm='curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell'

# --------------------------------------------------------------- GLOBAL ALIASES
alias -g C='|wc -l'
alias -g D='|delta'
alias -g F='|fzf -m'
alias -g G='|rg'
alias -g H='|head'
alias -g HH='|head -$((LINES-4))'
alias -g L='|less'
alias -g LL='|& less -r'
alias -g N='2>/dev/null'
alias -g S='|sk'
alias -g TR="|tr ' ' '\n'"
alias -g Y='|copy'
alias -g YI='|fzf | copy'

# ---------------------------------------------------------------- ABBREVIATIONS
abk[f]='$(fzf)'
abk[gall]="fd -td '^\.git$' -IHL -x echo {//} | sort | xargs -I{} git -C {} "
