{
  config,
  lib,
  pkgs,
  inputs,
  myLib,
  ...
}: let
  l = builtins // lib;
  ml = myLib;

  # Personal Info
  user = "${config.host.user}";
  home = "/home/${user}";
  hostname = "${config.host.hostname}";
  name = "Antoine Carnec";
  email = "antoinecarnec@gmail.com";
  HOME_MANAGER_CONFIG = "${home}/.config/nixpkgs";
in {
  programs.home-manager.enable = true;

  home.username = "${user}";
  home.homeDirectory = "${home}";

  home.stateVersion = "21.03"; # Don't touch

  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = ''
      ag --hidden --ignore .cache --ignore .git --ignore .vim --ignore .local -l -g ""
    '';
    LOCALE_ARCHIVE = "${home}/.nix-profile/lib/locale/locale-archive";
    R_PROFILE_USER = "${home}/.config/R/.Rprofile";
    NIXPKGS_ALLOW_UNFREE = 1;
    # PDF_VIEWER = "${getExe pkgs.zathura}";
    PDF_VIEWER = "${lib.getExe pkgs.sioyek}";
    NIX_PATH = "nixpkgs=${pkgs.path}"; # Is this a good idea, the overlays are applied...
    inherit HOME_MANAGER_CONFIG;
  };

  home.shellAliases = {
    "hs" = ''fd -uu -eold_version -p . $HOME -X trash {} && just ${HOME_MANAGER_CONFIG}/switch'';
    "conf" = "cd ${HOME_MANAGER_CONFIG}";
    "gsee" = "cd $(mktemp -d) && git clone --depth 1 $(xclip -o -sel clip)";
  };

  home_config = "${home}/.config/nixpkgs";

  nix = l.mkIf (! config.host.isNixos) {
    package = pkgs.nix;
    settings = {
      # Better defaults
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
      log-lines = 25;
      sandbox = "relaxed";
      build-use-sandbox = "true";
      min-free = 128000000;
      max-free = 1000000000;
      max-jobs = "auto";
      auto-optimise-store = true;
      fallback = true;
      # keep-outputs = true;
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      acpkgs.flake = inputs.acpkgs;
    };
  };

  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Some window manager utilities
    systemd
    sxhkd
    xdotool
    xorg.xrandr
    xorg.xwininfo
    xbanish # Hides cursor on key press

    # text editor
    # (
    #   writeShellScriptBin "nvim-nix" ''
    #   exec "${neovimAC}/bin/nvim" "$@"
    #   ''
    # )
    neovim
    neovim-remote # Needed for SyncTex

    mutt # emailer
    msmtp #

    # plain text accounting
    ledger
    beancount
    fava

    # productivity
    # taskwarrior
    # timewarrior

    # useful programs

    (nerdfonts.override {fonts = ["CascadiaCode"];}) # fonts

    # TODO Move to a flake?
    texlive.combined.scheme-full
    # (texlive.combine {
    #   inherit
    #     (texlive)
    #     # Main suite
        
    #     scheme-medium
    #     # Extra packages
        
    #     wrapfig
    #     was
    #     svg
    #     bbm
    #     collection-fontsextra
    #     trimspaces
    #     catchfile
    #     transparent
    #     titlesec
    #     import
    #     preprint
    #     enumitem
    #     ;
    # })

    # Misc
    nix-index
    # nix-bash-completions
    complete-alias
    glibcLocales
    powerline-fonts

    nixGL
  ];

  # Apply plasma settings
  programs.plasma = import ./homedir/.config/plasma-settings/plasma_settings.nix;

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
    ".taskrc".source = ./homedir/.taskrc; # taskwarrior configuration
    ".dir_colors".source = ./homedir/.dir_colors;
    ".timewarrior/timewarrior.cfg".source = ./homedir/.timewarrior/timewarrior.cfg;
    "Pictures/wallpapers/bigsur.jpg".source = ./homedir/Pictures/wallpapers/bigsur.jpg;
    ".ghc/ghci.conf".source = ./homedir/.ghc/ghci.conf;
    ".muttrc".source = ./homedir/.muttrc;
    ".Rprofile".source = ./homedir/.config/R/Rprofile;
  };

  # Secrets
  homeage = {
    identityPaths = ["${home}/.ssh/antoine"];
    installationType = "activation";

    file."rclone_config" = {
      source = ./homedir/.config/rclone/rclone.conf.age;
      copies = ["${home}/.config/rclone/rclone.conf"];
    };

    file."msmtp_config" = {
      source = ./homedir/.config/msmtp/config.age;
      copies = ["${home}/.config/msmtp/config"];
    };
    file."weekly_dl_config" = {
      source = ./homedir/.config/weekly_dl/config.json.age;
      copies = ["${home}/.config/weekly_dl/config.json"];
    };
  };

  xsession.enable = false;

  # disable notifications about home-manager news
  news.display = "silent";

  imp.enable = true;
}
