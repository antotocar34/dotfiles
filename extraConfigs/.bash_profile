# this line does not crash home manager
source ${HOME}/.nix-profile/etc/profile.d/nix.sh

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

cp -Lr ~/.nix-profile/share/applications/*.desktop ~/.local/share/applications 2> /dev/null
