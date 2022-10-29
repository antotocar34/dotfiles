# Installation

1. Make sure you have nix installed, if not run `sh <(curl -L https://nixos.org/nix/install) --daemon`
2. Clone this repo with `git clone https://github.com/antotocar34/dotfiles.git`
2. `nix --extra-experimental-features nix-command --extra-experimental-features flakes develop .`
3. `NIXPKGS_ALLOW_INSECURE=1 home-manager switch --impure --flake .`
