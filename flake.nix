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

    my-neovim = {
      url = "github:antotocar34/nvim-nix";
    };

    # Managing secrets
    homeage = {
      url = "github:antotocar34/homeage";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    private-secrets = {
      url = "git+ssh://git@github.com/antotocar34/dotfiles-private";
      flake = false; 
    };

    # This captures my plasma settings
    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
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
        "${inputs.private-secrets}/modules"
        # ./modules/nix
        inputs.homeage.homeManagerModules.homeage
        inputs.nix-index-database.homeModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
        {
          config.host.user = "antoine.carnec";
          config.host.hostname = "LONLTMC773WR0";
          config.homedir = "/Users/antoine.carnec";
          config.host.isNixos = false;
          config.host.isDesktop = true;
        }
      ];
    };

    homeConfigurations."carneca@x1carbon" = 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { 
        system = system; 
        overlays = [
          inputs.nixgl.overlay
          (_: _: {
            nixGL = inputs.nixgl.defaultPackage.${system}.nixGLIntel;
          })
          inputs.acpkgs.overlays.default
        ];
      };
      myLib = import ./lib {inherit pkgs;};
      
    in
    home-manager.lib.homeManagerConfiguration {

      inherit pkgs;

      modules = [
        ./home.nix
        ./modules
        ./modules/guipkgs/linux.nix
        # ./modules/plasma
        # inputs.plasma-manager.homeManagerModules.plasma-manager
        inputs.homeage.homeManagerModules.homeage
        inputs.nix-index-database.homeModules.nix-index
        "${inputs.private-secrets}/modules"
        { 
          programs.nix-index-database.comma.enable = true; 
        }
        {
          config.host.isNixos = false;
          config.host.isDesktop = true;
          config.host.user = "carneca";
          config.host.hostname = "x1carbon";
          config.homedir = "/home/carneca";
        }
        {
          home.packages = [ inputs.my-neovim.packages.${system}.neovim ];
        }
      ];

      extraSpecialArgs = {
        inherit myLib inputs;
      };
    };
    homeConfigurations."server" = 
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      user = "error";
      hostname = "error";
    in
    home-manager.lib.homeManagerConfiguration {

      inherit pkgs;

      modules = [
        ./home.nix
        ./modules/host_specific
        ./modules/nix
        ./modules/clipkgs
        ./modules/clipkgs/linx.nix
        inputs.homeage.homeManagerModules.homeage
        {
          config.host.isNixos = false;
          config.host.isDesktop = true;
          config.host.user = user;
          config.host.hostname = hostname;
          config.homedir = "/home/${user}";
        }
      ];

      extraSpecialArgs = {
        inherit inputs;
      };
    };

    devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix {};
    });
  };
}
