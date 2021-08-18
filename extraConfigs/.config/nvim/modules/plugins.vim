if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Where to put anything that doesn't install correctly with nix
call plug#begin('~/.config/nvim/plugged')
Plug 'jalvesaq/Nvim-R'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'lewis6991/gitsigns.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
" Plug 'leanprover/lean.vim', { 'for': 'lean' }
" Plug 'nvim-telescope/telescope.nvim'
" Plug 'psf/black'
Plug 'shaunsingh/nord.nvim'
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

" Plug 'shaunsingh/nord.nvim'
lua << EOF
require('nord').set()
EOF


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

" Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path': '~/Documents/Notes/vimwiki',
                      \ 'path_html': '~/Documents/Notes/vimwiki_html'}]

autocmd FileType wiki nnoremap <CR><leader> <Plug>VimwikiIncrementListItem 


" Plug 'lewis6991/gitsigns.nvim'
lua require('gitsigns').setup()

" Plug 'hoob3rt/lualine.nvim'require('lualine').setup()
lua << EOF
require('lualine').setup {
  options = {
    -- ... your lualine config
    theme = 'nord'
    -- ... your lualine config
  }
}
EOF
