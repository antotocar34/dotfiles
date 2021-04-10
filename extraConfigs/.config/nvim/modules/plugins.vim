
" Where to put anything that doesn't install correctly with nix
call plug#begin('~/.config/nvim/plugged')
" Plug 'nvim-lua/popup.nvim'
" Plug 'nvim-lua/plenary.nvim'
" Plug 'leanprover/lean.vim', { 'for': 'lean' }
" Plug 'nvim-telescope/telescope.nvim'
" Doesn't work properly, unforsh
" Plug 'psf/black'
call plug#end()


" Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
" set conceallevel=2
" let g:tex_conceal='abdmg'
let g:vimtex_include_search_enabled=0
let g:vimtex_complete_close_braces=1
let g:vimtex_view_forward_search_on_start=0
let g:vimtex_complete_close_braces = 1
let g:vimtex_view_automatic = 0
let g:vimtex_indent_enabled=0
let g:vimtex_compiler_method='latexmk'
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
"    \ 'build_dir' : '',
" let g:vimtex_compiler_tectonic = {
"     \ 'options' : [
"     \   '--keep-logs',
"     \   '--keep-intermediates',
"     \   '--synctex'
"     \ ],
"     \}

" Plug 'SirVer/Ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = [home . '/.config/nixpkgs/extraConfigs/.vim/my-snippets']

" Plug 'tpope/vim-surround'

" Plug 'justinmk/vim-sneak'

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
let g:coc_config_home="~/.config/nvim/"
autocmd FileType tex let g:coc_start_at_startup = 0
autocmd FileType python let b:coc_root_patterns = ['.env']
" autocmd FileType haskell let b:coc_root_patterns =
"                 \ [????]

" Plug 'vim-airline/vim-airline' 
" Works well with CaskaydiaCove Nerf Font Mono
let g:airline#extensions#whitespace#enabled = 0
let g:airline_highlighting_cache = 1
let g:airline_powerline_fonts = 1


" Plug 'vim-airline/vim-airline-themes'


