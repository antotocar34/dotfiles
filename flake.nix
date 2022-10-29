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
      url = "github:jordanisaacs/homeage";
      # Optional
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # This captures my plasma settings
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    nixgl.url = "github:guibou/nixGL" ;
  };


  outputs = { self, nixpkgs, home-manager, homeage, plasma-manager, nixgl }:
    let
      system = "x86_64-linux";
      user = "carneca";
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixgl.overlay ];
      };

      myLib = import ./lib { inherit pkgs; };

    in {
      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs ;

          modules = [ 
            ./home.nix 
            self.inputs.plasma-manager.homeManagerModules.plasma-manager
            homeage.homeManagerModules.homeage
          ] ;
          extraSpecialArgs = { inherit nixgl myLib ;} ; # Pass in any flakes to home.nix
      };

    };
}
