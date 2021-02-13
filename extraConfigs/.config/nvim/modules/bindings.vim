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
nnoremap ¬ :source ~/.config/nvim/init.vim<CR>
" center the page
imap <C-e>  <C-o>zz
" fzf searc
command! -bang HFiles call fzf#vim#files('~/', <bang>0)

" This is a spell check from gilles castel blog
" https://castel.dev/post/lecture-notes-1/
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
" Toggle spell checking
map <leader>o :set invspell<CR>

" No idea
command! -nargs=1 SS let @/ = '\V'.escape(<q-args>, '\')

nnoremap - <cmd>NERDTree<cr>
nnoremap <leader>i :Git 
nnoremap <leader>b :Git add % <bar> :Git commit -m "backup"<CR>


" Buffer remaps
nnoremap <leader>l :bn<CR>
nnoremap <leader>h :bp<CR>
nnoremap <leader>q :bd<CR>

" FZF remaps
nnoremap <leader>e :HFiles<CR>
nnoremap <leader>a :GFiles<CR>


" Make terminal behave normally
au TermOpen * setlocal nonumber norelativenumber 
au TermOpen * startinsert
" Change back!
nnoremap <leader>] :vs\|term<CR>
nnoremap <leader>[ :sp\|term<CR>
nnoremap + :term <CR>

tnoremap <C-w>h <C-\><C-N><C-w>h
tnoremap <C-w>j <C-\><C-N><C-w>j
tnoremap <C-w>k <C-\><C-N><C-w>k
tnoremap <C-w>l <C-\><C-N><C-w>l

" tnoremap <leader>l <C-\><C-n>:bn<CR>
" tnoremap <leader>h <C-\><C-n>:bp<CR>
" tnoremap <leader>q <C-\><C-n>:bd<CR>

" tunmap <tab>
tnoremap <C-k>[ <C-\><C-n><CR>
tnoremap <C-d> <C-\><C-n>:bd! <CR>

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
