# source ${HOME}/.nix-profile/etc/profile.d/nix.sh

export HOST=$HOSTNAME

export XDG_DATA_DIRS="/usr/local/share/:/usr/share/:$XDG_DATA_DIRS"
export XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"

# PATH VARIABLE DECLARATIONS
export PATH="${HOME}/.local/bin:$PATH"
export PATH="${HOME}/Documents/Scripts:$PATH"
export PATH="${HOME}/Documents/Scripts/inkscape-draw:$PATH"
# export PATH="/opt/Stata/stata14/:$PATH"
export PATH="${HOME}/.cabal/bin/stylish-haskell:$PATH"
export PATH="${HOME}/.elan/bin:$PATH"

export EDITOR=$(which nvim)

export LEDGER_FILE=/home/carneca/Documents/Finances/journal.beancount

# To make rofi recognized nix installed applications
# cp -Lr ~/.nix-profile/share/applications/*.desktop ~/.local/share/applications 2> /dev/null

. ~/.config/nixpkgs/homedir/.config/bash_shortcuts/functions.bash
