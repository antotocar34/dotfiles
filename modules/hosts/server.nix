{
  config,
  inputs,
  lib,
  ...
}:
let
  mkHomeConfiguration = import ./_mkHomeConfiguration.nix { inherit config inputs; };
  hostname = "server";
  configuration = mkHomeConfiguration {
    user = lib.fileContents ./.server.user;
    hostname = lib.fileContents ./.server.hostname;
    system = "x86_64-linux";
    symbol = ">";
    homeManagerModules = [
      "base"
      "cli"
    ];
    isDesktop = false;
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
      # age.identityPaths = lib.mkBefore ["${host.homedir}/.ssh/age.mac.noauth"];
    };
}
