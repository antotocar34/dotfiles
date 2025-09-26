{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  l = lib // builtins;
in {
  nix = l.mkIf (! config.host.isNixos) {
    package = pkgs.nix;
    settings = {
      # Better defaults
      experimental-features = ["nix-command" "flakes"];
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
    };
    extraOptions = ''
    !include ${config.homedir}/.config/nix/github-auth-token.conf
    '';
  };
}
