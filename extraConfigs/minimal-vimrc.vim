let mapleader =" " 
let home = $HOME
""
"PLUGINS
""
" call plug#begin('~/.vim/plugged')

" Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=2
let g:tex_conceal='abdmg'
let g:vimtex_include_search_enabled=0
let g:vimtex_complete_close_braces=1
let g:vimtex_view_forward_search_on_start=0
let g:vimtex_complete_close_braces = 1
let g:vimtex_view_automatic = 0
let g:vimtex_indent_enabled=0
" let g:vimtex_compiler_latexmk = {
"     \ 'options' : [
"     \   '-pdf',
"     \   '-shell-escape',
"     \   '-verbose',
"     \   '-file-line-error',
"     \   '-synctex=1',
"     \   '-interaction=nonstopmode',
"     \ ],
"     \}

" Plug 'SirVer/Ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = [home . '/.config/nixpkgs/extraConfigs/.vim/my-snippets']

"""
" SETTINGS
"""
" " syntax enable
" filetype plugin on
" set nocompatible
" set spelllang=en
" set encoding=utf-8
" set number relativenumber
" set background=dark
" filetype plugin indent on
" " show existing tab with 4 spaces width
" set tabstop=4
" " when indenting with '>', use 4 spaces width
" set shiftwidth=4
" " On pressing tab, insert 4 spaces
" set expandtab
" " Shows what you type in command mode.
" set showcmd
" set wildmode=longest,list,full
" autocmd fileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" set splitbelow splitright
" set linebreak

" " Changes directory to current file directory
" autocmd BufEnter * silent! lcd %:p:h
" set autoread
" set ttimeout
" set ttimeoutlen=100
" set timeoutlen=3000
"""
" BINDINGS
"""
autocmd BufEnter * startinsert | call cursor(1, 2)
inoremap wq <Esc>:wq<CR>
nnoremap wq :wq<CR>
inoremap qw <Esc>:wq<CR>
nnoremap qw :wq<CR>
nnoremap <C-q> :q!<CR>
" command R !clear&&./%
" command TW :%s/ \+$//
" nnoremap Y "+y
" map <C-s>  <Esc>:update <CR>
" nnoremap ¬ :source ~/.vimrc<CR>

colorscheme industry
"""
" COLOURSCHEME
"""
"augroup my-colors
"    autocmd!
"    autocmd ColorScheme * hi Conceal ctermbg=NONE
"    autocmd ColorScheme * hi SpellBad ctermbg=NONE
"augroup END

"hi SpellBad ctermfg=174 ctermbg=NONE 
"hi Conceal ctermfg=NONE ctermbg=NONE		
"hi LineNR ctermfg=109
"hi SpellCap  ctermfg=95
"hi SpellRare ctermfg=95
"hi SpellLocal ctermfg=95
"hi Delimiter ctermfg=183
"hi texMathZoneES  ctermbg=NONE
"hi texDocZone  ctermbg=NONE
"hi texSectionZone  ctermbg=NONE	
"hi texSection  ctermbg=NONE
"hi texSubSectionZone  ctermbg=NONE
"hi texStatement  ctermbg=NONE
"hi Delimiter  ctermbg=NONE "syntax colour of brackets and the like.
"hi texMatcher  ctermbg=NONE
"hi TexMathOper ctermfg=15 "syntax colour of math operators like the _
"hi TexMathzoneW ctermfg=80	
"hi texMathMatcher  ctermfg=80
"hi texMathZoneES  ctermfg=80
"hi texMathSymbol ctermfg=1 	
"hi texMathZoneX ctermfg=80	
"hi texGreek ctermfg=1
"hi texBeginEnd ctermfg=167
"hi pythonNumber ctermfg=114

"augroup nord-overrides
"    autocmd!
"    autocmd ColorScheme nord highlight TexMathzoneW ctermfg=15
"    autocmd ColorScheme nord highlight texMathSymbol ctermfg=1 	
"    autocmd ColorScheme nord highlight texGreek ctermfg=1 	
"    autocmd ColorScheme nord highlight Delimiter ctermfg=5 	
"augroup END


""""
"" TEX Specific Stuff
""""
"autocmd FileType tex nnoremap <buffer> <leader>c I% <esc>
"autocmd FileType tex setlocal spell
"autocmd FileType tex set nocindent nosmartindent noautoindent
"" Make the files readable
"" autocmd FileType tex set textwidth=95
"augroup vimtex_config
"    au!
"    au User VimtexEventQuit call vimtex#compiler#clean(0)
"augroup END
""""
