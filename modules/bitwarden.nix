{inputs, ...}:
{
  flake.modules.homeManager.cli = {config, pkgs, lib, system, host, info, ...}: {
    home.sessionVariables = lib.mkIf config.programs.rbw.enable {
      SSH_AUTH_SOCK = ''"$([[ -n $XDG_RUNTIME_DIR ]] && echo $XDG_RUNTIME_DIR/rbw || echo "''${TMPDIR}rbw-$UID")/ssh-agent-socket"'';
    };

    programs.rbw = {
      enable = true;
      package = inputs.acpkgs.packages.${system}.rbw;
      settings = {
        pinentry =
          if pkgs.stdenv.isDarwin then pkgs.pinentry_mac
          else if pkgs.stdenv.isLinux && host.isDesktop then pkgs.pinentry-qt
          else pkgs.pinentry-curses;
          lock_timeout = 60 * 5;
          email = info.email;
          pin_unlock = {
            enabled = true;
            ttl_secs = 60 * 60 * 24 * 30;
            allow_weak_keyring = false;
          };
        };
      };
    };
  }
