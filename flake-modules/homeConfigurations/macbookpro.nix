{ inputs, ... }:
let
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs { inherit system; };
  root = ../..;
  myLib = import (root + "/lib") { inherit pkgs; };
in {
  flake.homeConfigurations."antoine.carnec@LONLTMC773WR0" =
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        (root + "/home.nix")
        (root + "/modules/host_specific")
        (root + "/modules/clipkgs")
        (root + "/modules/clipkgs/mac.nix")
        (root + "/modules/guipkgs")
        (root + "/modules/nix")
        (root + "/modules/mac")
        "${inputs.dotfiles-private}/modules"
        {
          config.host.user = "antoine.carnec";
          config.host.hostname = "LONLTMC773WR0";
          config.homedir = "/Users/antoine.carnec";
          config.host.isNixos = false;
          config.host.isDesktop = true;
        }
      ];
      extraSpecialArgs = {
        inherit inputs system;
        inherit myLib;
      };
    };
}
