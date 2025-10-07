{ inputs, config, ... }:
{

  hosts.macbookpro = {
    user = "antoine.carnec";
    hostname = "LONLTMC773WR0";
    isNixos = false;
    isDesktop = true;
    homedir = "/Users/antoine.carnec";
    extras.symbol = "λ";
  };

  flake.homeConfigurations."LONLTMC773WR0" =
    let
      system = "aarch64-darwin";
      pkgs = import inputs.nixpkgs { inherit system; };
      homeManagerCfg = config.flake.modules.homeManager;
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = with homeManagerCfg; [
        base
        cli
        desktop
        secrets
        work
      ];

      extraSpecialArgs = {
        host = config.hosts.macbookpro;
        info = config.info;
        myLib = config.flake.lib;
        inherit system inputs pkgs;
      };
    };
}
