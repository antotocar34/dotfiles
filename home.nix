{ config, pkgs, ... }:

with import <nixpkgs> {};
with builtins;
with lib;

let
# Personal Info
user = getEnv "USER" ;
home = "/home/${user}" ;
name = "Antoine Carnec" ;
hostname = getEnv "HOST" ;
email = "antoinecarnec@gmail.com" ;


nf-fonts = [
  "CascadiaCode" 
  "UbuntuMono"
  "Iosevka"
  "JetBrainsMono"
            ] ;

inotify = 
 python37Packages.buildPythonApplication rec {
   pname = "inotify" ;
   version = "0.2.10"; 

   src = python37Packages.fetchPypi {
     inherit pname version;
     sha256 = "01raq3v0vpycjqzgr0462zn37vb3p1gp1syl2qpbd0l46cx64jlp";
   };

   # buildInputs = with python3Packagse
   propagatedBuildInputs = with python37Packages ; [ nose ] ;
 };


inkscape-figures = 
  python37Packages.buildPythonApplication rec {
    pname = "inkscape-figures" ;
    version = "1.0.7"; 

    src = python37Packages.fetchPypi {
      inherit pname version;
      sha256 = "04fb4ihxwjzag6l31iq119llnrkva6zbgkxyrgkhw0ircbw4chn1";
    };

    doCheck = false ;

    propagatedBuildInputs = with python37Packages ; [ inotify click pyperclip appdirs daemonize ] ;
  } ;

nixGL = (import (pkgs.fetchFromGitHub {
                owner = "guibou";
                repo = "nixGL";
                rev = "7d6bc1b21316bab6cf4a6520c2639a11c25a220e";
                sha256 = "02y38zmdplk7a9ihsxvnrzhhv7324mmf5g8hmxqizaid5k5ydpr3"; })
            { }).nixGLDefault;



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
        QT_XCB_GL_INTEGRATION= "none";
        LOCALE_ARCHIVE="${home}/.nix-profile/lib/locale/locale-archive" ;
	} ;

    fonts.fontconfig.enable = true ;

    home.packages = with pkgs; let
      NFonts = nerdfonts.override { fonts = nf-fonts ; } ;
      in
            [ # command line tools
            ripgrep
			fd
            nmap
            rdfind # duplicate finder and remover
            ag
            tree
			youtube-dl
			psmisc # pstree and the like
            unzip
            unrar
            rclone

            filezilla
            # python stuff
			python38
			python38Packages.ipython
			# python37Packages.virtualenv
            python38Packages.pip
            inkscape-figures
            # poetry # Install manually
            black

            direnv

            pdf2svg # needed for inkscape-figures

			# nodejs # Needed by coc-nvim
            neovim-remote # Needed for SyncTex

            # Haskell stuff
			# ghc
			# haskellPackages.haskell-language-server
            # cabal-install

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


            # useful programs
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
            # vifm

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

            tdrop

            NFonts

            ## BIG INSTALLS
            # texlive.combined.scheme-full

            ## Have to be installed manually due to things not working
            # rofi
            # kitty
            # flameshot
            # minecraft # works with nixGL
            # bashCompletion

            krita
            xournalpp
            spotify
            # Misc
            nixGL
            nix-index
            nix-bash-completions
            glibcLocales
            powerline-fonts

            transcribe
			];


    programs.neovim = {
       enable = true ;
       plugins = with pkgs.vimPlugins ; 
       [
         vimtex
         vim-surround
         ultisnips
         vim-commentary
         vim-nix
         # vim-fugitive
         nerdtree
         nord-vim
         fzf-vim
         haskell-vim
         coc-nvim
         vim-sneak
         vim-airline
         vim-airline-themes
         colorizer
         vimwiki
       ];

         extraConfig = builtins.readFile extraConfigs/.config/nvim/init.vim ;
         vimAlias = true ; 
         viAlias = true ; 
         vimdiffAlias = true ;
       } ;


	programs.git = {
		enable = true;

		aliases = {
			lg = ''log --graph --abbrev-commit --decorate --date=short -10 --format=format:"%C(bold blue)%h%C(reset) %C(bold yellow)%d%C(reset) %C(white)%s%C(reset) %C(green)(%ad)%C(reset) %C(dim white)- %an%C(reset)"'' ;
			te = ''log --all --graph --decorate=short --color --date=short --format=format:"%C(bold blue)%h%C(reset) %C(bold yellow)%d%C(reset)   %C(green)(%ad)%C(reset)  %x09%C(white)%an: %s %C(reset)"'' ;
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
				"acer" = {
					user = "carneca" ;
                    hostname = "192.168.1.17" ;
					host = "acer" ; 
                    identityFile = "~/.ssh/${hostname}";
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

                       "kitty/kitty.conf".source = ./extraConfigs/.config/kitty/kitty.conf ;
                       "kitty/nord.conf".source = ./extraConfigs/.config/kitty/nord.conf ;
                       "kitty/ink.conf".source = ./extraConfigs/.config/kitty/ink.conf ;
                       "rofi/config.rasi".source = ./extraConfigs/.config/rofi/config.rasi ;
                       "rofi/nord.rasi".source = ./extraConfigs/.config/rofi/nord.rasi ;
                       "nvim/coc-settings.json".source = extraConfigs/.vim/coc-settings.json ;
                       "zathura/zathurarc".source = extraConfigs/.config/zathura/zathurarc ;
                       "vifm/vifmrc".source = ./extraConfigs/.config/vifm/vifmrc ;
                       "vifm/colors/nord.vifm".source = ./extraConfigs/.config/vifm/colors/nord.vifm ;
                       "sxhkd/sxhkdrc".source = ./extraConfigs/.config/sxhkd/sxhkdrc ;
                       "flameshot/flameshot.conf".source = ./extraConfigs/.config/flameshot/flameshot.ini ;
                       "nvim/minimal-vimrc.vim".source = ./extraConfigs/minimal-vimrc.vim ;
                       "direnv/direnvrc".source = ./extraConfigs/.config/direnv/direnvrc ;
                       "inkscape-shortcut-manager/config.py".source = ./extraConfigs/.config/inkscape-shortcut-manager/config.py ;
                       "rclone/rclone.conf".source = ./extraConfigs/.config/rclone/rclone.conf ;
                       "chromium-flags.conf".source = ./extraConfigs/.config/chromium-flags.conf ;
                       "kwinrc".source = ./extraConfigs/.config/kwinrc ;
                       "kwinrulesrc".source = ./extraConfigs/.config/kwinrulesrc ;
                       "misc/.vimiumrc".source = ./extraConfigs/.config/misc/vimium_rc ;
                       "msmpt/config".source = ./extraConfigs/.config/msmtp/config;
                       "xournalpp/settings.xml".source = ./homedir/.xournalpp/settings.xml ;
                       "xournalpp/toolbar.ini".source = ./homedir/.xournalpp/toolbar.ini ;
                       
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
      # ".vim/coc-settings.json".source = ./extraConfigs/.vim/coc-settings.json ;
      ".ssh/sshd_config".source = ./homedir/.ssh/sshd_config ;
      ".ssh/bigboy.pub".source = ./homedir/.ssh/bigboy.pub ;
      ".ssh/x1carbon.pub".source = ./homedir/.ssh/x1carbon.pub ;
      ".ssh/acer.pub".source = ./homedir/.ssh/acer.pub ;
      ".ssh/authorized_keys".source = ./homedir/.ssh/authorized_keys ;
      ".xmodmap".source  = ./homedir/.xmodmap ;
      ".taskrc".source  = ./homedir/.taskrc ;
      ".dir_colors".source  = ./homedir/.dir_colors ;
      ".timewarrior/timewarrior.cfg".source = ./extraConfigs/timewarrior.cfg;
      "Pictures/wallpapers/bigsur.jpg".source = ./homedir/Pictures/wallpapers/bigsur.jpg ;
      "Documents/Scripts/daily_backup.sh".source  = ./homedir/Documents/Scripts/daily_backup.sh ;
      "Documents/Scripts/weekly_backup.sh".source  = ./homedir/Documents/Scripts/weekly_backup.sh ;
      "Documents/Scripts/include.txt".source  = ./homedir/Documents/Scripts/include.txt ;
      "Documents/Scripts/rupdate".source  = ./homedir/Documents/Scripts/rupdate ;
      "Documents/Scripts/economistdl".source  = ./homedir/Documents/Scripts/economistdl ;
      "Documents/Scripts/rdl".source  = ./homedir/Documents/Scripts/rdl ;
      # "Documents/Scripts/startup.sh".source  = ./homedir/Documents/Scripts/startup.sh ;
      "Documents/Scripts/find_pdf.sh".source = ./homedir/Documents/Scripts/find_pdf.sh ;
      "Documents/Scripts/find_tex.sh".source = ./homedir/Documents/Scripts/find_tex.sh ;
      ".ghc/ghci.conf".source = ./homedir/.ghc/ghci.conf ;
    } ;
}
