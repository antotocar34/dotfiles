{ inputs, ... }:
{
  flake.modules.homeManager.cli =
    {
      config,
      pkgs,
      acpkgs,
      lib,
      system,
      host,
      info,
      ...
    }:
    {

      home.packages = [
        acpkgs.age-plugin-pwmgr
      ];

      home.sessionVariables =
        let
          RBW_SSH_AUTH_SOCK = ''"$([[ -n $XDG_RUNTIME_DIR ]] && echo $XDG_RUNTIME_DIR/rbw || echo "''${TMPDIR}rbw-$UID")/ssh-agent-socket"'';
        in
        lib.mkIf config.programs.rbw.enable {
          inherit RBW_SSH_AUTH_SOCK;
          SSH_AUTH_SOCK = RBW_SSH_AUTH_SOCK;
        };

      programs.rbw =
        let
          pinentryPlatformAppropriate =
            if pkgs.stdenv.isDarwin then
              pkgs.pinentry_mac
            else if pkgs.stdenv.isLinux && host.isDesktop then
              pkgs.pinentry-qt
            else
              pkgs.pinentry-curses;
        in
        {
          enable = true;
          package = acpkgs.rbw;
          settings = {
            pinentry = pinentryPlatformAppropriate;
            lock_timeout = 60 * 60 * 12;
            email = "nunyaa7676@gmail.com";
            base_url = "https://vault.bitwarden.eu";
            pin_unlock = {
              enabled = true;
              ttl_secs = 60 * 60 * 24 * 30; # 30 days
              allow_weak_keyring = false;
            };
          };
        };
    };
}
