" syntax enable
filetype plugin on

set encoding=utf-8
set nocompatible

set nocursorline " Disable highlighting current line
set autochdir " Automatically changes working directory to current file.
set nohlsearch
set incsearch " Incremental search
set inccommand=nosplit " Incremental search on replace. 
set ignorecase 
set smartcase " Case insensitive if search is all lowercase
set hidden " Coc TextEdit might fail if this is unset
set spelllang=en
set number relativenumber
filetype plugin indent on
set expandtab " On pressing tab, insert spaces

set tabstop=4 " Show existing tab with 4 spaces width
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" Shows what you type in command mode.
set showcmd
"
set cmdheight=1

set wildmode=longest,list,full
autocmd fileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
set splitbelow splitright
set linebreak

autocmd BufEnter * silent! lcd %:p:h
set autoread
set ttimeout
set ttimeoutlen=100
set timeoutlen=3000

augroup highlight_yank
 autocmd!
 au TextYankPost * silent! lua vim.highlight.on_yank{timeout=200}
augroup END

set title " Set's a more descriptive title.

set noshowmode " Disables INSERT at the bottom of the screen

set completeopt=menuone,noselect " For nvim-compe
