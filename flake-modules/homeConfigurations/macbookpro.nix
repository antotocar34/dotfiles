{ inputs, config, ... }:
let
  # TODO do I need system here?
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs { inherit system; };
  lib = inputs.nixpkgs.lib;
  use = names:
    lib.attrValues (lib.getAttrs names config.flake.modules.homeManager);
  hostConfig = config.flake.hosts.macbookpro;
  hostModule = { ... }: builtins.trace "applying hostModule" {
    config.host = hostConfig;
    config.homedir = hostConfig.homedir;
  };
in {
  flake.homeConfigurations."antoine.carnec@LONLTMC773WR0" =
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = (
      use [
        "host"
        # "macbookpro"
        "home"
        "cli"
        "gui"
        "nix"
        "mac"
      ]
        ) ++ [ hostConfig];
    };
}
