" save
map <C-s> <Esc>:update <CR>

" quite
nnoremap <C-q> :q!<CR>

nnoremap  <C-j> :tabprevious<CR>
nnoremap  <C-k> :tabnext<CR>
" nnoremap  <C-t>q :tabclose<CR>

" What does this do?
command TW :%s/ \+$//

nnoremap <C-p> "+p
vnoremap <C-p> "+p
nnoremap Y "+y
vnoremap Y "+y
" reload vimrc
nnoremap <F7> :source ~/.config/nvim/init.vim<CR>
" center the page
imap <C-e>  <C-o>zz

" This is a spell check from gilles castel blog
" https://castel.dev/post/lecture-notes-1/
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
" Toggle spell checking
map <leader>o <cmd>set invspell<CR>

" No idea
command! -nargs=1 SS let @/ = '\V'.escape(<q-args>, '\')

nnoremap - <cmd>NvimTreeToggle<cr>

" Buffer remaps
nnoremap <leader>l :bn<CR>
nnoremap <leader>h :bp<CR>
nnoremap <leader>q :bd<CR>

" Telescope
" Find file in current directory
nnoremap <leader>a <cmd>Telescope find_files<cr>
nnoremap <leader>jf <cmd>Telescope find_files<cr>
nnoremap <leader>jk <cmd>Telescope keymaps<cr>
nnoremap <leader>js <cmd>Telescope live_grep<cr>
nnoremap <leader>jb <cmd>Telescope buffers<cr>
" Find file in git repo
nnoremap <leader>jg <cmd>Telescope git_files<cr>
" Grep in git repo
nnoremap <leader>jl <cmd>lua require('telescope.builtin').live_grep{ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] }<cr>
" Search for string in current git repository
nnoremap <leader>jw <cmd>lua require('telescope.builtin').grep_string{ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] }<cr>

" Make terminal behave normally
au TermOpen * setlocal nonumber norelativenumber
au TermOpen * startinsert
au TermEnter * echo "jobid: ". &channel
" Change back!Telescope
nnoremap <leader>] <cmd>FloatermNew --wintype=vsplit --width=90<CR>
nnoremap <leader>[ <cmd>FloatermNew --wintype=split --height=15<CR>
" TODO Add some logic
nnoremap + <cmd>FloatermNew --wintype=float --width=220 --height=60<CR>
tnoremap <C-q> <C-\><C-N><cmd>FloatermKill<CR>

tnoremap <C-w>h <C-\><C-N><C-w>h
tnoremap <C-w>j <C-\><C-N><C-w>j
tnoremap <C-w>k <C-\><C-N><C-w>k
tnoremap <C-w>l <C-\><C-N><C-w>l

" tunmap <tab>
tnoremap <C-k>[ <C-\><C-n><CR>
" tnoremap <C-d> <C-\><C-n><cmd>bd!<CR>
" tnoremap <C-d> <cmd>FloatermToggle<CR>

" Auto insert into the terminal
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
