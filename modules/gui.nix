{
  flake.modules.homeManager.gui = {config, pkgs, lib, host, ...}:
  {
    home.packages = lib.mkIf host.isDesktop (with pkgs; [
      mpv
    ]);

    programs.kitty = {
      enable = host.isDesktop;
      extraConfig = lib.readFile ../homedir/.config/kitty/kitty.conf;
      # TODO impelment nixGL
      # package = if pkgs.stdenv.isLinux then ml.wrapWithNixGLFull pkgs.nixGL pkgs.kitty else pkgs.kitty;
    };

    programs.firefox.enable = host.isDesktop;

  };
}
