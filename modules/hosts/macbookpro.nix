{
  config,
  lib,
  inputs,
  ...
}:
let
  mkHomeConfiguration = import ./_mkHomeConfiguration.nix { inherit config inputs; };
  hostname = "LONLTMC773WR0";
  configuration = mkHomeConfiguration {
    user = "antoine.carnec";
    inherit hostname;
    system = "aarch64-darwin";
    symbol = "λ";
    homeManagerModules = [
      "base"
      "cli"
      "desktop"
      "secrets"
      "work"
      hostname
    ];
    isDesktop = true;
    isNixos = false;
  };
in
lib.recursiveUpdate configuration {
  flake.modules.homeManager.${hostname} =
    {
      config,
      host,
      lib,
      ...
    }:
    {
      age.identityPaths = lib.mkBefore [ "${host.homedir}/.ssh/age.mac.noauth" ];
    };
}
