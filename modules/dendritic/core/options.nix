{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
in {
  options.flake.modules.homeManager = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = {};
    description = "Dendritic home-manager feature modules keyed by aspect.";
  };
}
