{ config, lib, pkgs, ... }:
let
  l = lib // builtins;
  system = pkgs.stdenv.hostPlatform.system;
  HOME_MANAGER_CONFIG = "${config.homedir}/.config/dotfiles";
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
    user = config.flake.hosts.macbookpro.user;
    home = config.homedir;
  in {
    programs.home-manager.enable = true;

    configPath = HOME_MANAGER_CONFIG;
    home.username = user;
    home.homeDirectory = home;

    home.stateVersion = "21.03";

    home.sessionVariables = {
      LOCALE_ARCHIVE = "${home}/.nix-profile/lib/locale/locale-archive";
      R_PROFILE_USER = "${home}/.config/R/.Rprofile";
      NIXPKGS_ALLOW_UNFREE = 1;
      NIX_PATH = "nixpkgs=${pkgs.path}";
      SHELL = "${pkgs.bash}/bin/bash";
      HOME_MANAGER_CONFIG = HOME_MANAGER_CONFIG;
    };

    home.shellAliases = {
      "hs" = ''fd -uu -eold_version -p . $HOME -X trash {} && just ${HOME_MANAGER_CONFIG}/switch'';
      "conf" = "cd ${HOME_MANAGER_CONFIG}";
      "gsee" = "cd $(mktemp -d) && git clone --depth 1 $(pbpaste)";
    };

    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      (writeShellScriptBin "nvim-old" ''
        exec "${l.getExe pkgs.neovim}" "$@"
      '')
      neovim-remote
      mutt
      msmtp
      ledger
      beancount
      fava
      cascadia-code
      nerd-fonts.caskaydia-cove
    ];

    fonts.fontconfig.enable = true;

    home.file = {
      ".config".source = ../../../homedir/.config;
      ".config".recursive = true;
      ".ssh".source = ../../../homedir/.ssh;
      ".ssh".recursive = true;
      ".xmodmap".source = ../../../homedir/.xmodmap;
      ".dir_colors".source = ../../../homedir/.dir_colors;
      ".timewarrior/timewarrior.cfg".source = ../../../homedir/.timewarrior/timewarrior.cfg;
      ".ghc/ghci.conf".source = ../../../homedir/.ghc/ghci.conf;
      ".muttrc".source = ../../../homedir/.muttrc;
      ".Rprofile".source = ../../../homedir/.config/R/Rprofile;
      ".ipython".source = ../../../homedir/.ipython;
      ".ipython".recursive = true;
    };

    news.display = "silent";
  };
}
