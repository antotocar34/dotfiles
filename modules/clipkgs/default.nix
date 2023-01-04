{
  config,
  pkgs,
  ...
}: let
  l = pkgs.lib // builtins;
  mypkgs = import ../../mypkgs {inherit pkgs;};
  hostname = config.host.hostname;
  email = "antoinecarnec@gmail.com";
  name = "Antoine Carnec";
in {

  home.trueAliases = with pkgs; {
      "j" = just;
      "open" = mimeo;
    };
    home.aliases = { 
      "sys" = "systemctl --user";
      "jnl" = "journalctl --user";
    };

  home.sessionVariables = {
        FZF_DEFAULT_COMMAND = ''
      ag --hidden --ignore .cache --ignore .git --ignore .vim --ignore .local -l -g ""
    '';
  };


  home.packages = with pkgs; [
    mimeo
    # bashInteractive
    ripgrep # fast text search
    fd # fast file finder
    fzf # stdout processor
    du-dust # better du
    duf # better df
    # tldr # common wayes to use a command
    rdfind # duplicate finder and remover
    tree #
    cloc # counts lines of code
    trash-cli
    yt-dlp # youtube-dl but better
    psmisc # pstree and the like
    age # encryption tool
    pwgen # password generator
    unzip
    borgbackup # backup tool
    bottom # system surveillance
    # unrar
    rclone # google drive cli interface
    mypkgs.rclone-backup
    lkr # personal script to lock sensitive files and directories with age
    direnv # Set environments in a specific directory
    tdrop # Toggle terminal
    jq # format json to stdout
    just # command line runner
    pirate-get # cli interface to piratebay
    libgen-cli # cli interface to libgen
    xclip # clipboard cli
    comma
    cntr # Nix build debugging helper
    cachix
    magic-wormhole # Send files to anyone
    cmus # Music player
    vifm # terminal file manager
  ];

  programs = {
    git = {
      enable = true;

      aliases = {
        lg = ''log --graph --abbrev-commit --decorate --date=short -10 --format=format:"%C(bold blue)%h%C(reset) '' + 
        ''%C(bold yellow)%d%C(reset) %C(white)%s%C(reset) %C(green)(%ad)%C(reset) %C(dim white)- %an%C(reset)"'';
        te = ''log --all --graph --decorate=short --color --date=short --format=format:"%C(bold blue)%h%C(reset) '' +
        ''%C(bold yellow)%d%C(reset) %C(white)%s%C(reset) %C(green)(%ad)%C(reset) %C(dim white)- %an%C(reset)"'';
        st = "status --short";
        wdiff = "diff --word-diff=color";
        unstage = "reset HEAD --";
      };
      userName = "${name}";
      userEmail = "${email}";

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
      profileExtra = l.readFile ../../homedir/.extra_profile;
      initExtra = l.readFile ../../homedir/.bashrc;
      bashrcExtra = ''
        . <(cat ${../../homedir/.config/bash_shortcuts}/*.bash)
        '';
    };

    bat = {
      enable = true;
      config = {theme = "Nord";};
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
      extraConfig = builtins.readFile ../../homedir/.tmux.conf;
    };

    rbw = {
      enable = true;
      settings = {
        pinentry = "tty";
        inherit email;
      };
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
