if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'lewis6991/gitsigns.nvim'

Plug 'ray-x/lsp_signature.nvim'

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'antotocar34/nord.nvim' " Colour scheme
Plug 'SirVer/Ultisnips', { 'for': ['tex', 'beancount'] }
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'jalvesaq/Nvim-R', { 'for': 'r' }
Plug 'LnL7/vim-nix', { 'for': 'nix' }
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'hrsh7th/nvim-compe'
Plug 'vimwiki/vimwiki'
Plug 'henriquehbr/nvim-startup.lua'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'ledger/vim-ledger', { 'for': 'ledger' }
Plug 'nathangrigg/vim-beancount', { 'for': 'beancount' }
Plug 'jpalardy/vim-slime'
Plug 'meain/vim-printer'
Plug 'voldikss/vim-floaterm'
call plug#end()

"
" PLUGIN OPTIONS
"

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

" Plug 'SirVer/Ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = [home . '/.config/nixpkgs/extraConfigs/.config/nvim/my-snippets']

" Plug 'junegunn/fzf.vim'
let g:fzf_buffers_jump = 0

" Plug 'shaunsingh/nord.nvim'
lua << EOF
vim.g.nord_contrast = true
vim.g.nord_borders = false
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

" Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path': '~/Documents/Notes/vimwiki',
                      \ 'path_html': '~/Documents/Notes/vimwiki_html'}]
let g:vimwiki_global_ext = 0 " Make sure vimwiki doesn't affect markdown files.

autocmd FileType wiki nnoremap <CR><leader> <Plug>VimwikiIncrementListItem 

" Plug 'lewis6991/gitsigns.nvim'
lua << EOF
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    ['n <leader>gs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['v <leader>gs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>gu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>gR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <leader>gp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>gb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
  watch_index = {
    interval = 1000,
    follow_files = true
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  word_diff = false,
  use_internal_diff = true,  -- If luajit is present
}
EOF

" Plug 'hoob3rt/lualine.nvim'require('lualine').setup()
lua << EOF
require('lualine').setup {
  options = {
    theme = 'nord'
  }
}
EOF

" Plug 'henriquehbr/nvim-startup.lua'
lua require 'nvim-startup'.setup()

" Plug 'hrsh7th/nvim-compe'
lua << EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}
EOF

" Plug 'kyazdani42/nvim-tree.lua'
let g:nvim_tree_quit_on_open = 1
let g:nvim_tree_auto_open = 1
let g:nvim_tree_hide_dotfiles = 1

lua << EOF
    local tree_cb = require'nvim-tree.config'.nvim_tree_callback
    vim.g.nvim_tree_bindings = {
    { key = "_",        cb = tree_cb("dir_up") },
    { key = "-",        cb = tree_cb("close") },
    }
EOF

" Plug 'norcalli/nvim-colorizer.lua'
lua require'colorizer'.setup()

" Plug 'nvim-treesitter/nvim-treesitter'
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
EOF

" Plug 'ray-x/lsp_signature.nvim'
lua << EOF
    require "lsp_signature".setup({
        floating_window = true,
        hint_prefix = "",
        hint_enable = false, -- Whether to show virtual text
        handler_opts = {
            border = "none"
            }
        })
EOF

" Plug 'jpalardy/vim-slime'
let g:slime_target = "neovim"
let g:slime_python_ipython = 1
vnoremap . :SlimeSend<CR>

" Plug 'voldikss/vim-floaterm'
tnoremap ¬ <cmd>FloatermToggle<CR>
nnoremap ¬ <cmd>FloatermToggle<CR>

let g:floaterm_title = ""

" Plug 'nathangrigg/vim-beancount'
let g:beancount_separator_col=80
