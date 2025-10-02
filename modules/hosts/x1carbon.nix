{ inputs, config, ... }:
{

hosts.x1carbon = {
  user = "carneca";
  hostname = "x1carbon";
  isNixos = false;
  isDesktop = true;
  homedir = "/home/carneca";
};

flake.homeConfigurations."x1carbon" =
  let
    system = "x86_64-linux";
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
    ];

    extraSpecialArgs = {
      host = config.hosts.x1carbon;
      info = config.info;
      myLib = config.flake.lib;
      inherit system inputs;
    };
  };
}
