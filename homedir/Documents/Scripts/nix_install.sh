#! /bin/bash

curl -L https://nixos.org/nix/install | sh

. ${HOME}/.nix-profile/etc/profile.d/nix.sh

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update

export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

mkdir -p ~/.test/trash
mv ~/.bashrc ~/.bash_profile ~/.config/kwinrulesrc ~/.config/kwinrc ~/.dir_colors ~/.test/trash

nix-shell '<home-manager>' -A install

printf "Generating github ssh key.\n"
ssh-keygen -t rsa -f ${HOME}/.ssh/github -q -P ""
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/github

printf "\n"
echo """
Please add ~/.ssh/github.pub to your github account.

Please run the following commands:
. ${HOME}/.nix-profile/etc/profile.d/nix.sh
. ${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh
"""
printf "\n\n"
echo "Please run home-manager switch after importing the git repository"
