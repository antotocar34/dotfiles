{ pkgs, lib, config, ... }:
let
  l = lib // builtins;
  ml = import ../../../lib { inherit pkgs; };
in
{
  flake.modules.homeManager.gui =
  {
    home.packages = l.mkIf config.host.isDesktop (with pkgs; [
      mpv
    ]);

    programs.kitty = {
      enable = true;
      extraConfig = l.readFile ../../../homedir/.config/kitty/kitty.conf;
      package = if pkgs.stdenv.isLinux then ml.wrapWithNixGLFull pkgs.nixGL pkgs.kitty else pkgs.kitty;
    };
  };
}
