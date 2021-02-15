augroup my-colors
    autocmd!
    autocmd ColorScheme * hi Conceal ctermbg=NONE
    autocmd ColorScheme * hi SpellBad ctermbg=NONE
    " For sneak highlight
    autocmd ColorScheme * hi Sneak ctermfg=0 ctermbg=4 cterm=NONE
    autocmd ColorScheme * hi Search ctermfg=0 ctermbg=4 cterm=NONE
    autocmd ColorScheme * hi IncSearch ctermfg=0 ctermbg=4 cterm=NONE
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

" set termguicolors
