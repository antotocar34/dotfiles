_default:
    @just --list

# start from zero
bootstrap: install_nix develop switch get_ssh 

# get in a shell with home manager and rbw
develop:
    nix --extra-experimental-features nix-command --extra-experimental-features flakes develop .

# obtain ssh private keys for agenix and github
get_ssh:
    #!/usr/bin/env bash
    set -e
    umask 0066
    rm ~/.config/rbw/config.json 2> /dev/null || true
    mkdir -p ~/.config/rbw_bootstrap 2> /dev/null || true
    touch ~/.config/rbw_bootstrap/config.json
    export RBW_PROFILE=bootstrap
    read -p "Enter bitwarden login email: " bitwarden_email
    rbw config set email $bitwarden_email
    rbw config set pinentry "$(which pinentry)"
    rbw get --full ssh.antoine.sk > ~/.ssh/antoine
    rbw get --full ssh.github.sk > ~/.ssh/github
    umask 0022
    ssh-keygen -y -f ~/.ssh/antoine > ~/.ssh/antoine.pub
    ssh-keygen -y -f ~/.ssh/github > ~/.ssh/github.pub

switch:
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch -b old_version --impure --flake .#${USER}@${HOSTNAME}
    @just diff || exit 0

install_nix:
    sh <(curl -L https://nixos.org/nix/install) --daemon

update_input:
    #!/usr/bin/env bash
    inputs=$(nix flake metadata --json | jq .locks.nodes.root.inputs | jq -r 'keys[]' | fzf --multi)
    readarray -t inputArray <<<"$inputs"
    nix flake update ${inputArray[@]}

build:
    nix build --impure .#homeConfigurations.${USER}-${HOSTNAME}.activationPackage

diff:
    home-manager generations | grep -oE "/nix/store/.*home-manager-generation" | head -2 | tac | xargs -n 2 nix run nixpkgs#nvd diff

b:
   nix build --impure .#homeConfigurations.${USER}@${HOSTNAME}.activationPackage

push_secrets:
   git submodule foreach just update
   nix flake update private-secrets

initialise_submodule:
  git submodule update --init --recursive

test_secrets:
   git submodule foreach just force_update
   nix flake update dotfiles-private
   just switch

commit:
  git commit -m "$(git diff --staged | ask -n 'write me a one sentence commit message for these changes')"
