let output = system("which node")
if v:shell_error == 0
    " coc here
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

    nnoremap <leader>g <Plug>(coc-definition)
    " nnoremap <silent> gy <Plug>(coc-type-definition)
    " nnoremap <silent> gi <Plug>(coc-implementation)
    " nnoremap <silent> gr <Plug>(coc-references)
    " nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
    " nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
    " xnoremap <leader>r <Plug>(coc-codeaction-selected)
    " nnoremap <leader>r <Plug>(coc-codeaction-selected)

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
