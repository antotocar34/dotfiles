{config, inputs}:
{
  user,
  hostname,
  system,
  symbol,
  homeManagerModules,
  isDesktop ? true,
  isNixos ? false,
}:
let
  lib = inputs.nixpkgs.lib;
  isDarwin = lib.strings.hasInfix "darwin" system;
in
  {
    hosts.${hostname} = {
      inherit user hostname isNixos isDesktop;
      homedir = if isDarwin then "/Users/${user}" else "/home/${user}";
      extras.symbol = symbol;
    };

    flake.homeConfigurations.${hostname} =
      let
        pkgs = import inputs.nixpkgs { inherit system; };
        homeManagerCfg = config.flake.modules.homeManager;
      in
      inputs.home-manager.lib.homeManagerConfiguration {

        inherit pkgs;

        modules = 
        let
          moduleAttrs = lib.filterAttrs (name: _: lib.elem name homeManagerModules) homeManagerCfg;
        in
        lib.attrValues moduleAttrs;


        extraSpecialArgs = {
          host = config.hosts.${hostname};
          info = config.info;
          myLib = config.flake.lib;
          acpkgs = inputs.acpkgs.packages.${system};
          inherit system inputs pkgs;
        };
      };
    }
