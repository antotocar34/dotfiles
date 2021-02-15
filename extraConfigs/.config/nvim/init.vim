if exists("g:ink_on")
      source ~/.config/nixpkgs/extraConfigs/minimal-vimrc.vim
else

let mapleader = " "
let home = $HOME

source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/plugins.vim
source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/settings.vim
source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/bindings.vim
source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/colours.vim
source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/file_specific.vim
source /home/carneca/.config/nixpkgs/extraConfigs/.config/nvim/modules/lsp.vim

endif
