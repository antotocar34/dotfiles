{ config, lib, pkgs, myLib, ... }:

# with import <nixpkgs> {};
with builtins ;
with lib ;
with lib.lists;
with myLib ;

let
# Personal Info
user = "carneca" ;
home = "/home/${user}" ;
name = "Antoine Carnec" ;
hostname = "x1carbon" ;
isDesktop = true;
email = "antoinecarnec@gmail.com" ;
system = "x86_64-linux" ;

nf-fonts = [
  "CascadiaCode" 
  # "UbuntuMono"
  # "Iosevka"
  # "JetBrainsMono"
            ] ;

in
{
	programs.home-manager.enable = true;

	home.username = "${user}";
	home.homeDirectory = "${home}";

	home.stateVersion = "21.03";

	home.sessionVariables = {
		FZF_DEFAULT_COMMAND=''
			ag --hidden --ignore .cache --ignore .git --ignore .vim --ignore .local -l -g ""
			'' ;
        LOCALE_ARCHIVE="${home}/.nix-profile/lib/locale/locale-archive" ;
        R_PROFILE_USER="${home}/.config/R/.Rprofile";
        NIXPKGS_ALLOW_UNFREE=1;
	} ;


    nix = {
      package = pkgs.nix ;
      settings = {
        warn-dirty = false ;
        experimental-features = [ "nix-command" "flakes" ];
      };
    };

    nixpkgs.config.allowUnfree = true;

    fonts.fontconfig.enable = true ;

    home.packages = with pkgs; let
      my-nerdfonts = nerdfonts.override { fonts = nf-fonts ; } ;
      in
      [
            # command line utilities
            ripgrep # fast text search
			fd # fast file finder
			fzf # stdout processor
            du-dust # better du
            duf # better df
            tldr # common wayes to use a command
            rdfind # duplicate finder and remover
            tree #
            cloc # counts lines of code
			yt-dlp # youtube-dl but better
			psmisc # pstree and the like
            unzip
            borgbackup
            # unrar
            rclone # google drive cli interface
            direnv # Set environments in a specific directory
            tdrop # Toggle terminal
            jq # format json to stdout
            just # command line runner
            pirate-get # cli interface to piratebay
            libgen-cli # cli interface to libgen
			xclip # clipboard cli
            cachix

            # Some window manager utilities
			xdotool
            xorg.xrandr
            xorg.xwininfo
            xbanish # Hides cursor on key press

            pdf2svg # needed for inkscape-figures

            # text editor
            # neovim
            neovim-remote # Needed for SyncTex

            # password and secret management
            rbw # rust bitwarden client
            rofi-rbw
            age # encryption tool
            pwgen # password generator

            mutt # emailer
            msmtp # 

            # for inkscape-figures
            colorpicker



            # plain text accounting
            ledger
            beancount
            fava

            # productivity
            taskwarrior
            timewarrior

            # useful programs
			feh # image viewer
			vlc # media player
            cmus # Music player
            vifm # terminal file manager
            magic-wormhole # Send files to anyone


            # should be a service but is not working
            sxhkd
            rofi


            my-nerdfonts # fonts

            (texlive.combine {
                inherit (texlive)
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
            glibcLocales
            powerline-fonts

            nixGL
          ] ++ 
          optionals isDesktop 
          [
              mcomix3 # comic reader
              zathura # pdf reader
              flameshot

              # whatsapp-for-linux
              # signal-desktop
              bitwarden
              discord
              ## bigger installs
              gnome3.gnome-disk-utility
              gnome3.pomodoro
              # filezilla # FTP client
              krita # Drawing Application
              transcribe # 
              xournalpp # note taking
              spotify
              inkscape
              gimp
              deluge
          ] ++
          # For those applications that need to be wrapped with nixGL
          builtins.map (wrapWithNixGL nixGL) 
          (optionals isDesktop 
            [ 
              calibre 
              kitty
            ]
          );

    ## MODULES
    programs =  {

      git = {
        enable = true;

        aliases = {
          lg = ''log --graph --abbrev-commit --decorate --date=short -10 --format=format:"%C(bold blue)%h%C(reset) %C(bold yellow)%d%C(reset) %C(white)%s%C(reset) %C(green)(%ad)%C(reset) %C(dim white)- %an%C(reset)"'' ;
          te = ''log --all --graph --decorate=short --color --date=short --format=format:"%C(bold blue)%h%C(reset) %C(bold yellow)%d%C(reset) %C(white)%s%C(reset) %C(green)(%ad)%C(reset) %C(dim white)- %an%C(reset)"'' ;
          st = "status --short" ;
          wdiff = "diff --word-diff=color" ;
          unstage = "reset HEAD --";
        } ;
        userName = "${name}" ;
        userEmail = "${email}" ;
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

        delta.enable = true ;
        delta.options = {
          syntax-theme = "Nord" ;
          side-by-side = "false" ;
          paging = "auto" ;
          line-numbers = "true" ;
          hunk-header-style = "omit" ;
          line-numbers-zero-style = "#4C566A" ;
          # plus-emph-style = "syntax '#A3BE8C'" ;
        } ;
      };

      gh = {
        enable = true ;
        settings = {
          git_protocol = "ssh" ;
        };
      };

      bash = {
        enable = true ; 
        profileExtra = builtins.readFile ./extraConfigs/.bash_profile ;
        initExtra   = builtins.readFile ./extraConfigs/.bashrc ; 
      };  

      bat = {
        enable = true ;
        config = { theme = "Nord" ; } ;
      } ;

      firefox = {
        enable = true;
      };

      chromium = {
        enable = false ;
        extensions = 
        [
          "blaaajhemilngeeffpbfkdjjoefldkok" # LeechBlock
          "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
          "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock
          "adegbkmimffpmlcdkjbadjjeiaacflap" # Incognito Blocker
            # "icpgjfneehieebagbmdbhnlpiopdcmna" # New tab
            "edacconmaakjimmfgnblocblbcdcpbko" # Session Buddy
          ] ;
        };


        direnv = {
          enable = true ;
          nix-direnv.enable = true ;
        };
        ssh = {
          enable = true ;
          matchBlocks =
            {
              "website" = {
                user = "git" ;
                port = 22 ;
                hostname = "github.com" ;
                host = "github.com-antoinecarnec" ; 
                identityFile = "~/.ssh/website";
              } ;
              "github" = {
                user = "git" ;
                port = 22 ;
                hostname = "github.com" ;
                host = "github.com" ; 
                identityFile = "~/.ssh/github";
              } ;
              "x1carbon" = {
                user = "carneca" ;
                hostname = "192.168.1.19" ;
                host = "x1carbon" ; 
                identityFile = "~/.ssh/${hostname}" ;
              } ;
            };
          } ;

          tmux = {
            enable = true;
            baseIndex = 1; 
            escapeTime = 1;
            keyMode = "vi";
            newSession = true;
            shortcut = "k" ;
            extraConfig = builtins.readFile ./extraConfigs/.tmux.conf ;
          } ;
        };

    # Apply plasma settings
    programs.plasma = import ./extraConfigs/plasma_settings.nix ;

    xdg = {
      enable = true ;
      cacheHome = "/home/carneca/.cache" ;
      configHome = "/home/carneca/.config" ;
      dataHome   = "/home/carneca/.local/share" ;
      configFile = {
                       # Startup script
                       "plasma-workspace/env/startup.sh".source = ./homedir/Documents/Scripts/startup.sh ;
                       "calibre".source = ./extraConfigs/.config/calibre ;
                       "calibre".recursive = true ;
                       "kitty".source = ./extraConfigs/.config/kitty ;
                       "kitty".recursive = true ;
                       "rofi".source = ./extraConfigs/.config/rofi ;
                       "rofi".recursive = true ;
                       "zathura/zathurarc".source = extraConfigs/.config/zathura/zathurarc ;
                       "vifm/vifmrc".source = ./extraConfigs/.config/vifm/vifmrc ;
                       "vifm/colors/nord.vifm".source = ./extraConfigs/.config/vifm/colors/nord.vifm ;
                       "sxhkd/sxhkdrc".source = ./extraConfigs/.config/sxhkd/sxhkdrc ;
                       "flameshot/flameshot.conf".source = ./extraConfigs/.config/flameshot/flameshot.ini ;
                       "nvim/minimal-vimrc.vim".source = ./extraConfigs/minimal-vimrc.vim ;
                       "nvim/init.vim".source = ./extraConfigs/.config/nvim/init.vim ;
                       "direnv/direnvrc".source = ./extraConfigs/.config/direnv/direnvrc ;
                       "inkscape-shortcut-manager/config.py".source = ./extraConfigs/.config/inkscape-shortcut-manager/config.py ;
                       "chromium-flags.conf".source = ./extraConfigs/.config/chromium-flags.conf ;
                       "kwinrc".source = ./extraConfigs/.config/kwinrc ;
                       "kwinrulesrc".source = ./extraConfigs/.config/kwinrulesrc ;
                       "misc/.vimiumrc".source = ./extraConfigs/.config/misc/vimium_rc ;
                       "xournalpp/settings.xml".source = ./homedir/.xournalpp/settings.xml ;
                       "xournalpp/toolbar.ini".source = ./homedir/.xournalpp/toolbar.ini ;
                       "bash_shortcuts".source = ./extraConfigs/.config/bash_shortcuts ; 
                       "bash_shortcuts".recursive = true ; 
                       "cmus".source = ./extraConfigs/.config/cmus ;
                       "cmus".recursive = true ;
                       "R/.Rprofile".source = ./extraConfigs/.config/R/Rprofile;
                     };

                     mime.enable = true ;
                     mimeApps.enable = true ;
                     mimeApps.defaultApplications =
                       { 
                         "x-scheme-handler/http" = "firefox.desktop" ;
                         "x-scheme-handler/https" = "firefox.desktop" ;
                         "application/html" = "chromium-browser.desktop" ;
                         "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop" ;
                         "application/epub+zip" = "org.pwmt.zathura-pdf-mupdf.desktop" ;
                         "image/svg+xml" = "org.inkscape.Inkscape.desktop" ;
                         "audio/opus" = "vlc.desktop" ;
                         "audio/aac" = "vlc.desktop" ;
                         "audio/mpegsymlinks" = "vlc.desktop" ;
                       } ;
                       mimeApps.associations.added = { 
                         "x-scheme-handler/http" = "firefox.desktop" ;
                         "x-scheme-handler/https" = "firefox.desktop" ;
                         "application/html" = "firefox.desktop" ;
                       } ;
                     };

                     home.file = {
      # Directories
      ".ssh".source = ./homedir/.ssh ;
      ".ssh".recursive = true ;
      "Documents/Scripts".source  = ./homedir/Documents/Scripts ;
      "Documents/Scripts".recursive  = true ;

      # Files
      ".xmodmap".source  = ./homedir/.xmodmap ;
      ".taskrc".source  = ./homedir/.taskrc ; # taskwarrior configuration
      ".dir_colors".source  = ./homedir/.dir_colors ;
      ".timewarrior/timewarrior.cfg".source = ./extraConfigs/timewarrior.cfg;
      "Pictures/wallpapers/bigsur.jpg".source = ./homedir/Pictures/wallpapers/bigsur.jpg ;
      ".ghc/ghci.conf".source = ./homedir/.ghc/ghci.conf ;
      ".muttrc".source = ./homedir/.muttrc ;
      ".Rprofile".source = ./extraConfigs/.config/R/Rprofile;
    } ;

    # Secrets
    homeage = {
      identityPaths = [ "${home}/.ssh/antoine" ];
      installationType = "activation";

      file."rclone_config" = {
        source = ./extraConfigs/.config/rclone/rclone.conf.age ;
        copies = [ "${home}/.config/rclone/rclone.conf" ];
      } ;

      file."msmtp_config" = {
        source = ./extraConfigs/.config/msmtp/config.age ;
        copies = [ "${home}/.config/msmtp/config" ];
      } ;
    } ;

    # SERVICES
    services = {
      sxhkd = {
        enable = false ;
        extraOptions = [ "-c ${xdg.configHome}/sxhkd/sxhkdrc" "-r ${home.homeDirectory}/.logs/sxhkd" ] ;
      };
    } ;

    # systemd automatic starting of services *I think*
    systemd.user.startServices = "sd-switch";

    # disable notifications about home-manager news
    news.display = "silent";
  }
