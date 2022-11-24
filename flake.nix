{
  description = "home configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Managing secrets
    homeage = {
      # url = "github:jordanisaacs/homeage";
      url = "github:spikespaz/homeage";
      # Optional
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

    nixgl.url = "github:guibou/nixGL" ;
  };


  outputs = { self, nixpkgs, home-manager, homeage, plasma-manager, nixgl, comma}:
    let
      system = "x86_64-linux";
      user = "carneca";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ 
          nixgl.overlay 
          (self: super: {
            nixGL = nixgl.defaultPackage.${system}.nixGLIntel ;
            comma = comma.packages.${system}.comma;
          })
          # neovim-flake.overlays.default
      ];
      };

      myLib = import ./lib { inherit pkgs; };

      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

    in {
      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs ;

          modules = [ 
            ./home.nix 
            self.inputs.plasma-manager.homeManagerModules.plasma-manager
            homeage.homeManagerModules.homeage
          ] ;
          extraSpecialArgs = { inputs = self.inputs; inherit myLib ;} ; # Pass in any flakes to home.nix
      };

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
      });

    };
}
