_default:
    @just --list

# start from zero
bootstrap: install_nix develop get_ssh switch

# get in a shell with home manager and rbw
develop:
    nix --extra-experimental-features nix-command --extra-experimental-features flakes develop .

# obtain ssh private key for homeage
get_ssh:
    rbw config set email "antoinecarnec@gmail.com"
    rbw get --full ssh >> ~/.ssh/antoine 

switch:
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch -b old --impure --flake .

install_nix:
    sh <(curl -L https://nixos.org/nix/install) --daemon
