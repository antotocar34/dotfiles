{
  config,
  pkgs,
  ...
}: let
  l = pkgs.lib // builtins;
in {
  options.host = {
    isNixos = l.mkOption {
      type = l.types.bool;
      description = "Whether this profile is a nixos profile or not";
    };
    isDesktop = l.mkOption {
      type = l.types.bool;
      description = "Whether this profile is should include GUI applications";
    };
    user = l.mkOption {
        type = l.types.str ;
        description = "User name";
    };
    hostname = l.mkOption {
        type = l.types.str ;
        description = "Hostname of the user";
    };
  };
}
