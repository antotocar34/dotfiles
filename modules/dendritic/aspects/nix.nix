{ inputs, ... }:
{
  flake.modules.homeManager.nix = args@{ pkgs, ... }:
    let base = import ../../nix;
    in base (args // { inherit inputs; });
}
