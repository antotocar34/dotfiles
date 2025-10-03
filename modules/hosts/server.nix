{ inputs, config, ... }:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs { inherit system; };
  user = builtins.readFile ./.server.user;
  hostname = builtins.readFile ./.server.hostname;
in {
  hosts.server = {
    inherit user;
    host = hostname;
    homedir = "/home/${user}";
    isNixos = false;
    isDesktop = false;
    extras.symbol = ">";
  };

  flake.homeConfigurations."server" =
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = with config.flake.modules.homeManager; [ 
        base
        cli
      ];
      extraSpecialArgs = {
        host = config.hosts.server;
        info = config.info;
        myLib = config.flake.lib;
        inherit system inputs pkgs;
      };

    };
  }
