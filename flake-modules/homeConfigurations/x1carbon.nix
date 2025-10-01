{ inputs, ... }:
let
  system = "x86_64-linux";
  overlays = [
    inputs.nixgl.overlay
    (_: _: {
      nixGL = inputs.nixgl.defaultPackage.${system}.nixGLIntel;
    })
  ];
  pkgs = import inputs.nixpkgs {
    inherit system overlays;
  };
  root = ../..;
  myLib = import (root + "/lib") { inherit pkgs; };
in {
  flake.homeConfigurations."carneca@x1carbon" =
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        (root + "/home.nix")
        (root + "/modules")
        (root + "/modules/clipkgs/linux.nix")
        (root + "/modules/guipkgs/linux.nix")
        "${inputs.dotfiles-private}/modules"
        {
          config.host.isNixos = false;
          config.host.isDesktop = true;
          config.host.user = "carneca";
          config.host.hostname = "x1carbon";
          config.homedir = "/home/carneca";
        }
      ];
      extraSpecialArgs = {
        inherit inputs system;
        inherit myLib;
      };
    };
}
