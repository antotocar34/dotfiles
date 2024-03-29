{
  config,
  lib,
  pkgs,
  inputs,
  myLib,
  ...
}: let
  l = lib // builtins;

  # Personal Info
  user = "${config.host.user}";
  home = "/home/${user}";
  HOME_MANAGER_CONFIG = "${home}/.config/nixpkgs";
in {
  programs.home-manager.enable = true;

  home.username = "${user}";
  home.homeDirectory = "${home}";

  home.stateVersion = "21.03"; # Don't touch

  home.sessionVariables = {
    LOCALE_ARCHIVE = "${home}/.nix-profile/lib/locale/locale-archive";
    R_PROFILE_USER = "${home}/.config/R/.Rprofile";
    NIXPKGS_ALLOW_UNFREE = 1;
    PDF_VIEWER = "${l.getExe pkgs.zathura}";
    # PDF_VIEWER = "${lib.getExe pkgs.sioyek}";
    NIX_PATH = "nixpkgs=${pkgs.path}";
    inherit HOME_MANAGER_CONFIG;
  };

  home.shellAliases = {
    "hs" = ''fd -uu -eold_version -p . $HOME -X trash {} && just ${HOME_MANAGER_CONFIG}/switch'';
    "conf" = "cd ${HOME_MANAGER_CONFIG}";
    "gsee" = "cd $(mktemp -d) && git clone --depth 1 $(xclip -o -sel clip)";
  };

  home_config = "${home}/.config/nixpkgs";

  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Some window manager utilities
    systemd
    xdotool
    xorg.xrandr
    xorg.xwininfo

    # text editor
    (
      writeShellScriptBin "nvim-old" ''
      exec "${l.getExe pkgs.neovim}" "$@"
      ''
    )
    neovim-remote # Needed for SyncTex

    mutt # emailer
    msmtp #

    # plain text accounting
    ledger
    beancount
    fava

    # useful programs
    (nerdfonts.override {fonts = ["CascadiaCode"];}) # fonts

    texlive.combined.scheme-full

    # Misc
    nix-index
    # nix-bash-completions
    glibcLocales
    powerline-fonts
  ];

  xdg = {
    enable = true;
    cacheHome = "${home}/.cache";
    configHome = "${home}/.config";
    dataHome = "${home}/.local/share";
    systemDirs.config = ["${HOME_MANAGER_CONFIG}/homedir/.config"];
  };

  home.file = {
    # Directories
    ".config".source = ./homedir/.config;
    ".config".recursive = true;

    # Files
    ".ssh".source = ./homedir/.ssh;
    ".ssh".recursive = true;
    ".xmodmap".source = ./homedir/.xmodmap;
    ".dir_colors".source = ./homedir/.dir_colors;
    ".timewarrior/timewarrior.cfg".source = ./homedir/.timewarrior/timewarrior.cfg;
    ".ghc/ghci.conf".source = ./homedir/.ghc/ghci.conf;
    ".muttrc".source = ./homedir/.muttrc;
    ".Rprofile".source = ./homedir/.config/R/Rprofile;
    ".ipython".source = ./homedir/.ipython;
    ".ipython".recursive = true;
  };

  xsession.enable = false;

  # disable notifications about home-manager news
  news.display = "silent";

  imp.enable = false;
}
