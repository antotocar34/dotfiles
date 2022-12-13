{
  config,
  pkgs,
  lib,
  ...
}: let
  l = lib // builtins;
  cfg = config.imp;
  inherit (l) mkIf;
  inherit (l.options) mkEnableOption mkOption;
in {
  options.imp = {
    enable = mkEnableOption "Enable imp";
    impHome = mkOption {
      type = l.types.str;
      default = ".local/share/imp_home";
      description = "Path to home of imp container from user home";
    };
  };

  config = mkIf cfg.enable {
    home.packages = let
      name = "imp";
      deps = with pkgs; [distrobox xorg.xhost];
      imp = pkgs.symlinkJoin {
        inherit name;
        paths =
          [(pkgs.writeShellScriptBin name ../../homedir/Documents/Scripts/imp)]
          ++ deps;
        buildInputs = [pkgs.makeWrapper];
        postBuild = "wrapProgram $out/bin/imp --prefix PATH : $out/bin";
      };
    in [
      pkgs.distrobox
      imp
    ];

    home.file = let
      user = "carneca";
      impHomeFull = "/home/${user}/${cfg.impHome}";
    in {
      "imp_home".source = ../../homedir;
      "imp_home".recursive = true;
      "imp_home".target = "${cfg.impHome}";

      "imp_profile".text = ''
        . ${impHomeFull}/.bashrc
        . <(cat ${../../homedir/.config/bash_shortcuts}/*.bash)
        export XDG_DATA_DIRS="${impHomeFull}/.local/share:$XDG_DATA_DIRS"
        export XDG_CONFIG_DIRS="${impHomeFull}/.config:$XDG_CONFIG_DIRS"
        export XDG_CONFIG_HOME="${impHomeFull}/.config"
        export IMP=1
        red=$(tput setaf 1)
        normal=$(tput sgr0)
        message="Welcome to ''${red}impurity...''${normal}"
        echo "$message"
      '';
      "imp_profile".target = "${cfg.impHome}/.profile";
    };
  };
}
