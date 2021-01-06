{ config, pkgs, ... }:

with import <nixpkgs> {};
with builtins;
with lib;
let
# Personal Info
user = "carneca" ;
home = "/home/${user}" ;
name = "Antoine Carnec" ;
email = "antoinecarnec@gmail.com" ;
# Paths
dotconfig = toPath "./extraConfigs/.config" ;
# try this one if the other one does not work.
# config = ./extraConfigs/.config ;

# vim-black = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
#         pname = "black";
#         version = "f07832e";
#         src = ./black ;
#         meta.homepage = "https://github.com/psf/black";
#      }; 
in
{
	programs.home-manager.enable = true;
    # TODO change path to home-manager
	# programs.home-manager.path = "${home}/.config/home-manager";

	home.username = "${user}";
	home.homeDirectory = "${home}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
	home.stateVersion = "21.03";

	home.sessionVariables = {
		FZF_DEFAULT_COMMAND=''
			ag --hidden --ignore .stack --ignore .cabal --ignore .cache --ignore .git --ignore .vim --ignore .local -l -g ""
			'' ;
        QT_XCB_GL_INTEGRATION= "none";
	} ;

    fonts.fontconfig.enable = true ;

	home.packages = with pkgs;  [

            # command line tools
            ripgrep
			fd
            ag
            tree
			youtube-dl
			exa
			psmisc # pstree and the like
            unzip

			anki

            # python stuff
			python38
			python38Packages.ipython
			python38Packages.virtualenv
			python38Packages.pip
            # nix shell looks like too much work
			pipenv
            black


            pdf2svg # needed for inkscape-figures

			nodejs # Needed by coc-nvim

            # Haskell stuff
			ghc
			haskellPackages.haskell-language-server
            cabal-install

            # password management
			bitwarden
			bitwarden-cli

            # for inkscape-figures
			xclip # also useful
            rxvt-unicode

			zathura

			xdotool
            xorg.xrandr
            xorg.xwininfo


            # useful programs
			flameshot
			fzf
			feh 
			vlc
            xbanish

			discord

            # should be a service but is not working
            sxhkd

            cmus
            vifm


            gnome3.gnome-disk-utility
            etcher

            inkscape
            gimp
            krita
            transmission-qt

            tdrop


            ## BIG INSTALLS
            # nerdfonts
            texlive.combined.scheme-full
            minecraft

            ## Have to be installed manually due to things not working
            # rofi
            # kitty
            bashCompletion

            # Misc

            # doesn't seem to work out of the box
            bashCompletion
            # This seems to work out of the box

            nix-bash-completions
            glibcLocales
            powerline-fonts
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
         vim-fugitive
         nord-vim
         fzf-vim
         nerdtree
         # vim-dirvish
         haskell-vim
         coc-nvim
         vim-airline
         vim-airline-themes
         colorizer
         # TODO make black derivation
         # vim-black
       ];

         extraConfig = builtins.readFile extraConfigs/.vimrc ;
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
				"acer" = {
					user = "carnec" ;
					host = "192.168.1.8" ; 
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
			enable = true ;
			extensions = 
				[
				"blaaajhemilngeeffpbfkdjjoefldkok" # LeechBlock
			    "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
			    "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
			    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock
				"icpgjfneehieebagbmdbhnlpiopdcmna" # New tab
				"edacconmaakjimmfgnblocblbcdcpbko" # Session Buddy
				] ;
		};
	};

	# services.sxhkd = 
	# {
	# 	enable = false ;
	# 	# extraPath = "/home/${user}/Documents/Scripts" ;
	# 	# extraConfig = builtins.readFile ./extraConfigs/sxhkdrc ;
	# };

	xdg = {
        enable = true ;
        cacheHome = "/home/carneca/.cache" ;
        configHome = "/home/carneca/.config" ;
        dataHome   = "/home/carneca/.local/share" ;
        configFile = {
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
                       "plasma-workspace/env/startup.sh".source = ./homedir/Documents/Scripts/startup.sh ;
                       "flameshot/flameshot.conf".source = ./extraConfigs/.config/flameshot/flameshot.ini ;
                       "nvim/minimal-vimrc.vim".source = ./extraConfigs/minimal-vimrc.vim ;
                       "inkscape-shortcut-manager/config.py".source = ./extraConfigs/.config/inkscape-shortcut-manager/config.py ;
                       "kwinrc".source = ./extraConfigs/.config/kwinrc ;
                       "kwinrulesrc".source = ./extraConfigs/.config/kwinrulesrc ;
                     };
        mime.enable = true ;
        mimeApps.enable = true ;
        mimeApps.defaultApplications =
          { 
            "application/html" = "chromium-browser.desktop" ;
            "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop" ;
            "application/epub+zip" = "org.pwmt.zathura-pdf-mupdf.desktop" ;
            "image/svg+xml" = "org.inkscape.Inkscape.desktop" ;
            "audio/opus" = "vlc.desktop" ;
            "audio/aac" = "vlc.desktop" ;
            "audio/mpeg" = "vlc.desktop" ;
           } ;
	};
    home.file = {
    # "Documents/Scripts/inkscape-draw".recursive  = true ;
    # "Documents/Scripts/inkscape-draw".source  = ./homedir/Documents/Scripts/inkscape-draw ;
    ".xmodmap".source  = ./homedir/.xmodmap ;
    ".dir_colors".source  = ./homedir/.dir_colors ;
    ".notes".source  = ./homedir/.notes ;
    "Documents/Scripts/startup.sh".source  = ./homedir/Documents/Scripts/startup.sh ;
    "Documents/Scripts/find_pdf.sh".source = ./homedir/Documents/Scripts/find_pdf.sh ;
    "Documents/Scripts/find_tex.sh".source = ./homedir/Documents/Scripts/find_tex.sh ;
    ".ghc/ghci.conf".source = ./homedir/.ghc/ghci.conf ;
    } ;
}
