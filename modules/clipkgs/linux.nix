{
  config,
  pkgs,
  ...
}: let
  l = pkgs.lib // builtins;
  mypkgs = import ../../mypkgs {inherit pkgs;};

  # copy_and_paste = l.attrValues {
  # };
in {
    home.aliases = {
      "open" = "mimeo";
    };

    home.packages = with pkgs; [
      xclip # clipboard cli
      psmisc # pstree and the like
      tdrop # Toggle terminal
      cntr # Nix build debugging helper
    ];

}
