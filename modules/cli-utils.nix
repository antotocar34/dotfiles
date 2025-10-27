{
  flake.modules.homeManager.cli-linux =
    { pkgs, lib, ... }:
    {

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

  flake.modules.homeManager.cli =
    {
      inputs,
      config,
      pkgs,
      lib,
      myLib,
      ...
    }:
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
        htop

        # Python
        uv
      ];
    in
    {

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

        atuin =
          let
            inherit (myLib) getSecret;
            key_path = getSecret config "atuin_key";
            session_path = getSecret config "atuin_session";
            hasSecrets =
              !builtins.elem "/dev/null" [
                key_path
                session_path
              ];
          in
          {
            # enable = true;
            enable = hasSecrets;
            enableBashIntegration = true;
            flags = [ "--disable-up-arrow" ];
            settings = {
              auto_sync = true;
              sync_frequency = "30m";
              history_filter = [
                "^(echo|cat).+base64.+"
                "^(rm|z|cd|ls|man|cat|grep|which) .*"
              ];
              show_tabs = false;
              style = "compact";
              inherit key_path session_path;
              # Key needs to be kept in base64 encoding?
            };
          };
      };
    };

}
