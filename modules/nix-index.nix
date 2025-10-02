{inputs, ...}:
{
  flake.modules.homeManager.cli = {lib, ...}: {
    imports = [
      inputs.nix-index-database.homeModules.nix-index
    ];
    programs.nix-index-database.comma.enable = true;
    programs.nix-index.enableBashIntegration = lib.mkForce false;
  };
}
