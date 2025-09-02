if exists("g:ink_on")
      source ~/.config/nixpkgs/homedir/minimal-vimrc.vim
else

let mapleader = " "
let home = $HOME
let nvim_folder = "/home/carneca/.config/nixpkgs/homedir/.config/nvim/modules/"

execute "source " . nvim_folder . "plugins.vim"
execute "source " . nvim_folder . "settings.vim"
execute "source " . nvim_folder . "bindings.vim"
execute "source " . nvim_folder . "colours.vim"
execute "source " . nvim_folder . "file_specific.vim"
execute "source " . nvim_folder . "lsp.vim"

endif
