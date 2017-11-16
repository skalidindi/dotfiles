" Vim Settings by Santosh Kalidindi

"------------------------------------------------
" => General
"------------------------------------------------
set nocompatible                " Get out of vi compatible mode
set notitle                     " Do not show the filename in the window titlebar
set ruler                       " Show the cursor posiiton
set number                      " Line numbers are good
set backspace=indent,eol,start  " Allow backspace in insert mode
set history=1000                " Store lots of :cmdline history
set showcmd                     " Show incomplete cmds down the bottom
set showmode                    " Show current mode down the bottom
set gcr=a:blinkon0              " Disable cursor blink
set visualbell                  " No sounds
set autoread                    " Reload files changed outside vim
set autowrite                   " Write on make/shell commands
set mouse=a                     " Enable mouse in all modes
set clipboard=unnamed           " Use OS clipboard
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_ " Show “invisible” characters
set termencoding=utf8           " Encoding
set encoding=utf8               " Encoding
set ffs=unix,dos,mac            " Use Unix as the standard file type
set laststatus=2                " Always show status bar
set showmatch                   " Show matching brackets when text indicator is over them
set cul                         " Highlight Current Line
set background=dark             " Set background
set timeoutlen=500              " Time to wait for a command
set modeline                    " Turn on modeline
set noswapfile                  " No swap file
set nobackup                    " No backup
set nowb                        " Replace tabs with spaces
set completeopt+=longest        " Optimize auto complete
set completeopt-=preview        " Optimize auto complete


let g:mapleader = ','           " Set Leader key

" Persistent Undo
" Keep undo history across sessions, by storing in file.
" Only works all the time.
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

" Source the vimrc file after saving it
autocmd BufWritePost $MYVIMRC source $MYVIMRC

"-------------------------------------------------
" => Platform Specific Setting
"-------------------------------------------------
" On Windows, also use .vim instead of vimfiles
if has('win32') || has('win64')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

set viewoptions+=slash,unix " Better Unix/Windows compatibility
set viewoptions-=options " in case of mapping change

"------------------------------------------------
" => vim-plug
"------------------------------------------------
call plug#begin('~/.vim/plugged')
" UI setting
Plug 'altercation/vim-colors-solarized'
Plug 'jdkanani/vim-material-theme'
Plug 'mhartington/oceanic-next'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes' " Status line
Plug 'mhinz/vim-startify' " Start page
Plug 'mhinz/vim-signify'
Plug 'farmergreg/vim-lastplace'
Plug 'junegunn/goyo.vim', { 'for': 'markdown' } " Distraction-free
Plug 'junegunn/limelight.vim', { 'for': 'markdown' } " Hyperfocus-writing

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
Plug 'Valloric/YouCompleteMe'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'w0rp/ale' " Async syntax checking

" Motion
Plug 'tpope/vim-unimpaired' " Pairs of mappings
Plug 'easymotion/vim-easymotion' " Easy motion
Plug 'unblevable/quick-scope' " Quick scope
Plug 'bkad/CamelCaseMotion' " Camel case motion
Plug 'majutsushi/tagbar' " Tag bar

" Snippets
Plug 'scrooloose/snipmate-snippets'

" Git
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'gregsexton/gitv' " Gitk clone
Plug 'airblade/vim-gitgutter' " Git diff sign

" Navigation
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' } " NERD tree git plugin
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mileszs/ack.vim'

" VimDevIcons
Plug 'ryanoasis/vim-devicons' " Devicons
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Icon colors

" Language Specificity
Plug 'sheerun/vim-polyglot' " Language Support (includes javascript and all other types)
Plug 'klen/python-mode', { 'for': 'python' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'elzr/vim-json'
Plug 'tpope/vim-rails' " Rails
Plug 'mattn/emmet-vim' " Emmet
Plug 'heavenshell/vim-jsdoc' " JSDoc for vim
Plug 'greyblake/vim-preview' " vim preview
Plug 'tpope/vim-bundler' " gem bundler
Plug 'Shougo/vimproc.vim', {'do' : 'make'} " vim proc
call plug#end()

"------------------------------------------------
" => Plugin Settings
"------------------------------------------------
" NERDTree Setup
let NERDTreeQuitOnOpen = 1 " Quit on open
let NERDTreeAutoDeleteBuffer = 1 " Deleting files
let NERDTreeShowBookmarks = 1 " Show bookmarks
" Open by default
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" Toggle NerdTree hotkey
map <C-n> :NERDTreeToggle<CR>
" Close if only tab left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" CtrlP Setup
" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Airline Setup
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts = 1

" Dev Icons
let g:WebDevIconsNerdTreeAfterGlyphPadding = ''

" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1

"-------------------------------------------------
" => User interface
"-------------------------------------------------
colorscheme solarized           " Set the colorscheme

"-------------------------------------------------
" => Spell Check
"-------------------------------------------------
if version >= 700
  set spl=en spell
  set nospell
endif

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" turn on syntax highlighting
syntax on

"-------------------------------------------------
" => Turn off swap files
"-------------------------------------------------
set noswapfile
set nobackup
set nowb

"-------------------------------------------------
" => Search
"-------------------------------------------------
set incsearch        " Find the next match as we type the search
set hlsearch         " Highlight searches by default
set wrapscan         " wrap around
set ignorecase       " Ignore case when searching..
set viminfo='100,f1  " Save up to 100 marks, enable capital marks
set smartcase        " ...unless we type a capital

"-------------------------------------------------
" => Indentation
"-------------------------------------------------
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set textwidth=80 " Change text width

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set wrap                        " Don't wrap lines
set linebreak                   " Wrap lines at convenient points
set whichwrap+=<,>,h,l          " Wrap on keys

"-------------------------------------------------
" => Fold
"-------------------------------------------------
set foldmethod=indent   " fold based on indent
set foldnestmax=3       " deepest fold is 3 levels
set nofoldenable        " dont fold by default

"-------------------------------------------------
" => Completion
"-------------------------------------------------
set wildmode=list:longest
set wildmenu                " enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ " stuff to ignore when tab completing
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

"-------------------------------------------------
" => Scrolling
"-------------------------------------------------
set scrolloff=8         " Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

"-------------------------------------------------
" => Key Mapping
"-------------------------------------------------
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR> " ????

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

nnoremap <Tab> :bnext<CR>       " Move to next tab
nnoremap <S-Tab> :bprevious<CR> " Move to previous tab
nnoremap <C-X> :bdelete<CR>     " Delete tab
