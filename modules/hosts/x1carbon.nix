{config, inputs, lib,...}:
let
  mkHomeConfiguration = import ./_mkHomeConfiguration.nix {inherit config inputs;};
  hostname = "x1carbon";
  configuration = mkHomeConfiguration {
    user = "carneca";
    inherit hostname;
    system = "x86_64-linux";
    symbol = "ξ";
    homeManagerModules = [ "base" "cli" "cli-linux" "desktop" "secrets"];
    isDesktop = false;
    isNixos = false;
  };
in
lib.recursiveUpdate configuration
{
  flake.modules.homeManager.${hostname} = {config, host, lib, ...}: {
    # age.identityPaths = lib.mkBefore ["${host.homedir}/.ssh/age.mac.noauth"];
  };
}
