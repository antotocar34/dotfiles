{ inputs, pkgs, lib, config, ... }:
let
  l = lib // builtins;
  t = lib.types;
  system = pkgs.stdenv.hostPlatform.system;
  mypkgs = import ../../../mypkgs { inherit pkgs config; };
  myNvim = inputs.my-neovim.packages."${system}".neovim;
  email = "antoinecarnec@gmail.com";
  name = "Antoine Carnec";
  writeCopy = name: drv: pkgs.writeShellScriptBin name ''exec ${l.getExe drv} "$@"'';
  basePackages = with pkgs; [
    myNvim
    (llm.withPlugins {
      llm-anthropic = true;
      llm-cmd = true;
      llm-gemini = true;
    })
    mimeo
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
    mypkgs.rclone-backup
    mypkgs.ask
    jq
    just
    pirate-get
    libgen-cli
    cachix
    magic-wormhole
    cmus
    vifm
  ];
in {
  flake.modules.homeManager.cli = {
  imports = [ inputs.nix-index-database.homeModules.nix-index ];

  options.home = {
    trueAliases = l.mkOption {
      type = t.attrsOf t.package;
      default = {};
      description = "Commands that should become true executables and receive shell completions.";
    };
    aliases = l.mkOption {
      type = t.attrsOf t.str;
      default = {};
      description = "Shell aliases with completion support.";
    };
  };

  config = let
    cfg = config.home;
    trueAliasPackages = l.mapAttrsToList writeCopy cfg.trueAliases;
  in {
    home.trueAliases = lib.mkDefault {};
    home.aliases = lib.mkDefault {
      "la" = "ls -a";
      "lla" = "ls -la";
      "j" = "just";
      ".j" = "just -f ${config.configPath}/homedir/.config/global_justfile/justfile -d .";
      "sys" = "systemctl --user";
      "jnl" = "journalctl --user";
    };

    home.sessionVariables = {
      FZF_DEFAULT_COMMAND = ''
        ag --hidden --ignore .cache --ignore .git --ignore .vim --ignore .local -l -g ""
      '';
      EDITOR = "${myNvim}/bin/nvim";
      SSH_AUTH_SOCK = l.optionalString config.programs.rbw.enable ''"$([[ -n $XDG_RUNTIME_DIR ]] && echo $XDG_RUNTIME_DIR/rbw || echo "''${TMPDIR}rbw-$UID")/ssh-agent-socket"'';
    };

    home.packages = trueAliasPackages ++ basePackages;

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
        userName = name;
        userEmail = email;
        delta.enable = true;
        delta.options = {
          syntax-theme = "Nord";
          side-by-side = "false";
          paging = "auto";
          line-numbers = "true";
          hunk-header-style = "omit";
          line-numbers-zero-style = "#4C566A";
        };
      };

      gh = {
        enable = true;
        settings.git_protocol = "ssh";
      };

      bash = {
        enable = true;
        enableCompletion = true;
        profileExtra = l.readFile ../../../homedir/.extra_profile;
        initExtra =
          (l.readFile ../../../homedir/.bashrc)
          + ''
            . ${pkgs.complete-alias}/bin/complete_alias
            ${l.concatMapStringsSep "\n" (s: "complete -F _complete_alias ${s}") (l.attrNames cfg.aliases)}
          '';
        bashrcExtra = l.mkAfter (
          ''
            . <(cat ${../../../homedir/.config/bash_shortcuts}/*.bash)
            EDITOR="${myNvim}/bin/nvim"
          ''
          + l.optionalString pkgs.stdenv.isDarwin ''
            # export SHELL="/opt/homebrew/bin/bash"
            export CLICOLOR=1
            export LSCOLORS=GxFxCxDxBxegedabagaced
            PATH=/opt/homebrew/bin:$PATH
          ''
        );
        sessionVariables.EDITOR = "${myNvim}/bin/nvim";
        shellAliases = cfg.aliases;
      };

      bat = {
        enable = true;
        config.theme = "Nord";
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        config.hide_env_diff = true;
      };

      ssh = {
        enable = true;
        enableDefaultConfig = false;
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
          "*" = {
            identityFile = "~/.ssh/antoine";
          };
        };
        includes = ["tmp_config"];
      };

      tmux = {
        enable = true;
        baseIndex = 1;
        escapeTime = 1;
        keyMode = "vi";
        newSession = true;
        shortcut = "k";
        extraConfig = builtins.readFile ../../../homedir/.tmux.conf;
      };

      rbw = {
        enable = true;
        package = inputs.acpkgs.packages.${system}.rbw;
        settings = {
          pinentry =
            if pkgs.stdenv.isDarwin then pkgs.pinentry_mac
            else if pkgs.stdenv.isLinux && config.host.isDesktop then pkgs.pinentry-qt
            else pkgs.pinentry-curses;
          lock_timeout = 60 * 30;
          inherit email;
          pin_unlock = {
            enabled = true;
            ttl_secs = 60 * 60 * 24 * 30;
            allow_weak_keyring = false;
          };
        };
      };

      fzf = {
        enable = true;
        enableBashIntegration = true;
      };
    };

    programs.nix-index-database.comma.enable = true;
    programs.nix-index.enableBashIntegration = l.mkForce false;
  };
};
}
