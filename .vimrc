filetype indent on
filetype plugin on

set autoindent
set backspace=indent,eol,start
set cursorline
set expandtab
set foldenable
set foldlevel=100
set foldmarker={,}
set foldmethod=marker
set foldopen=block,hor,mark,percent,quickfix,tag
set history=500
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set linebreak
set matchtime=10
set mouse=a
set nobackup
set nocompatible
set noerrorbells
set noswapfile
set novisualbell
set nowb
set nowrap
set nowritebackup
set number
set numberwidth=5
set relativenumber
set report=0
set ruler
set scrolloff=8
set shiftround
set shiftwidth=2
set showcmd
set showmatch
set sidescroll=1
set sidescrolloff=15
set smartcase
set smartindent
set statusline=%F\ %m%r%h%w\ [%L\ lines]\ [%{&ff}]\ %y\ [%p%%]\ [%04l,%04v]
set tabstop=2
set vb t_vb=
set virtualedit=all
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*DS_Store*
set wildignore+=*sass-cache*
set wildignore+=*vim/backups*
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=vendor/cache/**
set wildignore+=vendor/rails/**
set wildignore=*.o,*.obj,*~
set wildmenu
set wildmode=list:longest
syntax on

" ----------------------------
"   Plug
" ----------------------------------------------------------------------------

" Install vim-plug if we don't already have it
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
" Colorschemes
Plug 'captbaritone/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'ajh17/spacegray.vim'

" Syntax
Plug 'tpope/vim-git', { 'for': 'git' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'qrps/lilypond-vim', { 'for': 'lilypond' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'mxw/vim-jsx'

" Completion
Plug 'mattn/emmet-vim', { 'for': 'html' }

" Make % match xml tags
Plug 'tmhedberg/matchit', { 'for': ['html', 'xml'] }

" Make tab handle all completions
Plug 'ervandew/supertab'

" Syntastic: Code linting errors
Plug 'scrooloose/syntastic'

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" Fancy statusline
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Fuzzy file opener
Plug 'ctrlpvim/ctrlp.vim'

" Open from quick-fix-list in new split
Plug 'yssl/QFEnter'

" Respect .editorconfig files. (http://editorconfig.org/)
Plug 'editorconfig/editorconfig-vim'

" Search files using Silver Searcher
Plug 'rking/ag.vim'

" Make Ag searches of selected text
Plug 'Chun-Yang/vim-action-ag'

" Rename/remove files from within vim
Plug 'tpope/vim-eunuch'

" Make commenting easier
Plug 'tpope/vim-commentary'

" Navigate files in a sidebar
Plug 'scrooloose/nerdtree'

" CamelCase motions through words
Plug 'bkad/CamelCaseMotion'

" Split and join lines of code intelligently
Plug 'AndrewRadev/splitjoin.vim'

" Only show cursorline in the current window
Plug 'vim-scripts/CursorLineCurrentWindow'

" Split navigation that works with tmux
Plug 'christoomey/vim-tmux-navigator'

" Change brackets and quotes
Plug 'tpope/vim-surround'

" Make vim-surround repeatable with .
Plug 'tpope/vim-repeat'

" Custom motions

" Indent object
Plug 'michaeljsmith/vim-indent-object'
" Camel Case object
Plug 'bkad/CamelCaseMotion'
"
" Argument object
Plug 'vim-scripts/argtextobj.vim'

" Fugitive: Git from within Vim
Plug 'tpope/vim-fugitive'

" Show git status in the gutter
Plug 'airblade/vim-gitgutter'

" Run Python tests in tmux splits
" Plug 'captbaritone/projects/vim-vigilant', { 'for': 'python' }
Plug '~/projects/vim-vigilant', { 'for': 'python' }
Plug 'benmills/vimux', { 'for': ['python', 'javascript'] }

" Python completion and tag navigation
Plug 'davidhalter/jedi-vim', { 'for': 'python' }

" Wrap and upwrap argument lists
Plug 'FooSoft/vim-argwrap'

" Take notes and keep todo lists in vim
Plug 'vimwiki/vimwiki'

" 'Vastly improved Javascript indentation and syntax support in Vim'
Plug 'pangloss/vim-javascript'

" Visualize undo tree
Plug 'mbbill/undotree'

Plug 'parkr/vim-jekyll'

" Other plugins require curl
if executable("curl")

    " Webapi: Dependency of Gist-vim
    Plug 'mattn/webapi-vim'

    " Gist: Post text to gist.github
    Plug 'mattn/gist-vim'
endif

filetype plugin indent on                   " required!
call plug#end()

