#!/bin/bash
# This breaks home-manager...
# . ~/.config/nixpkgs/extraConfigs/.bash_profile 
sleep 2
source ~/.profile
${HOME}/.nix-profile/bin/sxhkd & 2> ~/debug_sxhkd
${HOME}/.nix-profile/bin/xbanish &
${HOME}/.nix-profile/bin/flameshot & 2> ~/debug_flameshot
xset r rate 280 50
