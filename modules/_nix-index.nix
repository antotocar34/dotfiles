# TODO fiz
{inputs, ...}:
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  flake.modules.homeManager.cli = {pkgs, ...}: {
    programs.nix-index-database.comma.enable = true;
    programs.nix-index.enableBashIntegration = pkgs.lib.mkForce false;
  };
}
