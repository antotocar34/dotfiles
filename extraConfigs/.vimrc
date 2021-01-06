"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"
"
"
if exists("g:ink_on")
      source ~/.config/nixpkgs/extraConfigs/minimal-vimrc.vim
else

let mapleader =" "
let home = $HOME

""INDEX

"PLUGINS
"SETTINGS
"COLOURS
"FILE SPECIFIC SETTINGS
"COC

""
"PLUGINS
""
" call plug#begin('~/.vim/plugged')



" Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=2
" let g:tex_conceal='abdmg'
let g:vimtex_include_search_enabled=0
let g:vimtex_complete_close_braces=1
let g:vimtex_view_forward_search_on_start=0
let g:vimtex_complete_close_braces = 1
let g:vimtex_view_automatic = 0
let g:vimtex_indent_enabled=0
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

" Plug 'SirVer/Ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = [home . '/.config/nixpkgs/extraConfigs/.vim/my-snippets']

" Plug 'tpope/vim-surround'

" Plug 'tpope/vim-unimpaired'

" Plug 'tpope/vim-commentary'

" Plug 'tpope/vim-fugitive'

" Plug 'LnL7/vim-nix'

" Plug 'junegunn/fzf.vim'
let g:fzf_buffers_jump = 0

" Plug 'arcticicestudio/nord-vim'

" Plug 'preservim/nerdtree'
let g:NERDTreeQuitOnOpen = 1

" Plug 'neovimhaskell/haskell-vim'
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

" Plug 'psf/black'
let g:black_linelength = 81
let g:black_skip_string_normalization = 1

" Plug 'neoclide/coc.nvim'
let g:coc_config_home="~/.vim/" " Change when transferring over to nix?
autocmd FileType tex let g:coc_start_at_startup = 0
autocmd FileType python let b:coc_root_patterns = ['Pipfile']
" autocmd FileType haskell let b:coc_root_patterns =
"                 \ [????]

" Plug 'vim-airline/vim-airline' 
" Works well with CaskaydiaCove Nerf Font Mono
let g:airline#extensions#whitespace#enabled = 0
let g:airline_highlighting_cache = 1
let g:airline_powerline_fonts = 1


" Plug 'vim-airline/vim-airline-themes'

" call plug#end()

""""
"" SETTINGS
""""

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
set guicursor=
" Set more instructive terminal titles for rofi
set title
"""
" BINDINGS
"""
"save
map <C-s>  <Esc>:update <CR>
"quit
nnoremap <C-q> :q!<CR>

nnoremap  <C-j> :tabprevious<CR>
nnoremap  <C-k> :tabnext<CR>
" nnoremap  <C-t>q :tabclose<CR>
command R !clear&&./%
" What does this do?
command TW :%s/ \+$//

nnoremap <C-p> "+p
vnoremap <C-p> "+p
nnoremap Y "+y
vnoremap Y "+y
" reload vimrc
nnoremap ¬ :source ~/.vimrc<CR>
" center the page
imap <C-e>  <C-o>zz
" fzf searc
map <leader>f :BLines <CR>
command! -bang HFiles call fzf#vim#files('~/', <bang>0)

" This is a spell check from gilles castel blog
" https://castel.dev/post/lecture-notes-1/
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
" Toggle spell checking
map <leader>o :set invspell<CR>

" No idea
command! -nargs=1 SS let @/ = '\V'.escape(<q-args>, '\')

nnoremap - :NERDTree <CR>
" TODO command to automatically backup latex documents.
nnoremap <leader>i :Git 
nnoremap <leader>b :Git add % <bar> :Git commit -m "backup"<CR>


" Buffer remaps
nnoremap <leader>l :bn<CR>
nnoremap <leader>h :bp<CR>
nnoremap <leader>q :bd<CR>

" FZF remaps
nnoremap <leader>e :HFiles<CR>
nnoremap <leader>a :Files<CR>


" Make terminal behave normally
au TermOpen * setlocal nonumber norelativenumber 
au TermOpen * startinsert
" Change back!
nnoremap <leader>t :vsplit \| term <CR>
nnoremap <leader>y :split \| term <CR>
nnoremap + :term <CR>

" Make terminal quitting easier
" Does not work with NEOVIM
" tnoremap <C-d> <C-\><C-n>:q!<CR>

" make C-[ escape in terminal mode
tnoremap <C-i> <C-\><C-n>

" neovim
" quit from terminal on control d
tunmap <tab>
tnoremap <C-d> <C-\><C-n>:bd! <CR>

tnoremap <C-w> <C-\><C-n> <C-w>

" Auto instert into the terminal
let g:previous_window = -1
function SmartInsert()
  if &buftype == 'terminal'
    if g:previous_window != winnr()
      startinsert
    endif
    let g:previous_window = winnr()
  else
    let g:previous_window = -1
  endif
endfunction

au BufEnter * call SmartInsert()

"""
" COLOURSCHEME
"""
augroup my-colors
    autocmd!
    autocmd ColorScheme * hi Conceal ctermbg=NONE
    autocmd ColorScheme * hi SpellBad ctermbg=NONE
augroup END

augroup nord-overrides
    autocmd!
    autocmd ColorScheme nord highlight TexMathzoneW ctermfg=15
    autocmd ColorScheme nord highlight texMathSymbol ctermfg=1
    autocmd ColorScheme nord highlight texPartArgTitle ctermfg=15
    " Highlights greek symbols as red
    autocmd ColorScheme nord highlight texGreek ctermfg=1
    " $ purple in latex inline mode
    autocmd ColorScheme nord highlight Delimiter ctermfg=5
augroup END

colorscheme nord

highlight ColorColumn ctermbg=magenta


"  _____ _ _        ____                  _  __ _
" |  ___(_) | ___  / ___| _ __   ___  ___(_)/ _(_) ___
" | |_  | | |/ _ \ \___ \| '_ \ / _ \/ __| | |_| |/ __|
" |  _| | | |  __/  ___) | |_) |  __/ (__| |  _| | (__
" |_|   |_|_|\___| |____/| .__/ \___|\___|_|_| |_|\___|
"                       |_|

"""
" PYTHON Specific Stuff
"""
" Shortcut for running file
autocmd FileType python nnoremap <buffer> <F9> :exec '!clear;python' shellescape(@%, 1)<cr>
" Set max column
autocmd FileType python call matchadd('ColorColumn', '\%81v', 100)
"Needed for jedi?
autocmd FileType python setlocal completeopt-=preview

"NEOVIM
autocmd FileType python nnoremap <leader>t :vsplit \| term ipython -i % <CR>
"VIM
" autocmd FileType python nnoremap + :vert term ipython -i %<CR>
"""
" TEX Specific Stuff
"""
nnoremap <buffer> <F10> :VimtexCountWords<cr>
autocmd FileType tex nnoremap <buffer> <leader>c I% <esc>
autocmd FileType tex setlocal spell
" Fold preamble in tex
autocmd FileType tex nnoremap <leader>d ggv/\\noindent<CR>$zf``
autocmd FileType tex nnoremap <leader>s :VimtexTocOpen <CR>
autocmd FileType tex set nocindent nosmartindent noautoindent

" Inkscape figures stuff
autocmd FileType tex inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
autocmd FileType tex nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
" Make the files readable
" autocmd FileType tex set textwidth=95
augroup vimtex_config
    au!
    au User VimtexEventQuit call vimtex#compiler#clean(0)
augroup END
"""
" HASKELL Specific Stuff
"""
" set noautoindent
" autocmd FileType haskell nnoremap + :term ghci %<CR>
autocmd FileType haskell nnoremap <leader>y :vsplit \| term ghci %<CR>
autocmd FileType haskell nnoremap <leader>t :split \| resize 15 \| term ghci %<CR>
autocmd FileType haskell set formatprg=stylish-haskell
autocmd FileType haskell set tabstop=2
autocmd FileType haskell set shiftwidth=2
autocmd FileType haskell nnoremap <buffer> <F9> :exec '!clear;ghci' shellescape(@%, 1)<cr>
"""
" STATA Specific Stuff
"""
autocmd FileType stata nnoremap <buffer> <F9> :exec '!clear;xstata-mp do' shellescape(@%, 1)<cr><cr>
" autocmd FileType stata vmap <C-S-x> :<C-U>call RunDoLines()<CR><CR>

"""
" SHELL Specific Stuff
"""
autocmd FileType sh nnoremap <buffer> <F9> :exec '!clear;./%' shellescape(@%, 1)<cr>

"""
" COC stuff
"""
let output = system("which node")
if v:shell_error == 0
    " coc here
    " set cmdheight=2
    set updatetime=300

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction

    " nnoremap <silent> gd <Plug>(coc-definition)
    nnoremap <silent> gy <Plug>(coc-type-definition)
    nnoremap <silent> gi <Plug>(coc-implementation)
    nnoremap <silent> gr <Plug>(coc-references)
    nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
    nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
    xnoremap <leader>r <Plug>(coc-codeaction-selected)
    nnoremap <leader>r <Plug>(coc-codeaction-selected)

    let g:coc_on = 1
    function Toggle_coc()
        if ((g:coc_on) == 1)
            let g:coc_on = 0
            execute "CocDisable"
        else
            let g:coc_on = 1
            execute "CocEnable"
        endif
    endfunction

    nnoremap <leader>u :call Toggle_coc()<CR>
endif

set noshowmode  " to get rid of thing like --INSERT--
" set noshowcmd  " to get rid of display of last command
" set shortmess+=F  " to get rid of the file name displayed in the command line bar

endif
