{
  config,
  pkgs,
  ...
}: let
  l = pkgs.lib // builtins;
  ml = import ../../lib/default.nix {inherit pkgs;};
in {
  home.packages = l.mkIf config.host.isDesktop (with pkgs; (
    [
      mpv # lightweight media player
    ]));

   programs.kitty = {
      enable = true;
      # shellIntegration.enableBashIntegration = true;
      extraConfig = l.readFile ../../homedir/.config/kitty/kitty.conf;
      package = if pkgs.stdenv.isLinux then ml.wrapWithNixGLFull pkgs.nixGL pkgs.kitty else pkgs.kitty;
    };
}
