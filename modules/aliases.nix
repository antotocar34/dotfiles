{
  flake.modules.homeManager.cli = {config, pkgs, lib, ...}: {
    options.home = {
      trueAliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.package;
        default = {};
        description = "Commands that should become true executables and receive shell completions.";
      };
      aliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "Shell aliases with completion support.";
      };
    };

    config = let
      cfg = config.home;
      writeCopy = name: drv: pkgs.writeShellScriptBin name ''exec ${lib.getExe drv} "$@"'';
      trueAliasPackages = lib.mapAttrsToList writeCopy cfg.trueAliases;
    in {
      home.trueAliases = lib.mkDefault {};
      home.aliases = lib.mkDefault {
        "la" = "ls -a";
        "lla" = "ls -la";
        "j" = "just";
        ".j" = "just -f ${config.configPath}/homedir/.config/global_justfile/justfile -d .";
      };
      home.packages = trueAliasPackages;

     programs.bash.shellAliases = config.home.aliases;
     programs.bash.initExtra = ''
          . ${pkgs.complete-alias}/bin/complete_alias
          ${lib.concatMapStringsSep "\n" (s: "complete -F _complete_alias ${s}") (lib.attrNames config.home.aliases)}
        '';
    };
  };
}
