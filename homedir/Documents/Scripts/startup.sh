#!/bin/bash
# This breaks home-manager...
# . ~/.config/nixpkgs/homedir/.bash_profile 
sleep 2
source ~/.profile
${HOME}/.nix-profile/bin/sxhkd -r ~/.logs/sxhkd &
${HOME}/.nix-profile/bin/xbanish &
${HOME}/.nix-profile/bin/flameshot &
${HOME}/.nix-profile/bin/deluge &
# feh --bg-scale ${HOME}/Pictures/wallpapers/bigsur.jpg
xset r rate 280 50
