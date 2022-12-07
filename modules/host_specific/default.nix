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
      description = "whether this profile is a nixos profile or not";
    };
    isDesktop = l.mkOption {
      type = l.types.bool;
      description = "whether this profile is should include GUI applications";
    };
  };
}
