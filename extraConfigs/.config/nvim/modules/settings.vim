" syntax enable
filetype plugin on

set nocompatible
" Take out any cursor line
set nocursorline
" Automatically changes working directory to current file.
set autochdir
" Highlight and jump to search result as it is happening
set incsearch
" Case insensitive if search is all lowercase
set ignorecase
set smartcase
" Coc TextEdit might fail if this is unset
set hidden
set spelllang=en
set encoding=utf-8
set number relativenumber
" set background=light
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
" Shows what you type in command mode.
set showcmd
"
set cmdheight=1

set wildmode=longest,list,full
autocmd fileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
set splitbelow splitright
set linebreak

" This broke fzf, so I've commented it out.
" augroup remember_folds
"     autocmd!
"     au BufWinLeave ?* mkview 1
"     au BufWinEnter ?* silent! loadview 1
" augroup END

" Changes directory to current file directory
autocmd BufEnter * silent! lcd %:p:h
set autoread
set ttimeout
set ttimeoutlen=100
set timeoutlen=3000
set nohlsearch
" Disable guicuros in neovim
" set guicursor=
" Set more instructive terminal titles for rofi
set title
