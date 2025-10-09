{
  flake.modules.homeManager.cli-linux = {pkgs, lib, ...}: {

    home = lib.mkIf pkgs.stdenv.isLinux ({
      aliases = {
        "open" = "mimeo";
        "sys" = "systemctl --user";
        "jnl" = "journalctl --user";
      };

      packages = with pkgs; [
        psmisc # pstree and the like
        tdrop # Toggle terminal
        xclip # clipboard cli
        cntr # Nix build debugging helper
        mimeo
      ];
    });
  };

  flake.modules.homeManager.cli = {config, pkgs, lib, ...}:
    let
      # system = pkgs.stdenv.hostPlatform.system;
      mypkgs = import ../mypkgs { inherit pkgs config; };
      cliPackages = with pkgs; [
        (llm.withPlugins {
          llm-anthropic = true;
          llm-cmd = true;
          llm-gemini = true;
        })
        ripgrep
        fd
        fzf
        du-dust
        duf
        tldr
        rdfind
        tree
        cloc
        trash-cli
        yt-dlp
        age
        pwgen
        unzip
        borgbackup
        bottom
        bashmount
        httpie
        rclone
        # mypkgs.rclone-backup
        mypkgs.ask
        jq
        just
        pirate-get
        libgen-cli
        cachix
        magic-wormhole
        cmus
        vifm

        # Python
        uv
      ];
    in {

        home.packages = cliPackages;
        home.sessionVariables = {
          FZF_DEFAULT_COMMAND = ''
            ag --hidden --ignore .cache --ignore .git --ignore .vim --ignore .local -l -g ""
          '';
        };

        programs = {
          bat = {
            enable = true;
            config.theme = "Nord";
          };

          direnv = {
            enable = true;
            nix-direnv.enable = true;
            config.hide_env_diff = true;
          };

          tmux = {
            enable = true;
            baseIndex = 1;
            escapeTime = 1;
            keyMode = "vi";
            newSession = true;
            shortcut = "k";
            extraConfig = builtins.readFile ../homedir/.tmux.conf;
          };

          fzf = {
            enable = true;
            enableBashIntegration = true;
          };
        };
      };
    }
