_default:
    @just --list

# start from zero
bootstrap: install_nix develop get_ssh switch

# get in a shell with home manager and rbw
develop:
    nix --extra-experimental-features nix-command --extra-experimental-features flakes develop .

# obtain ssh private key for homeage
get_ssh:
    rm ~/.config/rbw/config.json 2> /dev/null || true
    mkdir -p ~/.config/rbw 2> /dev/null || true
    touch ~/.config/rbw/config.json
    rbw config set email "antoinecarnec@gmail.com"
    rbw config set pinentry "tty"
    rbw get --full ssh > ~/.ssh/antoine 

switch:
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch -b old_version --impure --flake .#${USER}@${HOSTNAME}
    # just diff

install_nix:
    sh <(curl -L https://nixos.org/nix/install) --daemon

update_input:
    #!/usr/bin/env bash
    inputs=$(nix flake metadata --json | jq .locks.nodes.root.inputs | jq -r 'keys[]' | fzf --multi)
    readarray -t inputArray <<<"$inputs"
    nix flake lock ${inputArray[@]/#/--update-input }

build:
    nix build --impure .#homeConfigurations.${USER}-${HOSTNAME}.activationPackage

diff:
    home-manager generations | grep -oE "/nix/store/.*home-manager-generation" | head -2 | tac | xargs -n 2 nix run nixpkgs#nvd diff

logout:
    qdbus org.kde.ksmserver /KSMServer logout 0 0 0

b:
   nix build --impure .#homeConfigurations.${USER}@${HOSTNAME}.activationPackage

update_secrets:
   git submodule foreach just update
   nix flake update private-secrets

initialise_submodule:
  git submodule update --init --recursive
