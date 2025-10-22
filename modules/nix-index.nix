{ inputs, ... }:
{
  flake.modules.homeManager.cli =
    { lib, ... }:
    {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
      ];
      programs.nix-index-database.comma.enable = true;
      # Disable using nix-index for command not found
      programs.nix-index.enableBashIntegration = lib.mkForce false;
      programs.nix-index.enableZshIntegration = lib.mkForce false;
    };
}
