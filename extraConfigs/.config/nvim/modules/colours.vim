set termguicolors

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

highlight ColorColumn ctermbg=magenta

function! SynStack ()
    for i1 in synstack(line("."), col("."))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echo n1 "->" n2
    endfor
endfunction
map gm :call SynStack()<CR>
