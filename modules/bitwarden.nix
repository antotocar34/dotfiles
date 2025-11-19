{
  flake.modules.homeManager.cli =
    {
      config,
      pkgs,
      acpkgs,
      lib,
      host,
      myLib,
      ...
    }:
    {

      # TODO startup rbw-agent with a service
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

      # TODO define startup service that launches rbw-agent
      # compatible for both mac and linux
      # services.rbw = {
      #
      # };

      programs.rbw =
        let
          pinentryPlatformAppropriate =
            if pkgs.stdenv.isDarwin then
              pkgs.pinentry_mac
            else if pkgs.stdenv.isLinux && host.isDesktop then
              pkgs.pinentry-qt
            else
              pkgs.pinentry-curses;
          hardware_bound_key = myLib.getSecret config "rbw_key";
        in
        {
          enable = true;
          package = acpkgs.rbw;
          settings = {
            pinentry = pinentryPlatformAppropriate;
            lock_timeout = 60 * 30;
            email = "nunyaa7676@gmail.com";
            base_url = "https://vault.bitwarden.eu";
            enable_pin = true;
            pin_enable = true;
            age_identity_file_path = hardware_bound_key;
            argon2_memory = 16*1024;
            argon2_iterations = 1;
            argon2_parallelism = 1;
          };
        };
    };

  flake.modules.homeManager.secrets = {pkgs, host, ...}:
  {
     age.secrets.rbw_key = {
        file = if pkgs.stdenv.isDarwin 
          then ./private/_secrets/base_secrets/rbw_kingmbp_touchid_age_key.age
          else (throw "please generate a tpm key for this device");
        path = "${host.homedir}/.local/share/rbw_age_key";
        mode = "400";
        symlink = true;
     };
  };
}
