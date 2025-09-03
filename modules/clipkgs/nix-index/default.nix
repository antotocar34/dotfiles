{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.nix-index-database.comma.enable = true;

  programs.nix-index.enableBashIntegration = pkgs.lib.mkForce false;
}

