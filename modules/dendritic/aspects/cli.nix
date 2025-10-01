{ inputs, ... }:
{
  flake.modules.homeManager.cli = args@{ pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      myLib = import ../../../lib { inherit pkgs; };
      base = import ../../clipkgs;
    in base (args // { inherit inputs system myLib; });
}
