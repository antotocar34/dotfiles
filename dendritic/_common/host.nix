{ pkgs, ... }:
let
  l = pkgs.lib // builtins;
in {
  options.host = {
    isNixos = l.mkOption {
      type = l.types.bool;
      description = "Whether this profile targets NixOS.";
    };
    isDesktop = l.mkOption {
      type = l.types.bool;
      description = "Whether this profile includes GUI applications.";
    };
    user = l.mkOption {
      type = l.types.str;
      description = "Primary username.";
    };
    hostname = l.mkOption {
      type = l.types.str;
      description = "Machine hostname.";
    };
    homedir = l.mkOption {
      type = l.types.str;
      description = "Primary home directory.";
    };
  };
}
