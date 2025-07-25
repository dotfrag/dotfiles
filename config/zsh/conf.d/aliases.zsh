# ---------------------------------------------------------------------- ALIASES
alias vim=$EDITOR
alias v=$EDITOR
alias vi='command vim'
alias nv='neovide'
alias view='v -R'

alias nvim-astro='unset VIMINIT GVIMINIT; NVIM_APPNAME=nvim-astronvim nvim'
alias nvim-chad='unset VIMINIT GVIMINIT; NVIM_APPNAME=nvim-nvchad nvim'
alias nvim-dot='unset VIMINIT GVIMINIT; NVIM_APPNAME=nvim-dotvim nvim'
alias nvim-kickstart='unset VIMINIT GVIMINIT; NVIM_APPNAME=nvim-kickstart nvim'
alias nvim-lazy='unset VIMINIT GVIMINIT; NVIM_APPNAME=nvim-lazyvim nvim'
alias nvim-normalnvim='unset VIMINIT GVIMINIT; NVIM_APPNAME=nvim-normalnvim nvim'
alias nvim-nvim='unset VIMINIT GVIMINIT; NVIM_APPNAME=nvim-nvim nvim'

# alias agi='sudo nala install'
# alias aug='sudo nala update && sudo nala upgrade'
# alias di='sudo dnf install'
# alias dug='sudo dnf check-update && sudo dnf upgrade'

alias cd-='cd -'
alias chmod='chmod -v'
alias chown='chown -v'
alias cp='cp -vi'
alias ln='ln -vi'
alias mv='mv -vi'
alias rm='rm -v'

alias ls='eza --all --long --git --group-directories-first'
alias lsm='ls -s modified'
alias ltree='eza -T --icons=always --git-ignore'
alias lad='ls -d .*(/)'   # dot-directories
alias lsa='ls -a .*(.)'   # dot-files
alias lsb='find -xtype l' # broken symlinks
alias lsd='ls -d *(/)'    # directories
alias lse='ls -d *(/^F)'  # empty directories
alias lsl='ls -l *(@)'    # symlinks
alias lsx='ls -l *(*)'    # executables

alias j='just'
alias p='pnpm'
alias px='pnpx'
alias rr='restart'
alias tx='tmux new -As0'

alias bathelp='bat --plain --language=help'
alias cat='bat'
alias colors='bash -c "$(wget -qO- https://git.io/vQgMr)"'
alias dfs='df -h | sort -n -k 5'
alias duf='duf -only local -sort usage'
alias dus='du -sh * 2>/dev/null | sort -h'
alias files='nemo $(pwd) &>/dev/null & disown'
alias glow='glow -p'
alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -o "PreferredAuthentications=keyboard-interactive"'
alias killsigs="kill -l | tr ' ' '\n' | nl"
alias mdcat='mdcat -p'
alias pacdiff='MERGEPROG="git merge-file -p --diff3" pacdiff -s -b'
alias print-aliases='print -rl -- ${(k)aliases}'
alias print-functions='print -rl -- ${(k)functions}'
alias ran='ranger --choosedir=/tmp/.rangerdir; LASTDIR=$(cat /tmp/.rangerdir); cd "$LASTDIR"'
alias shfmt='shfmt --simplify --indent 2 --binary-next-line --case-indent --space-redirects'

alias update-fnm='curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell'

# --------------------------------------------------------------- GLOBAL ALIASES
alias -g C='|wc -l'
alias -g D='|delta'
alias -g DS='|delta --side-by-side'
alias -g F='|fzf -m'
alias -g G='|rg'
alias -g H='|head'
alias -g HH='|head -$((LINES-4))'
alias -g L='|less'
alias -g LL='|& less -r'
alias -g LS='|less -Sc'
alias -g N='2>/dev/null'
alias -g NN='&>/dev/null'
alias -g S='|sk'
alias -g T='|tail'
alias -g TR="|tr ' ' '\n'"
alias -g TS='|ts "%F %H:%M:%.S"'

alias -g Y='|yank'
alias -g XY='|xyank'
alias -g FY='|fzf|yank'

# ---------------------------------------------------------------- ABBREVIATIONS
abk[f]='$(fzf)'
abk[gall]="fd -td '^\.git$' -IHL -x echo {//} | sort | xargs -I{} git -C {} "
