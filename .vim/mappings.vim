" Leader
let mapleader = ' '

" Enable <A-*> bindings
let c='a'
while c <= 'z'
    exec "set <A-".c.">=\e".c
    exec "imap \e".c." <A-".c.">"
    let c = nr2char(1+char2nr(c))
endw
set timeout ttimeoutlen=50

" Buffers
noremap <leader>w :update<cr>
noremap <leader>W :update<bar>bd<cr>
noremap <leader>x :x<cr>
noremap <leader>d :bd<cr>
noremap <leader>D :b#<bar>bd#<cr>
noremap <leader>q :q<cr>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Visual
nmap <leader>h :set hlsearch!<cr>
nmap <leader>cl :set cursorline!<cr>
nmap <leader>n nzz
nmap <leader>N Nzz
vnoremap < <gv
vnoremap > >gv

" Text manipulation/commands
nmap <leader>j i<cr><esc>
inoremap II <esc>I
inoremap AA <esc>A
inoremap OO <esc>o
inoremap Oo <esc>O

" Regex: Trailing spaces
nmap <leader>ts :%s/\s\+$//<cr>

" NERD tree
nmap <C-t> :NERDTreeToggle<cr>

" Ctrlp
nmap <A-l> :CtrlPLine<cr>

" Fzf
nmap <leader>f :Files<cr>
nmap <leader>l :Lines<cr>

" Incsearch
nmap / <plug>(incsearch-forward)
nmap ? <plug>(incsearch-backward)
nmap g/ <plug>(incsearch-stay)

" Easy motion
" nmap <Leader>w <plug>(easymotion-bd-w)
" nmap <Leader>W <plug>(easymotion-overwin-w)
" nmap <Leader>l <plug>(easymotion-bd-jk)
" nmap <Leader>L <plug>(easymotion-overwin-line)

" Eregex
nnoremap <leader>/ :call eregex#toggle()<cr>

" Indent lines
nmap <leader>il :IndentLinesToggle<cr>

" Easy align
xmap ga <plug>(EasyAlign)
nmap ga <plug>(EasyAlign)

" Fugitive
nmap <leader>gs :Gstatus<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>ga :Gcommit -a --amend<cr>
nmap <leader>gae :Gcommit -a --amend --no-edit<cr>
nmap <leader>gp :Gpush

" Goyo
nmap <F12> :Goyo<cr>

" System clipboard copy & paste support
set pastetoggle=<F2>
noremap <leader>y "+y
noremap <silent> <leader>p :set paste<cr>o<esc>"+p:set nopaste<cr>
noremap <silent> <leader>P :set paste<cr>O<esc>"+p:set nopaste<cr>

" Functions
nnoremap <silent> <leader>tw :call myfunc#ToggleTextWidth()<cr>
nnoremap <silent> <leader>cc :call myfunc#ToggleConcealLevel()<cr>
nnoremap <silent> <F3> :call myfunc#ToggleParMappings()<cr>
nnoremap <silent> <leader>C :call myfunc#CenterText()<cr>
vnoremap <silent> * :call myfunc#VisualSelection('', '')<cr>/<C-R>=@/<cr><cr>
vnoremap <silent> # :call myfunc#VisualSelection('', '')<cr>?<C-R>=@/<cr><cr>
