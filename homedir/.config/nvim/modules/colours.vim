set termguicolors

" Make 
au TermOpen * hi! NormalFloat guibg='#2E3440'
hi FloatermBorder guifg=#81A1C1

function! SynStack ()
    for i1 in synstack(line("."), col("."))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echo n1 "->" n2
    endfor
endfunction

nnoremap gm :call SynStack()<CR>
