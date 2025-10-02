{
  flake.modules.homeManager.desktop = {config, pkgs, lib, myLib, host, ...}:
  {
    home.packages = (with pkgs; [
      mpv
    ]);

    programs.kitty = {
      enable = true;
      extraConfig = lib.readFile ../homedir/.config/kitty/kitty.conf;
      package = if pkgs.stdenv.isLinux then myLib.wrapWithNixGLFull pkgs.nixGL pkgs.kitty else pkgs.kitty;
    };

    programs.firefox.enable = true;

  };
}
