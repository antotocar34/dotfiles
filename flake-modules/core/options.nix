{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
in {
  options.flake.homeConfigurations = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = {};
    description = "Home Manager configurations keyed by user and host.";
  };
}
