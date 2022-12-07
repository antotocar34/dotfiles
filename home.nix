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
  user = "carneca";
  home = "/home/${user}";
  name = "Antoine Carnec";
  hostname = "x1carbon";
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
    NIX_PATH="nixpkgs=${pkgs.path}"; # Is this a good idea, the overlays are applied...
    inherit HOME_MANAGER_CONFIG;
  };

  home.shellAliases = {
    "hs" = ''fd -uu -eold_version -p . $HOME -X trash {} && just ${HOME_MANAGER_CONFIG}/switch'';
    "conf" = "cd ${HOME_MANAGER_CONFIG}";
    "gsee" = "cd $(mktemp -d) && git clone --depth 1 $(xclip -o -sel clip)";
  };

  nix = l.mkIf (! config.isNixos) {
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

  home.packages = with pkgs;
    [
      # Some window manager utilities
      systemd
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
      taskwarrior
      timewarrior

      # useful programs
      cmus # Music player
      vifm # terminal file manager

      rofi

      (nerdfonts.override {fonts = ["CascadiaCode"];}) # fonts

      # TODO Move to a flake?
      (texlive.combine {
        inherit
          (texlive)
          # Main suite
          
          scheme-medium
          # Extra packages
          
          wrapfig
          was
          svg
          bbm
          collection-fontsextra
          trimspaces
          catchfile
          transparent
          titlesec
          import
          preprint
          enumitem
          ;
      })

      # Misc
      nix-index
      # nix-bash-completions
      complete-alias
      glibcLocales
      powerline-fonts

      nixGL
    ]
    ## Gui applications
    ++ l.lists.optionals config.isDesktop
    (
      [
        mcomix3 # comic reader
        zathura # pdf reader
        sioyek
        flameshot

        element-web
        vlc # media player
        mpv # lightweight media player
        feh # image viewer
        # whatsapp-for-linux
        # signal-desktop
        bitwarden
        rofi-rbw
        discord
        gnome3.gnome-disk-utility
        gnome3.pomodoro
        # filezilla # FTP client
        krita # Drawing Application
        transcribe #
        xournalpp # note taking
        libreoffice-fresh
        spotify
        inkscape
        gimp
        deluge
      ]
      ++
      # For those applications that need to be wrapped with nixGL
      (
        map (
          if ! config.isNixos
          then (ml.wrapWithNixGL nixGL)
          else x: x
        )
        [
          calibre
          kitty
          stremio # media streaming client
        ]
      )
    );

  ## MODULES
  programs = {
    git = {
      enable = true;

      aliases = {
        lg = ''log --graph --abbrev-commit --decorate --date=short -10 --format=format:"%C(bold blue)%h%C(reset) %C(bold yellow)%d%C(reset) %C(white)%s%C(reset) %C(green)(%ad)%C(reset) %C(dim white)- %an%C(reset)"'';
        te = ''log --all --graph --decorate=short --color --date=short --format=format:"%C(bold blue)%h%C(reset) %C(bold yellow)%d%C(reset) %C(white)%s%C(reset) %C(green)(%ad)%C(reset) %C(dim white)- %an%C(reset)"'';
        st = "status --short";
        wdiff = "diff --word-diff=color";
        unstage = "reset HEAD --";
      };
      userName = "${name}";
      userEmail = "${email}";
      # includes = [
      #   {
      #     path = "~/carneca/.config/nixpkgs/extraConfigs/.config/git/website"
      #     # contents = {
      #     #   userName = "antoinecarnec" ;
      #     #   userEmail = "antoinecarnec2@gmail.com" ;
      #     #              } ;
      #       condition = "gitdir:~/Documents/Website/antoinecarnec.github.io" ;
      #   }
      # ] ;

      delta.enable = true;
      delta.options = {
        syntax-theme = "Nord";
        side-by-side = "false";
        paging = "auto";
        line-numbers = "true";
        hunk-header-style = "omit";
        line-numbers-zero-style = "#4C566A";
        # plus-emph-style = "syntax '#A3BE8C'" ;
      };
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };

    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = l.readFile ./extraConfigs/.bash_profile;
      initExtra = l.readFile ./extraConfigs/.bashrc;
    };

    bat = {
      enable = true;
      config = {theme = "Nord";};
    };

    firefox = {
      enable = config.isDesktop;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    ssh = {
      enable = true;
      matchBlocks = {
        "website" = {
          user = "git";
          port = 22;
          hostname = "github.com";
          host = "github.com-antoinecarnec";
          identityFile = "~/.ssh/website";
        };
        "github" = {
          user = "git";
          port = 22;
          hostname = "github.com";
          host = "github.com";
          identityFile = "~/.ssh/github";
        };
        "x1carbon" = {
          user = "carneca";
          hostname = "x1carbon";
          host = "x1carbon";
          identityFile = "~/.ssh/${hostname}";
        };
      };
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      escapeTime = 1;
      keyMode = "vi";
      newSession = true;
      shortcut = "k";
      extraConfig = builtins.readFile ./extraConfigs/.tmux.conf;
    };

    rbw = {
      enable = true;
      settings = {
        pinentry = "tty";
        inherit email;
      };
    };
  };

  # Apply plasma settings
  programs.plasma = import ./extraConfigs/plasma_settings.nix;

  xdg = {
    enable = true;
    cacheHome = "/home/carneca/.cache";
    configHome = "/home/carneca/.config";
    dataHome = "/home/carneca/.local/share";
    systemDirs.config = ["${HOME_MANAGER_CONFIG}/extraConfigs/.config"];
  };

  home.file = {
    # Directories
    ".config".source = ./extraConfigs/.config;
    ".config".recursive = true;
    ".ssh".source = ./homedir/.ssh;
    ".ssh".recursive = true;

    # Files
    ".xmodmap".source = ./homedir/.xmodmap;
    ".taskrc".source = ./homedir/.taskrc; # taskwarrior configuration
    ".dir_colors".source = ./homedir/.dir_colors;
    ".timewarrior/timewarrior.cfg".source = ./extraConfigs/timewarrior.cfg;
    "Pictures/wallpapers/bigsur.jpg".source = ./homedir/Pictures/wallpapers/bigsur.jpg;
    ".ghc/ghci.conf".source = ./homedir/.ghc/ghci.conf;
    ".muttrc".source = ./homedir/.muttrc;
    ".Rprofile".source = ./extraConfigs/.config/R/Rprofile;
  };

  # Secrets
  homeage = {
    identityPaths = ["${home}/.ssh/antoine"];
    installationType = "activation";

    file."rclone_config" = {
      source = ./extraConfigs/.config/rclone/rclone.conf.age;
      copies = ["${home}/.config/rclone/rclone.conf"];
    };

    file."msmtp_config" = {
      source = ./extraConfigs/.config/msmtp/config.age;
      copies = ["${home}/.config/msmtp/config"];
    };
    file."weekly_dl_config" = {
      source = ./extraConfigs/.config/weekly_dl/config.json.age;
      copies = ["${home}/.config/weekly_dl/config.json"];
    };
  };

  # SERVICES
  services = {
    sxhkd = {
      enable = config.isDesktop;
      extraOptions = ["-c ${home}/.config/sxhkd/sxhkdrc" "-r ${home.homeDirectory}/.logs/sxhkd"];
    };
  };

  xsession.enable = false;

  # disable notifications about home-manager news
  news.display = "silent";
}
