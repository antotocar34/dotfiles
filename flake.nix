{
  description = "home configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    acpkgs.url = "github:antotocar34/acpkgs";
    acpkgs.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Managing secrets
    homeage = {
      url = "github:antotocar34/homeage";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # This captures my plasma settings
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    acpkgs,
    home-manager,
    homeage,
    plasma-manager,
    nixgl,
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        nixgl.overlay
        (_: _: {
          nixGL = nixgl.defaultPackage.${system}.nixGLIntel;
        })
        acpkgs.overlays.default
      ];
    };

    myLib = import ./lib {inherit pkgs;};

    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in {
    homeConfigurations."antoine.carnec@LONLTMC773WR0" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "aarch64-darwin"; };
      modules = [
        ./home.nix
        ./modules/host_specific
        ./modules/clipkgs
        ./modules/clipkgs/mac.nix
        ./modules/guipkgs
        ./modules/secrets
        # ./modules/nix
        homeage.homeManagerModules.homeage
        {
          config.host.user = "antoine.carnec";
          config.host.hostname = "LONLTMC773WR0";
          config.homedir = "/Users/antoine.carnec";
          config.host.isNixos = false;
          config.host.isDesktop = true;
        }
      ];
    };
    homeConfigurations."carneca@x1carbon" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      modules = [
        ./home.nix
        ./modules
        ./modules/plasma
        plasma-manager.homeManagerModules.plasma-manager
        homeage.homeManagerModules.homeage
        {
          config.host.isNixos = false;
          config.host.isDesktop = true;
          config.host.user = "carneca";
          config.host.hostname = "x1carbon";
          config.homedir = "/home/carneca";
        }
      ];

      extraSpecialArgs = {
        inherit myLib inputs;
      };
    };

    devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix {};
    });
  };
}
