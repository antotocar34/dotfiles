{ inputs, config, ... }:
let
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs { inherit system; };
  root = ../..;
  myLib = import (root + "/lib") { inherit pkgs; };
  hmFeatures = config.flake.modules.homeManager;
  featureModules = [
    hmFeatures."host-options"
    hmFeatures."host-macbookpro"
    hmFeatures."home-basics"
    hmFeatures."cli-core"
    hmFeatures."cli-mac"
    hmFeatures."gui-core"
    hmFeatures."nix-core"
    hmFeatures."mac-skhd"
    "${inputs.dotfiles-private}/modules"
  ];
in {
  flake.homeConfigurations."antoine.carnec@LONLTMC773WR0" =
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = featureModules;
      extraSpecialArgs = {
        inherit inputs system;
        inherit myLib;
      };
    };
}
