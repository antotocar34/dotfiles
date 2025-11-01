{ inputs, ... }:
{
  flake.modules.homeManager.cli =
    {
      host,
      pkgs,
      lib,
      system,
      ...
    }@args:
    {
      home.sessionVariables = 
      let
        inherit (lib.strings) join;
        nixpkgs="nixpkgs=${pkgs.path}";
        home-manager="home-manager=${inputs.home-manager.outPath}";
        # acpkgs="acpkgs=${inputs.acpkgs.outPath}"; Need to add flake-compat
        configFlake="config-flake=${./..}"; # options don't work because of flake-parts
        hostname="hostname=${host.hostname}";
        # select="select=${inputs.nix-select.packages.${system}.default}";
      in
      {
        NIX_PATH = join ":" [nixpkgs home-manager configFlake hostname];
      };

      nix = lib.mkIf (!host.isNixos) {
        package = pkgs.nix;
        # TODO: Couldn't make this work well
        # package = 
        # if !pkgs.stdenv.isDarwin 
        #   then pkgs.nix 
        #   else inputs.determinate-nix.packages.${system}.nix; # TODO can I replace this with determinate nix when necessary?
        settings = {
          # Better defaults
          experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];
          warn-dirty = false;
          log-lines = 25;
          sandbox = "relaxed";
          build-use-sandbox = "true";
          min-free = 128000000;
          max-free = 1000000000;
          max-jobs = "auto";
          auto-optimise-store = true;
          fallback = true;
          keep-outputs = true;
        };
        registry = {
          nixpkgs.flake = inputs.nixpkgs;
          acpkgs.flake = inputs.acpkgs;
          home-manager.flake = inputs.home-manager;
        };
        extraOptions = ''
          !include ${host.homedir}/.config/nix/github-auth-token.conf
        '';
      };
    };
}
