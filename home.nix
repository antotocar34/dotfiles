{ config, lib, pkgs, options, ... }:

# with import <nixpkgs> {};
with builtins;
with lib;

let
# Personal Info
user = "carneca" ;
home = "/home/${user}" ;
name = "Antoine Carnec" ;
hostname = "x1carbon" ;
email = "antoinecarnec@gmail.com" ;


nf-fonts = [
  "CascadiaCode" 
  "UbuntuMono"
  "Iosevka"
  # "JetBrainsMono"
            ] ;

# nixGL = (import (pkgs.fetchFromGitHub {
#                 owner = "guibou";
#                 repo = "nixGL";
#                 rev = "7d6bc1b21316bab6cf4a6520c2639a11c25a220e";
#                 sha256 = "02y38zmdplk7a9ihsxvnrzhhv7324mmf5g8hmxqizaid5k5ydpr3"; })
#             { }).nixGLDefault;

in
{
	programs.home-manager.enable = true;
    # TODO change path to home-manager
	# programs.home-manager.path = "${home}/.config/home-manager";

	home.username = "${user}";
	home.homeDirectory = "${home}";

	home.stateVersion = "21.03";

	home.sessionVariables = {
		FZF_DEFAULT_COMMAND=''
			ag --hidden --ignore .stack --ignore .cabal --ignore .cache --ignore .git --ignore .vim --ignore .local -l -g ""
			'' ;
        # QT_XCB_GL_INTEGRATION= "none"; # This causes all sorts of OpenGL issues
        LOCALE_ARCHIVE="${home}/.nix-profile/lib/locale/locale-archive" ;
        R_PROFILE_USER="${home}/.config/R/.Rprofile";
        NIXPKGS_ALLOW_INSECURE=1;
        NIXPKGS_ALLOW_UNFREE=1;
	} ;

    fonts.fontconfig.enable = true ;

    home.packages = with pkgs; let
      NFonts = nerdfonts.override { fonts = nf-fonts ; } ;
      in
            [ # command line tools
            ripgrep
			fd
            du-dust
            duf
            tldr
            translate-shell

            nmap
            # rdfind # duplicate finder and remover
            silver-searcher
            tree
            cloc # counts lines of code
			yt-dlp
			psmisc # pstree and the like
            unzip
            unrar
            rclone

            filezilla
            black

            direnv

            pdf2svg # needed for inkscape-figures

            neovim-remote # Needed for SyncTex

            # password management
			bitwarden
			bitwarden-cli

            # for inkscape-figures
			xclip # also useful
            colorpicker

			zathura
            mcomix3

			xdotool
            xorg.xrandr
            xorg.xwininfo

            # Plain text accounting
            ledger
            beancount
            fava

            # useful programs
            gh
            taskwarrior
            timewarrior
			fzf
			feh 
			vlc
            xbanish # Hides cursor on key press

			discord
            # anki-bin

            # should be a service but is not working
            sxhkd

            cmus
            vifm
            flameshot

            # whatsapp-for-linux
            signal-desktop

            gnome3.gnome-disk-utility
            gnome3.pomodoro
            etcher # Formatting USBs

            calibre # Ebook goodness
            kcc # Ebook conversion

            inkscape
            gimp
            deluge
            pirate-get

            tdrop

            NFonts

            ## BIG INSTALLS
            # texlive.combined.scheme-full

            krita

            xournalpp
            # Misc
            # nixGL
            nix-index
            # nix-bash-completions
            glibcLocales
            powerline-fonts

            transcribe
			];

	programs.git = {
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
	} ;

	programs =  {
 		bash = {
			enable = true ; 
			profileExtra = builtins.readFile ./extraConfigs/.bash_profile ;
			initExtra   = builtins.readFile ./extraConfigs/.bashrc ; 
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
				"bigboy" = {
					user = "carneca" ;
                    hostname = "192.168.1.18" ;
					host = "bigboy" ; 
                    identityFile = "~/.ssh/${hostname}";
				} ;
				"rbigboy" = {
					user = "carneca" ;
                    hostname = "glenahome.duckdns.org" ;
					host = "rbigboy" ; 
                    identityFile = "~/.ssh/${hostname}";
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

        bat = {
          enable = true ;
          config = { theme = "Nord" ; } ;
          } ;
	};


	xdg = {
        enable = true ;
        cacheHome = "/home/carneca/.cache" ;
        configHome = "/home/carneca/.config" ;
        dataHome   = "/home/carneca/.local/share" ;
        configFile = {
                       # Startup script
                       "plasma-workspace/env/startup.sh".source = ./homedir/Documents/Scripts/startup.sh ;
                       "kitty".source = ./extraConfigs/.config/kitty ;
                       "kitty".recursive = true ;
                       "rofi".source = ./extraConfigs/.config/rofi ;
                       "rofi".recursive = true ;
                       # "kxkbrc".source = ./extraConfigs/.config/kxkbrc ;
                       "zathura/zathurarc".source = extraConfigs/.config/zathura/zathurarc ;
                       "vifm/vifmrc".source = ./extraConfigs/.config/vifm/vifmrc ;
                       "vifm/colors/nord.vifm".source = ./extraConfigs/.config/vifm/colors/nord.vifm ;
                       "sxhkd/sxhkdrc".source = ./extraConfigs/.config/sxhkd/sxhkdrc ;
                       "flameshot/flameshot.conf".source = ./extraConfigs/.config/flameshot/flameshot.ini ;
                       "nvim/minimal-vimrc.vim".source = ./extraConfigs/minimal-vimrc.vim ;
                       "nvim/init.vim".source = ./extraConfigs/.config/nvim/init.vim ;
                       "direnv/direnvrc".source = ./extraConfigs/.config/direnv/direnvrc ;
                       "inkscape-shortcut-manager/config.py".source = ./extraConfigs/.config/inkscape-shortcut-manager/config.py ;
                       "rclone/rclone.conf".source = ./extraConfigs/.config/rclone/rclone.conf ;
                       "chromium-flags.conf".source = ./extraConfigs/.config/chromium-flags.conf ;
                       "kwinrc".source = ./extraConfigs/.config/kwinrc ;
                       "kwinrulesrc".source = ./extraConfigs/.config/kwinrulesrc ;
                       "misc/.vimiumrc".source = ./extraConfigs/.config/misc/vimium_rc ;
                       "msmtp/config".source = config.lib.file.mkOutOfStoreSymlink ./extraConfigs/.config/msmtp/config ;
                       "transmission-daemon/settings.json".source = ./extraConfigs/.config/transmission-daemon/settings.json ;
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
            "x-scheme-handler/http" = "chromium-browser.desktop" ;
            "x-scheme-handler/https" = "chromium-browser.desktop" ;
            "application/html" = "chromium-browser.desktop" ;
            "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop" ;
            "application/epub+zip" = "org.pwmt.zathura-pdf-mupdf.desktop" ;
            "image/svg+xml" = "org.inkscape.Inkscape.desktop" ;
            "audio/opus" = "vlc.desktop" ;
            "audio/aac" = "vlc.desktop" ;
            "audio/mpeg" = "vlc.desktop" ;
           } ;
           mimeApps.associations.added = { 
            "x-scheme-handler/http" = "chromium-browser.desktop" ;
            "x-scheme-handler/https" = "chromium-browser.desktop" ;
            "application/html" = "chromium-browser.desktop" ;
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
      ".taskrc".source  = ./homedir/.taskrc ;
      ".dir_colors".source  = ./homedir/.dir_colors ;
      ".timewarrior/timewarrior.cfg".source = ./extraConfigs/timewarrior.cfg;
      "Pictures/wallpapers/bigsur.jpg".source = ./homedir/Pictures/wallpapers/bigsur.jpg ;
      ".ghc/ghci.conf".source = ./homedir/.ghc/ghci.conf ;
      ".muttrc".source = ./homedir/.muttrc ;
      ".Rprofile".source = ./extraConfigs/.config/R/Rprofile;
    } ;
}
