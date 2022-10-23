{
  description = "home configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      user = "carneca";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs ;

          modules = [ ./home.nix ] ;

      };
    };
}
