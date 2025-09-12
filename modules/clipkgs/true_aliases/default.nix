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
      type = t.attrsOf t.package;
    };

    aliases = l.mkOption {
      type = t.attrsOf t.str;
    };
  };

  config = let
    writeCopy = name: drv: pkgs.writeShellScriptBin name ''exec ${l.getExe drv} "$@"'';
  in {
    home.packages = l.mapAttrsToList writeCopy cfg.trueAliases;


    programs.bash.shellAliases = cfg.aliases;

    # Add completion-aliases to alias and to package
    programs.bash.initExtra = lib.mkAfter (
      ''
        . ${pkgs.complete-alias}/bin/complete_alias
      '' 
      +
      l.concatMapStringsSep "\n" (s: "complete -F _complete_alias ${s}") (l.attrNames cfg.aliases)
    );
  };
}
