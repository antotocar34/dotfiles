{ inputs, config, ... }:
let
  # TODO do I need system here?
  # Maybe I can set _module.args.pkgs in a perSystem call and that would be enough 
  
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs { inherit system; };
  # lib = inputs.nixpkgs.lib;
  # use = names:
  #   lib.attrValues (lib.getAttrs names config.flake.modules.homeManager);
  homeManagerCfg = config.flake.modules.homeManager;
in {
  flake.homeConfigurations."antoine.carnec@LONLTMC773WR0" =
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
        inherit system;
      };
    };
}
