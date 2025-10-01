{ inputs, ... }:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs { inherit system; };
  root = ../..;
  myLib = import (root + "/lib") { inherit pkgs; };
  user = "error";
  hostname = "error";
in {
  flake.homeConfigurations."server" =
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        (root + "/home.nix")
        (root + "/modules/host_specific")
        (root + "/modules/nix")
        (root + "/modules/clipkgs")
        (root + "/modules/clipkgs/linux.nix")
        "${inputs.dotfiles-private}/modules"
        {
          config.host.isNixos = false;
          config.host.isDesktop = true;
          config.host.user = user;
          config.host.hostname = hostname;
          config.homedir = "/home/${user}";
        }
      ];
      extraSpecialArgs = {
        inherit inputs system;
        inherit myLib;
      };
    };
}
