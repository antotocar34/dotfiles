#! /bin/bash

curl -L https://nixos.org/nix/install | sh

. ${HOME}/.nix-profile/etc/profile.d/nix.sh

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update

export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

nix-shell '<home-manager>' -A install

. ${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh

printf "\n\n\n"
echo "Please run home-manager switch after importing the git repository"
printf "\n"
echo "Please also run the following."

echo """
. ${HOME}/.nix-profile/etc/profile.d/nix.sh
. ${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh
"""
