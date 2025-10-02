{ inputs, config, ... }:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs { inherit system; };
  user = "TBD::user";
  hostname = "TBD::hostname";
in {
  hosts.server = {
    inherit user;
    host = hostname;
    homedir = "/home/${user}";
    isNixos = false;
    isDesktop = false;
  };

  flake.homeConfigurations."server" =
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ];
      extraSpecialArgs = {
        host = config.host.server;      
        inherit system inputs;
      };
    };
}
