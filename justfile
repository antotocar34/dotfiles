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
    mkdir -p ~/.ssh
    touch ~/.config/rbw_bootstrap/config.json
    export RBW_PROFILE=bootstrap
    read -p "Enter bitwarden login email: " bitwarden_email
    rbw config set email $bitwarden_email
    rbw config set pinentry "$(which pinentry)"
    rbw unlock
    rbw get --full ssh.antoine.sk > ~/.ssh/antoine
    rbw get --full ssh.github.sk > ~/.ssh/github
    umask 0022
    ssh-keygen -y -f ~/.ssh/antoine > ~/.ssh/antoine.pub
    ssh-keygen -y -f ~/.ssh/github > ~/.ssh/github.pub

@_get_hostname:
    #!/usr/bin/env bash
    printf '%s\n' '{"x1carbon":"x1carbon","LONLTMC773WR0":"LONLTMC773WR0"}' \
    | jq --exit-status -r --arg h "$HOSTNAME" '.[$h]? // empty' \
    || echo "server"

switch:
    #!/usr/bin/env bash
    GIT_SSH_COMMAND="ssh -i ~/.ssh/github" NIXPKGS_ALLOW_UNFREE=1 home-manager switch -v -b old_version --impure --flake .#$(just -q _get_hostname)
    # @just diff || exit 0

build:
    #!/usr/bin/env bash
    ARG=$(printf '%s\n' '{"x1carbon":"x1carbon","LONLTMC773WR0":"LONLTMC773WR0"}' \
    | jq --exit-status -r --arg h "$HOSTNAME" '.[$h]? // empty' \
    || echo "server")
    GIT_SSH_COMMAND="ssh -i ~/.ssh/github" NIXPKGS_ALLOW_UNFREE=1 home-manager build -v -b old_version --impure --flake .#$(just -q _get_hostname)

install_nix:
    sudo echo "trusted-users = root $(whoami)" >> /etc/nix/nix.conf
    sh <(curl -L https://nixos.org/nix/install) --daemon

update_input:
    #!/usr/bin/env bash
    inputs=$(nix flake metadata --json | jq .locks.nodes.root.inputs | jq -r 'keys[]' | fzf --multi)
    readarray -t inputArray <<<"$inputs"
    nix flake update ${inputArray[@]}


diff:
    home-manager generations | grep -oE "/nix/store/.*home-manager-generation" | head -2 | tac | xargs -n 2 nix run nixpkgs#nvd diff

b:
   nix build --impure .#homeConfigurations.${USER}@${HOSTNAME}.activationPackage

push_secrets:
   git submodule foreach just update
   nix flake update private-secrets

initialise_submodule:
  GIT_SSH_COMMAND="ssh -i ~/.ssh/github" git submodule update --init --recursive

update_secrets:
   git submodule foreach just force_update
   nix flake update dotfiles-private

test_secrets:
   git submodule foreach just force_update
   nix flake update dotfiles-private
   just build

commit:
  git commit -m "$(git diff --staged | ask -n 'write me a one sentence commit message for these changes')"

show_nixpkgs_version:
  @jq -r '.nodes.nixpkgs.locked.rev' flake.lock

repl:
  nix repl
