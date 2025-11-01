{
  flake.modules.homeManager.desktop =
    {
      inputs,
      system,
      pkgs,
      lib,
      myLib,
      ...
    }:
    {

      home.packages = (
        with pkgs;
        [
          mpv
        ]
      );

      programs.kitty =
        let
          nixGL = inputs.nixgl.packages.${system}.default;
        in
        {
          enable = true;
          extraConfig = "include kitty_extra.conf"; # lib.readFile ../homedir/.config/kitty/_kitty.confkitty.conf;
          package = if pkgs.stdenv.isLinux then myLib.wrapWithNixGL pkgs nixGL pkgs.kitty else pkgs.kitty;
        };

      programs.firefox.enable = true;

    };
}
