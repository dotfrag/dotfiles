" VIM CONFIG
set nocompatible
set encoding=utf-8

" Set VIM dir
if has('unix')
    let $MYVIMPATH=$HOME . '/.vim'
elseif has('win32')
    let $MYVIMPATH=$HOME . '/VIM/vimfiles'
endif

" Directories
set backupdir=$MYVIMPATH/backup
set directory=$MYVIMPATH/swap
set undodir=$MYVIMPATH/undo

" Commands
" cnoremap vimrc e $MYVIMRC<cr>
cnoremap w!! w !sudo tee > /dev/null %

" Settings: General
set autoread                      " Set to auto read when a file is changed from the outside
set backspace=indent,eol,start    " Backspace behaviour
set cursorline                    " Highlight the current line
set foldmethod=manual             " Enable manual folding
set gdefault                      " By default add g flag to search/replace. Add g to toggle
set hidden                        " When a buffer is brought to foreground, remember undo history and marks
set history=500                   " Change default history (20)
set ignorecase                    " Ignore character case in search
set incsearch                     " Highlight dynamically as pattern is typed
set laststatus=2                  " Always show status line
set magic                         " Enable extended regexes
set mouse=a                       " Enable mouse in all in all modes
set nohlsearch                    " Disable search highlight
set nojoinspaces                  " Only insert single space after a '.', '?' and '!' with a join command
set noshowmode                    " Don't show the current mode (airline.vim takes care of us)
set nostartofline                 " Don't reset cursor to start of line when moving around
set nowrap                        " Do not wrap lines
set number                        " Show line numbers
set relativenumber                " Show relative numbers
set report=0                      " Show all changes
set ruler                         " Show the cursor position
set scrolloff=3                   " Start scrolling three lines before horizontal border of window
set shortmess=atI                 " Don't show the intro message when starting vim
set showcmd                       " Show keystrokes in status bar
set showtabline=2                 " Always show tab bar
set sidescrolloff=3               " Start scrolling three columns before vertical border of window
set smartcase                     " Ignore 'ignorecase' if search patter contains uppercase characters
set splitbelow                    " New window goes below
set splitright                    " New windows goes right
set timeoutlen=1000 ttimeoutlen=0 " Key timeout delay
set ttyfast                       " Send more characters at a given time
set undofile                      " Persistent Undo
set winminheight=0                " Allow splits to be reduced to a single line
set wrapscan                      " Searches wrap around end of file
" set ofu=syntaxcomplete#Complete " Set omni-completion method

" Settings: Indentation
set autoindent    " Copy indent from last line when starting new line
set expandtab     " Expand tabs to spaces
set shiftwidth=4  " The # of spaces for indenting
set smarttab      " At start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces
set softtabstop=4 " Number of spaces that a <Tab> counts for
set tabstop=4     " Width of a hard tabstop measured in spaces

" Settings: Formatting
set formatoptions=
set formatoptions+=1 " Break before 1-letter words
set formatoptions+=2 " Use indent from 2nd line of a paragraph
set formatoptions+=c " Format comments
set formatoptions+=l " Don't break lines that are already long
set formatoptions+=n " Recognize numbered lists
set formatoptions+=q " Format comments with gq
set formatoptions+=t " Auto-wrap text using textwidth
set formatoptions-=r " Continue comments by default
set formatoptions-=o " Make comment when using o or O from comment line

" Settings: List chars
set list listchars=tab:..,trail:_,extends:>,precedes:<,nbsp:~
set showbreak=\\

" Settings: Conceal
set conceallevel=2
set concealcursor=inc

" Settings: Wildmenu (command line completion)
set wildmode=full
set wildmenu

" Settings: Bells
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Settings: GUI and font rendering
if has('gui_running')
    set guioptions=icpM
    set lines=35 columns=120
    if has('win32') && (v:version == 704 && has("patch393")) || v:version > 704
        set renderoptions=type:directx,level:0.75,gamma:1.25,contrast:0.25,geom:1,renmode:5,taamode:1
    endif
endif

" Plugged
if has('unix')
    if empty(glob('$MYVIMPATH/autoload/plug.vim'))
        silent !curl -fLo $MYVIMPATH/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

" Plugins
source $MYVIMPATH/plugins.vim

" Mappings
source $MYVIMPATH/mappings.vim

" Colorscheme and fonts
set termguicolors
colorscheme onedark
if has('win32')
    set guifont=Iosevka:h11
elseif has('unix')
    set guifont=Iosevka\ Nerd\ Font\ 11
endif
