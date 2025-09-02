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
}
