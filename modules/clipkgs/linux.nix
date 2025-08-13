{
  config,
  pkgs,
  ...
}: let
  l = pkgs.lib // builtins;
  mypkgs = import ../../mypkgs {inherit pkgs;};
  hostname = config.host.hostname;
  email = "antoinecarnec@gmail.com";
  name = "Antoine Carnec";
in {
    home.packages = with pkgs; [
      xclip # clipboard cli
      psmisc # pstree and the like
      tdrop # Toggle terminal
      cntr # Nix build debugging helper
    ];
}
