"""
" PYTHON
"""
augroup pythongroup
    au!
    " Shortcut for running file
    autocmd FileType python nnoremap <buffer> <F9> <cmd>term poetry run python % <cr>

    " Set max column
    autocmd FileType python call matchadd('ColorColumn', '\%81v', 100)

    autocmd FileType python setlocal completeopt-=preview
    autocmd FileType python nnoremap <F8> <cmd>term black -l 79 %<CR>

    autocmd FileType python nnoremap <leader>. <cmd>FloatermNew --wintype=vsplit --width=90<CR> ipython -i %<CR>
    autocmd FileType python nnoremap <leader>, :<cmd>FloatermNew --wintype=split --height=15 ipython -i %<CR>
augroup END


"""
" TEX
"""
augroup texgroup
    au!
    autocmd FileType tex nnoremap <buffer> <F10> :VimtexCountWords<cr>
    autocmd FileType tex nnoremap <buffer> <leader>c I% <esc>
    autocmd FileType tex setlocal spell
    " Fold preamble in tex
    autocmd FileType tex nnoremap <leader>d ggv/\\noindent<CR>$zf``
    autocmd FileType tex nnoremap <leader>s :VimtexTocOpen <CR>
    autocmd FileType tex set nocindent nosmartindent noautoindent
    " Inkscape figures stuff
    autocmd FileType tex inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
    autocmd FileType tex nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
augroup END

" Make the files readable
" autocmd FileType tex set textwidth=95
augroup vimtex_config
    au!
    au User VimtexEventQuit VimtexClean
augroup END


"""
" HASKELL
"""
" set noautoindent
" autocmd FileType haskell nnoremap + :term ghci %<CR>
augroup haskellgroup
    au!
    autocmd FileType haskell nnoremap <leader>r :vsplit \| term ghci %<CR>
    autocmd FileType haskell nnoremap <leader>y :split \| resize 15 \| term ghci %<CR>
    autocmd FileType haskell set formatprg=stylish-haskell
    autocmd FileType haskell set tabstop=2
    autocmd FileType haskell set shiftwidth=2
    autocmd FileType haskell nnoremap <buffer> <F9> :term ghci %<cr>
augroup END

"""
" STATA
"""
augroup statagroup
    au!
    autocmd FileType stata nnoremap <buffer> <F9> :exec '!clear;xstata-mp do' shellescape(@%, 1)<cr><cr>
augroup END
" autocmd FileType stata vmap <C-S-x> :<C-U>call RunDoLines()<CR><CR>

"""
" SHELL
"""
augroup  shellgroup
    au!
    autocmd FileType sh nnoremap <buffer> <F9> :exec '!clear;./%' shellescape(@%, 1)<cr>
augroup END

"""
" LEDGER
"""
augroup beancountgroup
    au!
    autocmd FileType beancount autocmd! beancountgroup InsertLeave * %AlignCommodity
augroup END
