# Installation

1. Make sure you have nix installed, if not run `sh <(curl -L https://nixos.org/nix/install) --daemon`
2. Clone this repo with `git clone https://github.com/antotocar34/dotfiles.git`
3. `nix --extra-experimental-features nix-command --extra-experimental-features flakes develop .`
4. Install ssh private key in `~/.ssh' 
5. `export NIXPKGS_ALLOW_UNFREE=1; home-manager switch -b old --impure --flake .`

# TODO
https://vic.github.io/dendrix/Dendritic.html



# IDEA
Have profiles, with two ideas:
  - Broad profiles
    - Something needed by general user
  - Detailed profiles
    - Something needed by a specific server
