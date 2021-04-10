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
