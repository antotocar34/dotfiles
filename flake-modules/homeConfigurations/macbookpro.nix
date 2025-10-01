{ inputs, config, ... }:
let
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs { inherit system; };
  lib = inputs.nixpkgs.lib;
  use = names:
    lib.attrValues (lib.getAttrs names config.flake.modules.homeManager);
in {
  flake.homeConfigurations."antoine.carnec@LONLTMC773WR0" =
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = use [
        "host"
        "host-macbookpro"
        "home"
        "cli"
        "gui"
        "nix"
        "mac"
      ];
    };
}
