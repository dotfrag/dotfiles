" Plugins
call plug#begin('$MYVIMPATH/plugged')

" Utility
Plug 'haya14busa/incsearch.vim'
Plug 'othree/eregex.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-repeat'

" Formatting
Plug 'junegunn/vim-easy-align'
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" Visual
Plug 'sheerun/vim-polyglot'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/goyo.vim'

" Themes
Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Files and navigation
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'tpope/vim-unimpaired'
Plug 'christoomey/vim-tmux-navigator'

if has('unix') && executable('fzf')
    Plug '$HOME/.fzf'
    Plug 'junegunn/fzf.vim'
else
    Plug 'ctrlpvim/ctrlp.vim'
endif

" Git
" Plug 'tpope/vim-fugitive'

" Text objects
" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-line'
" Plug 'kana/vim-textobj-entire'
" Plug 'deathlyfrantic/vim-textobj-blanklines'
" Plug 'kana/vim-textobj-indent'
" Plug 'glts/vim-textobj-comment'
" Plug 'Julian/vim-textobj-brace'
" Plug 'mattn/vim-textobj-url'

" UltiSnips, Supertab and YCM
" Plug 'Valloric/YouCompleteMe'
" Plug 'ervandew/supertab'
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" Python
" Plug 'klen/python-mode', { 'for': 'python' }

" GO lang
" Plug 'fatih/vim-go', { 'for': 'go' }

" HTML
" Plug 'mattn/emmet-vim', { 'for': ['html', 'htmldjango'] }

" Latex
" Plug 'lervag/vimtex'

call plug#end()

" Airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 1

" CtrlP
let g:ctrlp_show_hidden = 1
let g:ctrlp_arg_map = 1
let g:ctrlp_extensions = ['line']
let g:ctrlp_custom_ignore = {'file': '\v\.(exe|so|dll|bbl|aux|bbl|fls|blg|fdb_latexmk)$'}

" Ripgrep
if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
    let g:ctrlp_user_command = 'rg %s --files --hidden --color=never --glob ""'
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_use_caching = 0
endif

" NERDTree
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeMinimalUI = 1
let NERDTreeIgnore=['\.aux$', '\.bbl$', '\.blg$', '\.fdb_latexmk$', '\.fls$', '\.gz$', '\.log$', '\.out$', '\.toc$', '\.lof$', '\.lot$']

" indentLine
let g:indentLine_enabled         = 0
let g:indentLine_fileTypeExclude = ['text', 'sh', 'vimwiki', 'tex', 'bib']
let g:indentLine_bufTypeExclude  = ['help', 'terminal']
let g:indentLine_bufNameExclude  = ['_.*', 'NERD_tree.*']

" Eregex
let g:eregex_default_enable = 0

" UltiSnips, Supertab and YCM
" let g:SuperTabDefaultCompletionType = '<C-n>'
" let g:SuperTabCrMapping = 0
" let g:UltiSnipsExpandTrigger = '<Tab>'
" let g:UltiSnipsJumpForwardTrigger = '<Tab>'
" let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
" let g:ycm_key_list_select_completion = ['<C-j>', '<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']
" let g:UltiSnipsExpandTrigger = "<Tab>"
" let g:UltiSnipsJumpForwardTrigger = "<Tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"

" Python
" let g:pymode_rope = 0
" let g:pymode_folding = 0
" let g:pymode_options_colorcolumn = 0

" GO lang
" let g:go_fmt_autosave = 1
" let g:go_fmt_command = "goimports"
" let g:go_metalinter_autosave = 1
" let g:go_metalinter_autosave_enabled = ['vet', 'golint']
" let g:go_highlight_types = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_structs = 1
" let g:go_highlight_extra_type = 1
" let g:go_list_type = "quicklist"
" let g:go_auto_type_info = 0
" let g:go_def_mapping_enabled = 0
