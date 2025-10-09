{
  description = "home configuration flake";

  nixConfig.extra-substituters = [ "https://antoinecarnec.cachix.org/" ];
  nixConfig.extra-trusted-public-keys = [ "antoinecarnec.cachix.org-1:wQ75D1HEpoDPkzyOIIXJQk3nQRVMwE0NaQi/lPVlE7E=" ];

  inputs = {
    self.submodules = true;

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    acpkgs.url = "github:antotocar34/acpkgs";
    # acpkgs.nixpkgs.follows = "nixpkgs"; # setting this means that acpkgs might not hit the cachix binary cache 

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-neovim = {
      url = "github:antotocar34/nvim-nix";
    };

    agenix= {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # dotfiles-private = {
    #   url = "git+ssh://git@github.com/antotocar34/dotfiles-private";
    #   flake = false;
    #   # url = "path:private";
    # };

    # This captures my plasma settings
    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    monaco-nf.url = "github:thep0y/monaco-nerd-font";
    monaco-nf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      
      systems = [
        # "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        # "x86_64-darwin"
      ];

      imports = [
        (inputs.import-tree ./modules)
      ];

      perSystem = { system, ... }:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          devShells.default = pkgs.callPackage ./shell.nix {};
        };
    };
}
