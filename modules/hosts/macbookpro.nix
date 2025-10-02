{ inputs, config, ... }:
{

  hosts.macbookpro = {
    user = "antoine.carnec";
    hostname = "LONLTMC773WR0";
    isNixos = false;
    isDesktop = true;
    homedir = "/Users/antoine.carnec";
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
        home
        base
        cli
        desktop
      ];

      extraSpecialArgs = {
        host = config.hosts.macbookpro;
        info = config.info;
        inherit system inputs;
      };
    };
}
