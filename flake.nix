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
      url = "github:jordanisaacs/homeage";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comma = {
      url = "github:nix-community/comma";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim-flake = {
    #   url = "path:/home/carneca/Documents/projects/neovim-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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
    comma,
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        nixgl.overlay
        (_: _: {
          nixGL = nixgl.defaultPackage.${system}.nixGLIntel;
          comma = comma.packages.${system}.comma;
        })
        # neovim-flake.overlays.default
        acpkgs.overlays.default
      ];
    };

    myLib = import ./lib {inherit pkgs;};

    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in {
    homeConfigurations."carneca" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./home.nix
        ./modules
        plasma-manager.homeManagerModules.plasma-manager
        homeage.homeManagerModules.homeage
        {
          config.host.isNixos = false;
          config.host.isDesktop = true;
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
