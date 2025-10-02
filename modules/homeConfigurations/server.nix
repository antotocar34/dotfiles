{ inputs, config, ... }:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs { inherit system; };
  user = "TBD::user";
  hostname = "TBD::hostname";
in {
  flake.homeConfigurations."server" =
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
      ];
      extraSpecialArgs = {
        host = {
          inherit user;
          host = hostname;
          homedir = "/home/${user}";
          isNixos = false;
          isDesktop = false;
        };
      };
    };
}
