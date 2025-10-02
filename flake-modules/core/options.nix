{ inputs, pkgs, ... }:
let
  l = inputs.nixpkgs.lib // builtins;
in {
  options = {
    flake.homeConfigurations = l.mkOption {
      type = l.types.attrsOf l.types.raw;
      default = {};
      description = "Home Manager configurations keyed by user and host.";
    };
    # modules.homeManager = l.mkOption {
    #   type = l.types.attrsOf l.types.raw;
    #   default = {};
    #   description = "Dendritic home-manager feature modules keyed by aspect.";
    # };

    # modules.host = l.mkOption {
    #   type = l.types.attrsOf l.types.raw;
    #   default = {};
    #   description = "Standalone host modules keyed by identifier.";
    # };

    hosts = l.mkOption {
      type = l.types.attrsOf (l.types.submodule ({ ... }: {
        options = {
          user = l.mkOption {
            type = l.types.str;
            description = "Primary username.";
          };
          hostname = l.mkOption {
            type = l.types.str;
            description = "Machine hostname.";
          };
          isNixos = l.mkOption {
            type = l.types.bool;
            description = "Whether this profile targets NixOS.";
          };
          isDesktop = l.mkOption {
            type = l.types.bool;
            description = "Whether this profile includes GUI applications.";
          };
          homedir = l.mkOption {
            type = l.types.str;
            description = "Primary home directory.";
          };
        };
      }));
      default = {};
      description = "Host metadata keyed by identifier.";
    };
  };

}
