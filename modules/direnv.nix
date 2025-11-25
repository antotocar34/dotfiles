{ ... }:
{
  flake.modules.homeManager.cli =
    { inputs, pkgs, ... }:
    {

      imports = [
        # inputs.direnv-instant.homeModules.direnv-instant
      ];

      # TODO: direnv-instant is not quite working....
      # programs.direnv-instant = {
      #   enable = false;
      #   enableBashIntegration = true;
      #   enableKittyIntegration = true;
      # };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        config.hide_env_diff = true;
      };

    };
}
