{
  flake.modules.homeManager.cli =
    {
      config,
      pkgs,
      myLib,
      ...
    }@args:
    {
      programs.rbwProfile.personal =
        let
          pinentryPlatformAppropriate =
            if pkgs.stdenv.isDarwin then
              pkgs.pinentry_mac
            else if pkgs.stdenv.isLinux && args.host.isDesktop then
              pkgs.pinentry-qt
            else
              pkgs.pinentry-curses;

          kdfIterations = if pkgs.stdenv.isDarwin then 8 else 64;
          hardware_bound_key = myLib.getSecret config "rbw_key";
        in
        {
          package = args.acpkgs.rbw;
          settings = {
            pinentry = pinentryPlatformAppropriate;
            lock_timeout = 1; # Only is open for one second TODO allow immediate closing by contributing to upstream
            email = args.info.email;
            enable_pin = true;
            age_identity_file_path = hardware_bound_key;
            argon2_memory = kdfIterations*1024;
            argon2_iterations = 2;
            argon2_parallelism = 1;
          };
        };
    };
}
