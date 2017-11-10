" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" ================ vim-plug ====================
call plug#begin('~/.vim/plugged')
" UI setting
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes' " Status line
Plug 'mhinz/vim-startify' " Start page
Plug 'junegunn/limelight.vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'farmergreg/vim-lastplace'

" Editing/Syntax
Plug 'Raimondi/delimitMate' " Closing of quotes
Plug 'tpope/vim-commentary' " Commenter
Plug 'editorconfig/editorconfig-vim'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'terryma/vim-expand-region'
Plug 'scrooloose/nerdcommenter'
" Plug 'vim-syntastic/syntastic'
Plug 'Valloric/YouCompleteMe'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mattn/emmet-vim'

" Snippets
Plug 'scrooloose/snipmate-snippets'

" File Management
Plug 'scrooloose/nerdtree'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Searching
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mileszs/ack.vim'

" Text navigation
Plug 'easymotion/vim-easymotion'

" VimDevIcons
Plug 'ryanoasis/vim-devicons' " Devicons

" Python
Plug 'klen/python-mode', { 'for': 'python' }

" Javascript
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

" JSON
Plug 'elzr/vim-json'
call plug#end()
" ================ NERDTree Setup ====================
let NERDTreeQuitOnOpen = 1 " Quit on open
let NERDTreeAutoDeleteBuffer = 1 " Deleting files

" Open by default
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Toggle NerdTree hotkey
map <C-n> :NERDTreeToggle<CR>

" Close if only tab left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ================ Syntastic Setup ====================
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'

" ================ CtrlP Setup ====================
" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" ================ Airline Setup =====================
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts = 1

" move among buffers with CTRL
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <C-X> :bdelete<CR>

" ================ General Config ====================
set notitle                     "Do not show the filename in the window titlebar
set ruler                       "Show the cursor posiiton
set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set whichwrap+=<,>,h,l          "Wrap on keys
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set mouse=a                     "Enable mouse in all modes
set clipboard=unnamed           "Use OS clipboard
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_ "Show “invisible” characters
set termencoding=utf8           "Encoding
set encoding=utf8               "Endoting
set ffs=unix,dos,mac            "Use Unix as the standard file type
set laststatus=2                "Always show status bar
set showmatch                   "Show matching brackets when text indicator is over them
let g:mapleader = ','           "Set Leader key

" Highlight Current Line
set cul
hi CursorLine term=none cterm=none ctermbg=152

" Favorite Color Scheme
set background=dark
let g:solarized_termtrans=1
colorscheme solarized

" ================ Spell Check =======================
if version >= 700
  set spl=en spell
  set nospell
endif

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Search Settings  =================

set incsearch        "Find the next match as we type the search
set wrapscan
set ignorecase
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
set hlsearch         "Hilight searches by default
set viminfo='100,f1  "Save up to 100 marks, enable capital marks

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.

silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set wrap         "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Save from Line ===================
augroup line_return
      au!
          au BufReadPost *
                  \ if line("'\"") > 0 && line("'\"") <= line("$") |
                  \     execute 'normal! g`"zvzz' |
                  \ endif
        augroup END

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=node_modules/**

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital
