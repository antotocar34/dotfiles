{
  config,
  pkgs,
  lib,
  ...
}: let
  l = lib // builtins;
  t = l.types;
  cfg = config.home;
in {
  options.home = {
    trueAliases = l.mkOption {
      type = t.attrsOf (t.package);
    };
  };

  config = let
    writeCopy = name: drv: pkgs.writeShellScriptBin name ''${l.getExe drv} "$@"'';
  in {
    home.packages = l.mapAttrsToList writeCopy cfg.trueAliases;
  };
}
