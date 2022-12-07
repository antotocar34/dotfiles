#!/bin/bash
# This breaks home-manager...
# . ~/.config/nixpkgs/extraConfigs/.bash_profile 
sleep 2
source ~/.profile
sxhkd -r ~/.logs/sxhkd &
xbanish &
flameshot &
deluge &
# feh --bg-scale ${HOME}/Pictures/wallpapers/bigsur.jpg
xset r rate 280 50
