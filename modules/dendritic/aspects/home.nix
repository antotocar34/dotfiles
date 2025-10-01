{ inputs, ... }:
{
  flake.modules.homeManager.home = args@{ pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      myLib = import ../../../lib { inherit pkgs; };
      base = import ../../../home.nix;
    in base (args // { inherit inputs system myLib; });
}
