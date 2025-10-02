{ lib, ... }:
let
  # l = inputs.nixpkgs.lib;
  host_options = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary username.";
    };
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Machine hostname.";
    };
    isNixos = lib.mkOption {
      type = lib.types.bool;
      description = "Whether this profile targets NixOS.";
    };
    isDesktop = lib.mkOption {
      type = lib.types.bool;
      description = "Whether this profile includes GUI applications.";
    };
    homedir = lib.mkOption {
      type = lib.types.str;
      description = "Primary home directory.";
    };
  };
  host_options_type = lib.types.submodule ({...}: { options = host_options; });
in {
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf host_options_type;
    default = {};
    description = "Host metadata keyed by identifier.";
  };
}

