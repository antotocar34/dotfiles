{inputs, ...}:
{
  flake.modules.homeManager.cli = {config, pkgs, lib, system, host, info, ...}: {

    home.packages = [
      inputs.acpkgs.packages.${system}.age-plugin-pwmgr
    ];

    home.sessionVariables = let
      RBW_SSH_AUTH_SOCK = ''"$([[ -n $XDG_RUNTIME_DIR ]] && echo $XDG_RUNTIME_DIR/rbw || echo "''${TMPDIR}rbw-$UID")/ssh-agent-socket"'';
    in
    lib.mkIf config.programs.rbw.enable {
      inherit RBW_SSH_AUTH_SOCK;
      SSH_AUTH_SOCK = RBW_SSH_AUTH_SOCK;
    };

    programs.rbw = 
    let
      pinentryPlatformAppropriate = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac
      else if pkgs.stdenv.isLinux && host.isDesktop then pkgs.pinentry-qt
      else pkgs.pinentry-curses;
    in
    {
      enable = true;
      package = inputs.acpkgs.packages.${system}.rbw;
      settings = {
        pinentry = pinentryPlatformAppropriate;
        lock_timeout = 30;
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
