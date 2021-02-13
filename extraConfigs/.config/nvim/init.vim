"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"
"
"
if exists("g:ink_on")
      source ~/.config/nixpkgs/extraConfigs/minimal-vimrc.vim
else

let mapleader =" "
let home = $HOME


source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/plugins.vim
source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/settings.vim
source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/bindings.vim
source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/colors.vim
source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/file_specific.vim
source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/lsp.vim



set noshowmode  " to get rid of thing like --INSERT--
" set noshowcmd  " to get rid of display of last command
" set shortmess+=F  " to get rid of the file name displayed in the command line bar

endif
