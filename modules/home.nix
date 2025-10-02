{config, lib, ...}:
{
  flake.modules.homeManager.home = { config, pkgs, host, ... }:
  let
    l = lib // builtins;
  in {
    options = {
      homedir = l.mkOption {
        type = l.types.str;
      };

      configPath = l.mkOption {
        type = l.types.str;
      };
    };

    config = let
      user = host.user;
      home = host.homedir;
      HOME_MANAGER_CONFIG = "${host.homedir}/.config/dotfiles";
    in {
      programs.home-manager.enable = true;

      home.username = user;
      home.homeDirectory = home;
      home.stateVersion = "21.03";

      home.sessionVariables = {
        LOCALE_ARCHIVE = "${home}/.nix-profile/lib/locale/locale-archive";
        NIXPKGS_ALLOW_UNFREE = 1;
        NIX_PATH = "nixpkgs=${pkgs.path}";
        SHELL = "${pkgs.bash}/bin/bash";
        inherit HOME_MANAGER_CONFIG;
      };

      home.shellAliases = {
        "hs" = ''fd -uu -eold_version -p . $HOME -X trash {} && just ${HOME_MANAGER_CONFIG}/switch'';
        "conf" = "cd ${HOME_MANAGER_CONFIG}";
        "gsee" = "cd $(mktemp -d) && git clone --depth 1 $(pbpaste)";
      };

      nixpkgs.config.allowUnfree = true;

      home.file = {
        ".config".source = ../homedir/.config;
        ".config".recursive = true;
        ".ssh".source = ../homedir/.ssh;
        ".ssh".recursive = true;
        ".xmodmap".source = ../homedir/.xmodmap;
        ".dir_colors".source = ../homedir/.dir_colors;
        ".timewarrior/timewarrior.cfg".source = ../homedir/.timewarrior/timewarrior.cfg;
        ".ghc/ghci.conf".source = ../homedir/.ghc/ghci.conf;
        ".muttrc".source = ../homedir/.muttrc;
        # ".Rprofile".source = ../../../homedir/.config/R/Rprofile;
        ".ipython".source = ../homedir/.ipython;
        ".ipython".recursive = true;
      };

      news.display = "silent";
    };
  };
}
