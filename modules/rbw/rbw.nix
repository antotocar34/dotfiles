{
  flake.modules.homeManager.cli = {config, pkgs, lib, ...}@args: {
    programs.rbwProfile.personal =
      let
        pinentryPlatformAppropriate = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac
        else if pkgs.stdenv.isLinux && args.host.isDesktop then pkgs.pinentry-qt
        else pkgs.pinentry-curses;
      in
      {
        package = args.acpkgs.rbw;
        settings = {
          pinentry = pinentryPlatformAppropriate;
          lock_timeout = 1; # Only is open for one second TODO allow immediate closing by contributing to upstream
          email = args.info.email;
          pin_unlock = {
            enabled = true;
            ttl_secs = 60 * 60 * 24 * 30;
            allow_weak_keyring = false;
          };
        };
      };
  };
}

