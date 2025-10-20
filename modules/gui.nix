{
  flake.modules.homeManager.desktop =
    {
      inputs,
      config,
      system,
      pkgs,
      lib,
      myLib,
      host,
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
          extraConfig = lib.readFile ../homedir/.config/kitty/kitty.conf;
          package = if pkgs.stdenv.isLinux then myLib.wrapWithNixGL pkgs nixGL pkgs.kitty else pkgs.kitty;
        };

      programs.firefox.enable = true;

    };
}
